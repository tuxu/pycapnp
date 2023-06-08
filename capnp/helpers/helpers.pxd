from capnp.includes.capnp_cpp cimport (
    Maybe, PyPromise, VoidPromise, RemotePromise,
    DynamicCapability, InterfaceSchema, EnumSchema, StructSchema, DynamicValue, Capability,
    RpcSystem, MessageBuilder, Own, PyRefCounter
)

from capnp.includes.schema_cpp cimport ByteArray

from non_circular cimport reraise_kj_exception

from cpython.ref cimport PyObject

cdef extern from "capnp/helpers/fixMaybe.h":
    EnumSchema.Enumerant fixMaybe(Maybe[EnumSchema.Enumerant]) except +reraise_kj_exception
    StructSchema.Field fixMaybe(Maybe[StructSchema.Field]) except +reraise_kj_exception

cdef extern from "capnp/helpers/capabilityHelper.h":
    PyPromise then(PyPromise promise, Own[PyRefCounter] func, Own[PyRefCounter] error_func)
    DynamicCapability.Client new_client(InterfaceSchema&, PyObject *)
    DynamicValue.Reader new_server(InterfaceSchema&, PyObject *)
    Capability.Client server_to_client(InterfaceSchema&, PyObject *)
    PyPromise convert_to_pypromise(RemotePromise)
    PyPromise convert_to_pypromise(VoidPromise)
    VoidPromise taskToPromise(Own[PyRefCounter] coroutine, PyObject* callback)
    void init_capnp_api()

cdef extern from "capnp/helpers/rpcHelper.h":
    Capability.Client bootstrapHelper(RpcSystem&)
    Capability.Client bootstrapHelperServer(RpcSystem&)

cdef extern from "capnp/helpers/serialize.h":
    ByteArray messageToPackedBytes(MessageBuilder &, size_t wordCount)
