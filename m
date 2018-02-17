From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 23:38:18 +0100
Message-ID: <20180217223818.GC13493@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
 <20180216161408.GA3776@breakpoint.cc>
 <20180216.173354.347842978561257782.davem@davemloft.net>
 <20180217201015.GA13493@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, daniel@iogearbox.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        alexei.starovoitov@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180217201015.GA13493@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> David Miller <davem@davemloft.net> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > Date: Fri, 16 Feb 2018 17:14:08 +0100
> > 
> > > Any particular reason why translating iptables rather than nftables
> > > (it should be possible to monitor the nftables changes that are
> > >  announced by kernel and act on those)?
> > 
> > As Daniel said, iptables is by far the most deployed of the two
> > technologies.  Therefore it provides the largest environment for
> > testing and coverage.
> 
> Right, but the approach of hooking old blob format comes with
> lots of limitations that were meant to be resolved with a netlink based
> interface which places kernel in a position to mediate all transactions
> to the rule database (which isn't fixable with old setsockopt format).
> 
> As all programs call iptables(-restore) or variants translation can
> be done in userspace to nftables so api spoken is nfnetlink.
> Such a translator already exists and can handle some cases already:
> 
> nft flush ruleset
> nft list ruleset | wc -l
> 0
> xtables-compat-multi iptables -A INPUT -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
> xtables-compat-multi iptables -A REJECT_LOG -i eth0 -p tcp --tcp-flags SYN,ACK SYN --dport 22:80 -m limit --limit 1/sec -j LOG --log-prefix "RejectTCPConnectReq"

to be fair, for these two I had to use
$(xtables-compat-multi iptables-translate -A INPUT -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT)

Reason is that the 'iptables-translate' part nowadays has way more
translations available (nft gained many features since the
iptables-compat layer was added).

If given appropriate prioriy however it should be pretty
trivial to make the 'translate' descriptions available in
the 'direct' version, we already have function in libnftables
to execute/run a command directly from a buffer so this would
not even need fork/execve overhead (although I don't think
its a big concern).

> (f.e. nftables misses some selinux matches/targets for netlabel so we obviously
> can't translate this, same for ipsec sa/policy matching -- but this isn't
> impossible to resolve).

I am working on some poc code for the sa/policy thing now.
