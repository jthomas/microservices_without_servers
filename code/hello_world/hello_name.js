function main (params) {
  var user = params.user || "unknown";
  return { message: "Hello " +  user + "!" };
}
