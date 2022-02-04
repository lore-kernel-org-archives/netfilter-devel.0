Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45A5C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 04:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356633AbiBDEme (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:42:34 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49036 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBDEme (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 23:42:34 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 31C1960195;
        Fri,  4 Feb 2022 05:42:28 +0100 (CET)
Date:   Fri, 4 Feb 2022 05:42:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/2] netfilter: conntrack: re-init state for
 retransmitted syn-ack
Message-ID: <YfyutjS49exLZwma@salvia>
References: <20220129164701.175221-1-fw@strlen.de>
 <20220129164701.175221-2-fw@strlen.de>
 <8388b8bd-3c41-a8ec-c338-28be9491fa74@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8388b8bd-3c41-a8ec-c338-28be9491fa74@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 29, 2022 at 09:25:05PM +0100, Jozsef Kadlecsik wrote:
> Hi Florian,
> 
> On Sat, 29 Jan 2022, Florian Westphal wrote:
> 
> > TCP conntrack assumes that a syn-ack retransmit is identical to the
> > previous syn-ack.  This isn't correct and causes stuck 3whs in some more
> > esoteric scenarios.  tcpdump to illustrate the problem:
> > 
> >  client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083035583 ecr 0,wscale 7]
> >  server > client: Flags [S.] seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215367629 ecr 2082921663]
> > 
> > Note the invalid/outdated synack ack number.
> > Conntrack marks this syn-ack as out-of-window/invalid, but it did
> > initialize the reply direction parameters based on this packets content.
> > 
> >  client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083036623 ecr 0,wscale 7]
> > 
> > ... retransmit...
> > 
> >  server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215368644 ecr 2082921663]
> > 
> > and another bogus synack. This repeats, then client re-uses for a new
> > attempt:
> > 
> > client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083100223 ecr 0,wscale 7]
> > server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215430754 ecr 2082921663]
> > 
> > ... but still gets a invalid syn-ack.
> > 
> > This repeats until:
> > 
> >  server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215437785 ecr 2082921663]
> >  server > client: Flags [R.], seq 145824454, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215443451 ecr 2082921663]
> >  client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083115583 ecr 0,wscale 7]
> >  server > client: Flags [S.], seq 162602410, ack 2375731742, win 65535, [mss 8952,wscale 5,TS val 3215445754 ecr 2083115583]
> > 
> > This syn-ack has the correct ack number, but conntrack flags it as
> > invalid: The internal state was created from the first syn-ack seen
> > so the sequence number of the syn-ack is treated as being outside of
> > the announced window.
> 
> I can only assume that the client is/are behind like a carrier-grade NAT
> and the bogus SYN-ACK sent by the server is replying a connection attempt 
> from another client. Yes, the best thing to do is to reinit the state.
> 
> > Don't assume that retransmitted syn-ack is identical to previous one.
> > Treat it like the first syn-ack and reinit state.
> > 
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Applied, thanks
