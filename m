From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/2] NFQUEUE: use NFPROTO_UNSPEC
Date: Fri, 5 Jun 2009 15:23:00 +0200
Message-ID: <20090605132300.GF29745@Chamillionaire.breakpoint.cc>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-2-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0906051456050.17010@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42275 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbZFENW6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:58 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0906051456050.17010@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Friday 2009-06-05 03:17, Florian Westphal wrote:
> >--- a/extensions/libxt_NFQUEUE.c
> >+++ b/extensions/libxt_NFQUEUE.c
> >@@ -32,12 +32,12 @@ static void
> > parse_num(const char *s, struct xt_NFQ_info *tinfo)
> > {
> > 	unsigned int num;
> >-       
> >+
> > 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
> > 		xtables_error(PARAMETER_PROBLEM,
> > 			   "Invalid queue number `%s'\n", s);
> 
> Extra line unintended?

It trims extra whitespace.
