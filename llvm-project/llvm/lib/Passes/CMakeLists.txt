
set(OBFUSCATION_SRS 
  Obfuscation/Utils.cpp
  Obfuscation/CryptoUtils.cpp
  Obfuscation/ObfuscationOptions.cpp
  Obfuscation/BogusControlFlow.cpp
  Obfuscation/IPObfuscationContext.cpp
  Obfuscation/Flattening.cpp
  Obfuscation/StringEncryption.cpp
  Obfuscation/SplitBasicBlock.cpp
  Obfuscation/Substitution.cpp
  Obfuscation/IndirectBranch.cpp
  Obfuscation/IndirectCall.cpp
  Obfuscation/IndirectGlobalVariable.cpp
)

if(BUILD_ANDROID_NDK)

  add_library(Obfuscation MODULE ${OBFUSCATION_SRS} plugin_reg.cpp)
  target_include_directories(Obfuscation PRIVATE ${CMAKE_SOURCE_DIR})
  target_include_directories(Obfuscation PRIVATE ${CMAKE_SOURCE_DIR}/Obfuscation)
  set_target_properties(Obfuscation PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
  )
  target_link_libraries(Obfuscation PRIVATE LLVM)

  if(APPLE)
    set_target_properties(Obfuscation PROPERTIES
        LINK_FLAGS "-undefined dynamic_lookup"
    )

    add_custom_command(
        TARGET Obfuscation POST_BUILD
        COMMAND codesign --force --sign - $<TARGET_FILE:Obfuscation>
        COMMENT "Ad-hoc signing $<TARGET_FILE:Obfuscation> for macOS"
    )
  endif()
else()
  add_llvm_component_library(LLVMPasses
    OptimizationLevel.cpp
    PassBuilder.cpp
    PassBuilderBindings.cpp
    PassBuilderPipelines.cpp
    PassPlugin.cpp
    StandardInstrumentations.cpp

    ${OBFUSCATION_SRS}

    ADDITIONAL_HEADER_DIRS
    ${LLVM_MAIN_INCLUDE_DIR}/llvm
    ${LLVM_MAIN_INCLUDE_DIR}/llvm/Passes

    DEPENDS
    intrinsics_gen

    LINK_COMPONENTS
    AggressiveInstCombine
    Analysis
    CodeGen
    Core
    Coroutines
    IPO
    InstCombine
    IRPrinter
    ObjCARC
    Scalar
    Support
    Target
    TransformUtils
    Vectorize
    Instrumentation
  )

endif()