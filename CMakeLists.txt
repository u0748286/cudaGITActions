cmake_minimum_required(VERSION 3.10)
project(CudaOpenGLActions)

# 设置 GLFW 路径
set(CMAKE_PREFIX_PATH "/usr/lib/x86_64-linux-gnu/cmake/glfw3")  # 设置 GLFW 的路径

# 查找依赖库
find_package(CUDA REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
# 使用 pkg-config 来查找 GLFW
find_package(PkgConfig REQUIRED)
pkg_check_modules(GLFW REQUIRED glfw3)

# 添加 include 路径
include_directories(${OPENGL_INCLUDE_DIR} ${GLEW_INCLUDE_DIR} ${GLFW_INCLUDE_DIR})

# 指定 CUDA 标准版本
set(CMAKE_CUDA_STANDARD 11)

# 指定源文件
set(SOURCE_FILES "${SOURCE_DIR}/kernel.cu")

# 添加可执行文件
add_executable(CudaOpenGLActions ${SOURCE_FILES})

# 指定链接库
target_link_libraries(CudaOpenGLActions glfw GLEW ${OPENGL_LIBRARIES})

# 启用 CUDA 可分离编译
set_target_properties(CudaOpenGLActions PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
