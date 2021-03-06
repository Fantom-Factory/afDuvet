using afIocConfig

** [IoC Config]`pod:afIocConfig` values for 'Duvet'.
const mixin DuvetConfigIds {
	
	** The base URL (local to BedSheet) where [RequireJS]`http://requirejs.org/` / AMD modules are loaded from. 
	** It should be mapped by BedSheet's 'FileHandler' service as this is where you save your Javascript modules.
	**   
	** Override this URL should it conflict with an existing BedSheet Route.
	** 
	** Defaults to '`/modules/`'.
	static const Str baseModuleUrl	:= "afDuvet.baseModuleUrl"

	** The URL that the [RequireJS]`http://requirejs.org/` library will be served under. 
	** Override it should it conflict with an existing BedSheet Route.
	** 
	** Defaults to '`/scripts/require-2.3.5.js`'.
	static const Str requireJsUrl	:= "afDuvet.requireJsUrl"

	** The URL that the [TimeZone database]`http://fantom.org/forum/topic/2548` will be served under. 
	** Override it should it conflict with an existing BedSheet Route.
	** 
	** Defaults to '`/scripts/tz.js`'.
	static const Str tzJsUrl	:= "afDuvet.tzJsUrl"
	
	** The file that will be served under the [RequireJS]`http://requirejs.org/` URL. 
	** Override it should you wish to serve a custom / updated version of [RequireJS]`http://requirejs.org/`.
	** 
	** Defaults to '`fan://afDuvet/res/require-2.3.5.js`.get'.
	static const Str requireJsFile	:= "afDuvet.requireJsFile"
	
	** How long RequireJs waits before giving up on loading a script. 
	** Setting it to '0' or 'null' disables the timeout.
	** Equates to the [waitSeconds]`http://requirejs.org/docs/api.html#config-waitSeconds` config option.
	**
	** Defaults to '15sec'.
	static const Str requireJsTimeout	:= "afDuvet.requireJsTimeout"
	
	** By default, Duvet will try to insert RequireJS and other script tags *before* the last '<script>' tag in the HTML. 
	** This allows you to write your own 'require()' script functions at the bottom of the HTML page and still have access to 
	** RequireJS. (Which is handy for quick wins in development).
	** 
	** But inevitably this *smart* insertion will fail at some point, especially if the script contains the character sequence 
	** '</script>' in a comment or similar; it is, after all, just regular expression matching. 
	** 
	** So setting this config to 'true' disables the *(ahem)* *smart* insertion and bangs in all scripts just before the 
	** closing '</body>' tag. 
	static const Str disableSmartInsertion	:= "afDuvet.disableSmartInsertion"

	** When injecting scripts and stylesheets, Duvet will automatically update any 'Content-Security-Policy' header directives 
	** to allow the script to load / run. As this may not always be desired, set to 'false' to disable.
	static const Str updateCspHeader	:= "afDuvet.updateCspHeader"
	
	internal static Void validateConfig(ConfigSource iocConfig) {
		baseModuleUrl := (Uri) iocConfig.get(DuvetConfigIds.baseModuleUrl, Uri#)
		if (!baseModuleUrl.isPathOnly)
			throw ParseErr(ErrMsgs.urlMustBePathOnly("Module Base", baseModuleUrl, `/modules/`))
		if (!baseModuleUrl.isPathAbs)
			throw ParseErr(ErrMsgs.urlMustStartWithSlash("Module Base", baseModuleUrl, `/modules/`))
		if (!baseModuleUrl.isDir)
			throw ParseErr(ErrMsgs.urlMustEndWithSlash("Module Base", baseModuleUrl, `/modules/`))
		
		requireJsUrl := (Uri) iocConfig.get(DuvetConfigIds.requireJsUrl, Uri#)
		if (!requireJsUrl.isPathOnly)
			throw ParseErr(ErrMsgs.urlMustBePathOnly("RequireJS", requireJsUrl, `/scripts/require.js`))
		if (!requireJsUrl.isPathAbs)
			throw ParseErr(ErrMsgs.urlMustStartWithSlash("RequireJS", requireJsUrl, `/scripts/require.js`))
		if (requireJsUrl.isDir)
			throw ParseErr(ErrMsgs.urlMustNotEndWithSlash("RequireJS", requireJsUrl, `/scripts/require.js`))
		
		requireJsFile := (File) iocConfig.get(DuvetConfigIds.requireJsFile, File#)
		if (!requireJsFile.exists)
			throw ParseErr(ErrMsgs.requireJsLibNoExist(requireJsFile))
		
		requireJsTimeout := (Duration?) iocConfig.get(DuvetConfigIds.requireJsTimeout, Duration?#)
		if (requireJsTimeout != null && requireJsTimeout < 0ms)
			throw ParseErr(ErrMsgs.requireJsTimeoutMustBePositive(requireJsTimeout))		
	}
}
