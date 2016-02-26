From: Florian Westphal <fw@strlen.de>
Subject: Re: batch netlink messages - performance improvement
Date: Fri, 26 Feb 2016 11:04:52 +0100
Message-ID: <20160226100452.GA2148@breakpoint.cc>
References: <dab4ca588cd243b0b36b7b0283bd50dd@XCH-RCD-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbcBZKEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2016 05:04:55 -0500
Content-Disposition: inline
In-Reply-To: <dab4ca588cd243b0b36b7b0283bd50dd@XCH-RCD-014.cisco.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yigal Reiss (yreiss) <yreiss@cisco.com> wrote:
> So I tried batching the unicast netlink messages (carrying the packets) from kernel to user space. I do that by calling sk->sk_data_ready(sk); (in __netlink_sendskb() in af_netlink.c) only every [N] packets. This seems to contribute similar performance improvements as the batch verdict.

Uh?

That makes no sense to me.  Why and how does that help?
Can you share numbers or example program that exhibits
this behaviour?

I'd expect that in most cases (in non-idle case) that
sock_def_readable usually doesn't do anything (skwq_has_sleeper should
be false).

For nfqueue best receipe seems to be
recvmmsg + batch number of vectors read + NFQA_CFG_F_GSO.

> If this suggestion makes sense, how would you suggest proceed with this idea?

I'd first like to understand what is so expensive in sock_def_readable
that this helps in first place.
