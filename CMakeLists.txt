cmake_minimum_required(VERSION 3.10)
project(CudaOpenGLActions)

# 查找 GLFW
set(CMAKE_PREFIX_PATH "/usr/lib/x86_64-linux-gnu/cmake/glfw3")  # 设置 GLFW 的路径
find_package(CUDA REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
list(APPEND CMAKE_MODULE_PATH "/usr/lib/x86_64-linux-gnu/cmake/glfw3")
find_package(GLFW3 REQUIRED)

include_directories(${OPENGL_INCLUDE_DIR} ${GLEW_INCLUDE_DIR} ${GLFW_INCLUDE_DIR})

# 指定 CUDA 标准版本
set(CMAKE_CUDA_STANDARD 11)

# 指定源文件
set(SOURCE_FILES kernel.cu)

# 添加可执行文件
add_executable(CudaOpenGLActions ${SOURCE_FILES})

# 指定链接库
target_link_libraries(CudaOpenGLActions glfw GLEW ${OPENGL_LIBRARIES})
set_target_properties(CudaOpenGLActions PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)


