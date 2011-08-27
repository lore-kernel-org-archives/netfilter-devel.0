From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: Simplify xtables_parse_interface()
Date: Sat, 27 Aug 2011 18:37:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108271836450.20178@frira.zrqbmnf.qr>
References: <1314451951-27722-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47503 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1H0QhJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Aug 2011 12:37:09 -0400
In-Reply-To: <1314451951-27722-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-08-27 15:32, Richard Weinberger wrote:

>mask is already filled with zeros, there is no need to zero it again.
>diff --git a/iptables/xtables.c b/iptables/xtables.c
>index 233efa3..e72aa28 100644
>--- a/iptables/xtables.c
>+++ b/iptables/xtables.c
>@@ -515,15 +515,13 @@ void xtables_parse_interface(const char *arg, char *vianame,
> 
> 	strcpy(vianame, arg);
> 	if (vialen == 0)
>-		memset(mask, 0, IFNAMSIZ);
>+		return;
>...

Patch taken.
