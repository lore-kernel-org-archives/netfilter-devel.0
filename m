From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 17:33:54 -0500 (EST)
Message-ID: <20180216.173354.347842978561257782.davem@davemloft.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
        <20180216145727.GC32618@breakpoint.cc>
        <20180216161408.GA3776@breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, alexei.starovoitov@gmail.com
To: fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216161408.GA3776@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 16 Feb 2018 17:14:08 +0100

> Any particular reason why translating iptables rather than nftables
> (it should be possible to monitor the nftables changes that are
>  announced by kernel and act on those)?

As Daniel said, iptables is by far the most deployed of the two
technologies.  Therefore it provides the largest environment for
testing and coverage.
