From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: patch for addition of "no-change" option for
 xt_quota2
Date: Thu, 31 Dec 2009 16:34:46 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912311629560.17265@obet.zrqbmnf.qr>
References: <1262013837.19823.48.camel@milliways>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Michael Farrell <micolous+nf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33321 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZLaPes (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:34:48 -0500
In-Reply-To: <1262013837.19823.48.camel@milliways>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-12-28 16:23, Michael Farrell wrote:
>
>I've written a patch to add an option to xt_quota2 called "no-change".
>The effect of this option, while it is enabled, is that it will skip
>incrementing or decrementing the quota counter.

I applied the patch, with a number of changes.

>diff --git a/extensions/libxt_quota2.c b/extensions/libxt_quota2.c
>index db144f9..4bbb04b 100644
>--- a/extensions/libxt_quota2.c
>+++ b/extensions/libxt_quota2.c
> static struct xtables_match quota_mt2_reg = {
> 	.family        = AF_UNSPEC,
>-	.revision      = 3,
>+	.revision      = 4,
> 	.name          = "quota2",
> 	.version       = XTABLES_VERSION,
> 	.size          = XT_ALIGN(sizeof (struct xt_quota_mtinfo2)),

The revision number is usually only bumped when a module is imported
from another source. Within changes inside Xt-a there is no need to
bump it, since Xt-a is always upgraded wholesale.

>index fbc8aab..a34dfbf 100644
>--- a/extensions/xt_quota2.c
>+++ b/extensions/xt_quota2.c
>@@ -3,6 +3,8 @@
>  * as a minimal accounting match.
>  * by Jan Engelhardt <jengelh@medozas.de>, 2008
>  *
>+ * no-change option added by Michael Farrell <micolous+nf@gmail.com>, 2009
>+ *
>  * Originally based on xt_quota.c:
>  * 	netfilter module to enforce network quotas
>  * 	Sam Johnston <samj@samj.net>

History goes into the git log, so I moved this out. What is in the files
usually is historic content or original authorship information.

>@@ -264,6 +271,7 @@ module_exit(quota_mt2_exit);
> MODULE_DESCRIPTION("Xtables: countdown quota match; up counter");
> MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
> MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
>+MODULE_AUTHOR("Michael Farrell <micolous+nf@gmail.com>");
> MODULE_LICENSE("GPL");
> MODULE_ALIAS("ipt_quota2");
> MODULE_ALIAS("ip6t_quota2");

I removed this one too since you are not going to take the maintainership
blame if something goes wrong ;-)


Applied as such.

