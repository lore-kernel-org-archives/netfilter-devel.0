From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Mon, 7 Sep 2015 12:41:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Imran Zaman <imran.zaman@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:42324 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbIGKln (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 06:41:43 -0400
In-Reply-To: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-09-07 12:42, Imran Zaman wrote:
>@@ -579,7 +580,8 @@ static void *load_extension(const char *search_path, const char *af_prefix,
> 					strerror(errno));
> 				return NULL;
> 			}
>-			if (dlopen(path, RTLD_NOW) == NULL) {
>+			handle = dlopen(path, RTLD_NOW);
>+			if (handle == NULL) {
> 				fprintf(stderr, "%s: %s\n", path, dlerror());
> 				break;
> 			}
>@@ -590,6 +592,7 @@ static void *load_extension(const char *search_path, const char *af_prefix,
> 				ptr = xtables_find_match(name,
> 				      XTF_DONT_LOAD, NULL);
> 
>+			dlclose(handle);
> 			if (ptr != NULL)
> 				return ptr;
> 

Seriously? If you close the handle, then ptr->init will point to
invalid memory and the thing should crash.
