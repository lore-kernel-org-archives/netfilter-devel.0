From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: ebt_ip6: allow matching on ipv6-icmp
 types/codes
Date: Fri, 17 Dec 2010 17:21:10 +0100
Message-ID: <20101217162110.GA9421@Chamillionaire.breakpoint.cc>
References: <20101217152702.GB15737@Chamillionaire.breakpoint.cc>
 <alpine.LNX.2.01.1012171654410.29660@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54895 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab0LQQVL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:21:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1012171654410.29660@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Friday 2010-12-17 16:27, Florian Westphal wrote:
> >
> >+++ ebt_ip6.c
> > 		if (info->bitmask & EBT_IP6_DPORT) {
> >-			u32 dst = ntohs(pptr->dst);
> >+			u32 dst = ntohs(pptr->tcpudphdr.dst);
> 
> The actual field however is smaller, so to me, this looks itching
> to be changed to
> 	uint16_t dst = ntohs(pptr->tcpudphdr.dst);

Indeed.

> >@@ -103,6 +115,14 @@ static int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
> > 		return -EINVAL;
> > 	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] > info->sport[1])
> > 		return -EINVAL;
> >+	if (info->bitmask & EBT_IP6_ICMP6) {
> >+		if ((info->invflags & EBT_IP6_PROTO ||
> >+		     info->protocol != IPPROTO_ICMPV6))
> >+			return -EINVAL;
> 
> Your parenthesis are a little out of balance, it's the & and | that
> are commonly guarded. That probably should have been:
> 
> 		if ((info->invflags & EBT_IP6_PROTO) ||
> 		    info->protocol != IPPROTO_ICMPV6)

Right.

> /* check other places too */

You are right,
    If (foo & bar && baz)

is used in other places as well.

But I would prefer to keep cleanups and functional changes separated.

I will make the u16 and the () changes, however I'll wait a couple of
hours to give others time to speak up.

Thanks for reviewing.
Florian
