From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
Date: Tue, 29 Jan 2008 18:07:11 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291805540.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr>
 <479F245A.2030509@trash.net> <Pine.LNX.4.64.0801291621000.1185@fbirervta.pbzchgretzou.qr>
 <479F46C9.2010102@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbYA2RHN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:07:13 -0500
In-Reply-To: <479F46C9.2010102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 16:31, Patrick McHardy wrote:
>
>> Anyway, please have this patch on top:
>> 
>> The last u_int32_t should be ok as it stands.
>
> That fixes it, thanks.
>
>

Do you have the typo-fixed version picked?


The bogus one reads:

@@ -210,7 +211,18 @@ static int htable_create(struct xt_hashlimit_info *minfo, int family)
 	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.mode        = minfo->cfg.mode;
+	hinfo->cfg.avg         = minfo->cfg.avg;
+	hinfo->cfg.burst       = hinfo->cfg.burst;
+	hinfo->cfg.max         = hinfo->cfg.max;
+	hinfo->cfg.gc_interval = hinfo->cfg.gc_interval;
+	hinfo->cfg.expire      = hinfo->cfg.expire;
...


the corrected one I sent is:

@@ -210,7 +211,18 @@ static int htable_create(struct xt_hashlimit_info *minfo, int family)
 	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.mode        = minfo->cfg.mode;
+	hinfo->cfg.avg         = minfo->cfg.avg;
+	hinfo->cfg.burst       = minfo->cfg.burst;
+	hinfo->cfg.max         = minfo->cfg.max;
+	hinfo->cfg.gc_interval = minfo->cfg.gc_interval;
+	hinfo->cfg.expire      = minfo->cfg.expire;
...


e.g. always have minfo-> at the right side?

Could you push the outstanding patches to Dave, or give me a git
repository to sync against?

thanks,
Jan
