From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] NFQUEUE: use NFPROTO_UNSPEC
Date: Fri, 5 Jun 2009 14:57:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051456050.17010@fbirervta.pbzchgretzou.qr>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38273 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZFEM5H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:57:07 -0400
In-Reply-To: <1244164679-11032-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 03:17, Florian Westphal wrote:
>--- a/extensions/libxt_NFQUEUE.c
>+++ b/extensions/libxt_NFQUEUE.c
>@@ -32,12 +32,12 @@ static void
> parse_num(const char *s, struct xt_NFQ_info *tinfo)
> {
> 	unsigned int num;
>-       
>+
> 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
> 		xtables_error(PARAMETER_PROBLEM,
> 			   "Invalid queue number `%s'\n", s);

Extra line unintended?
