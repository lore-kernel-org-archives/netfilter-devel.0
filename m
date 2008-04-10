From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 01/13] Correct the family member value of libxt_mark
 revision 1
Date: Thu, 10 Apr 2008 09:39:46 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804100939320.8765@fbirervta.pbzchgretzou.qr>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50202 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYDJHjr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:39:47 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-10 09:38, Jan Engelhardt wrote:
>libxt_mark rev1 used AF_INET6 in the class structure where it should
>have used AF_INET.

Argh, obviously wrong one.

>@@ -197,7 +197,7 @@ static struct xtables_match mark_mt6_reg = {
> 	.version        = IPTABLES_VERSION,
> 	.name           = "mark",
> 	.revision       = 1,
>-	.family         = AF_INET6,
>+	.family         = AF_INET,
> 	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
> 	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
> 	.help           = mark_mt_help,
>-- 
