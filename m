From: "Zaman, Imran" <imran.zaman@intel.com>
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Mon, 7 Sep 2015 10:52:22 +0000
Message-ID: <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>,<alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbbIGKwZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 06:52:25 -0400
In-Reply-To: <alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
Content-Language: en-GB
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aah. ookey.. so it needs to be moved two lines below.. 
What about the caller of the function? is it getting closed at any stage?
________________________________________
From: Jan Engelhardt [jengelh@inai.de]
Sent: 07 September 2015 13:41
To: Zaman, Imran
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] fix: resource leakage when loading library using dlopen

On Monday 2015-09-07 12:42, Imran Zaman wrote:
>@@ -579,7 +580,8 @@ static void *load_extension(const char *search_path, const char *af_prefix,
>                                       strerror(errno));
>                               return NULL;
>                       }
>-                      if (dlopen(path, RTLD_NOW) == NULL) {
>+                      handle = dlopen(path, RTLD_NOW);
>+                      if (handle == NULL) {
>                               fprintf(stderr, "%s: %s\n", path, dlerror());
>                               break;
>                       }
>@@ -590,6 +592,7 @@ static void *load_extension(const char *search_path, const char *af_prefix,
>                               ptr = xtables_find_match(name,
>                                     XTF_DONT_LOAD, NULL);
>
>+                      dlclose(handle);
>                       if (ptr != NULL)
>                               return ptr;
>

Seriously? If you close the handle, then ptr->init will point to
invalid memory and the thing should crash.
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

