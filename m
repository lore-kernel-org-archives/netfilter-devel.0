From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: fix the dead loop when meeting unknown
 options
Date: Thu, 14 Apr 2011 09:20:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140919470.30983@obet.zrqbmnf.qr>
References: <1300083811-27146-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47057 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757917Ab1DNHUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:20:03 -0400
In-Reply-To: <1300083811-27146-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-03-14 07:23, Changli Gao wrote:

>Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>---
> xshared.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>diff --git a/xshared.c b/xshared.c
>index 404a9f5..87402b4 100644
>--- a/xshared.c
>+++ b/xshared.c
>@@ -92,7 +92,7 @@ static bool should_load_proto(struct iptables_command_state *cs)
> 	if (find_proto(cs->protocol, XTF_DONT_LOAD,
> 	    cs->options & OPT_NUMERIC, NULL) == NULL)
> 		return true;
>-	return cs->proto_used;
>+	return !cs->proto_used;
> }

Could you, for completeness, give the command that causes the infinite 
loop?

thanks,
Jan
