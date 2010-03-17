From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 21:13:28 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003172021450.16169@obet.zrqbmnf.qr>
References: <20100317184852.89F0DF89BB@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51235 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0CQUN3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:13:29 -0400
In-Reply-To: <20100317184852.89F0DF89BB@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 19:48, Tim Gardner wrote:
> 
>@@ -36,6 +37,7 @@ static void recent_help(void)
> "    --hitcount hits             For check and update commands above.\n"
> "                                Specifies that the match will only occur if source address seen hits times.\n"
> "                                May be used in conjunction with the seconds option.\n"
>+"    --reap                      Remove entries that have expired. Can only be used with --seconds\n"

What's going to happen if you mix a "--reap --seconds 60" rule with
"--reap --seconds 3600" rule?

>+/* Only allowed with --rcheck and --update */
>+#define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
>+
>+#define XT_RECENT_VALID_FLAGS (XT_RECENT_CHECK|XT_RECENT_SET|XT_RECENT_UPDATE|\
>+	XT_RECENT_REMOVE|XT_RECENT_TTL|XT_RECENT_REAP)
>+

Since these two are only used on the kernel side, it would have made 
sense to put them into xt_recent.c only.
