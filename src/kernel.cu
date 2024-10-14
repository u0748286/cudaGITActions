
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <cmath>

const double M_PI = 3.1415926;
const char* vertexShaderSource = R"(
#version 330 core
layout(location = 0) in vec3 aPos;  // 顶点位置
layout(location = 1) in vec3 aColor; // 顶点颜色
out vec3 vertexColor; // 从顶点着色器传递到片段着色器的颜色
uniform float angle;  // 旋转角度

void main()
{
    // 旋转矩阵
    mat4 rotation = mat4(
        cos(angle), -sin(angle), 0.0, 0.0,
        sin(angle), cos(angle), 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );

    gl_Position = rotation * vec4(aPos, 1.0); // 应用旋转
    vertexColor = aColor; // 传递颜色
}
)";

const char* fragmentShaderSource = R"(
#version 330 core
in vec3 vertexColor; // 接收来自顶点着色器的颜色
out vec4 fragColor;  // 输出的片段颜色

void main()
{
    fragColor = vec4(vertexColor, 1.0); // 设置片段颜色
}
)";

float angle = 0.0f; // 初始化旋转角度

int main() {
    // 初始化 GLFW
    if (!glfwInit()) {
        return -1;
    }

    // 创建 OpenGL 3.3 上下文窗口
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    GLFWwindow* window = glfwCreateWindow(800, 600, "OpenGL Rotating Quad", NULL, NULL);
    if (!window) {
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(window);
    glewInit();

    // 定义顶点数据 (两个三角形组成的四边形)
    float vertices[] = {
        // 位置           // 颜色
        -0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f, // 左下角 (红色)
         0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f, // 右下角 (绿色)
         0.5f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f, // 右上角 (蓝色)
         -0.5f,  0.5f, 0.0f,  1.0f, 1.0f, 0.0f  // 左上角 (黄色)
    };

    unsigned int indices[] = {
        0, 1, 2, // 第一个三角形
        0, 2, 3  // 第二个三角形
    };

    unsigned int VBO, VAO, EBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);

    // 绑定 VAO
    glBindVertexArray(VAO);

    // 绑定 VBO
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // 绑定 EBO
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    // 设置顶点属性指针
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);

    // 编译和链接着色器程序
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);

    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    // 删除着色器，因为它们现在已经链接到程序中
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    // 主循环
    while (!glfwWindowShouldClose(window)) {
        // 计算旋转角度
        angle += 0.01f; // 每帧增加旋转角度
        if (angle > 2 * M_PI) angle -= 2 * M_PI; // 确保角度在0到2π之间

        // 清除屏幕
        glClear(GL_COLOR_BUFFER_BIT);

        // 使用着色器程序
        glUseProgram(shaderProgram);

        // 设置旋转角度的 uniform 变量
        glUniform1f(glGetUniformLocation(shaderProgram, "angle"), angle);

        // 绘制四边形 (两个三角形)
        glBindVertexArray(VAO);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

        // 交换缓冲区和轮询事件
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    // 清理资源
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);
    glfwTerminate();
    return 0;
}
