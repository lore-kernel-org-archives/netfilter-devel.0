From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 17:14:08 +0100
Message-ID: <20180216161408.GA3776@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180216145727.GC32618@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> Several questions spinning at the moment, I will probably come up with
> more:

... and here there are some more ...

One of the many pain points of xtables design is the assumption of 'used
only by sysadmin'.

This has not been true for a very long time, so by now iptables has
this userspace lock (yes, its fugly workaround) to serialize concurrent
iptables invocations in userspace.

AFAIU the translate-in-userspace design now brings back the old problem
of different tools overwriting each others iptables rules.

Another question -- am i correct in that each rule manipulation would
incur a 'recompilation'?  Or are there different mini programs chained
together?

One of the nftables advantages is that (since rule representation in
kernel is black-box from userspace point of view) is that the kernel
can announce add/delete of rules or elements from nftables sets.

Any particular reason why translating iptables rather than nftables
(it should be possible to monitor the nftables changes that are
 announced by kernel and act on those)?
