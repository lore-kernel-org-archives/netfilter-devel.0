From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Use hotdrop jump mark.
Date: Tue, 18 Jan 2011 08:02:05 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101180801560.9610@obet.zrqbmnf.qr>
References: <1295311017-9105-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53696 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1ARHCH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 02:02:07 -0500
In-Reply-To: <1295311017-9105-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-01-18 01:36, Richard Weinberger wrote:
>index 5c5b6b9..6f5a49d 100644
>--- a/net/netfilter/xt_connlimit.c
>+++ b/net/netfilter/xt_connlimit.c
>@@ -206,8 +206,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
> 
> 	if (connections < 0) {
> 		/* kmalloc failed, drop it entirely */
>-		par->hotdrop = true;
>-		return false;
>+		goto hotdrop;
> 	}
> 
> 	return (connections > info->limit) ^ info->inverse;

Taken, thanks.
