From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 6/8] netfilter: xtables: use only error codes for
 checkentry
Date: Sat, 20 Mar 2010 14:57:39 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003201454480.6409@obet.zrqbmnf.qr>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de> <1269046942-31719-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33550 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab0CTN5k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:57:40 -0400
In-Reply-To: <1269046942-31719-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-03-20 02:02, Jan Engelhardt wrote:

>Convert the return true/false to integer codes.
>
>Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>---
>--- a/net/netfilter/x_tables.c
>+++ b/net/netfilter/x_tables.c
>@@ -396,8 +396,9 @@ int xt_check_match(struct xt_mtchk_param *par,
> 		ret = par->match->checkentry(par);
> 		if (ret < 0)
> 			return ret;
>-		else if (ret == 0)
>-			return -EINVAL;
>+		else if (ret > 0)
>+			/* Flag up potential errors. */
>+			return -EIO;
> 	}
> 	return 0;
> }

I initially forget to do the same for xt_check_target; that's now been
done and master has been updated to


 net/netfilter/x_tables.c             |   39 ++++++++++++++++---
 ...
 82 files changed, 594 insertions(+), 581 deletions(-)
