From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] vrf: Fix conntrack-dnat conflict in vrf-device
 PREROUTING  hook
Date: Tue, 15 Jan 2019 07:56:48 +0100
Message-ID: <20190115065648.2m3agatlsgi42un3@salvia>
References: <1547251399-15997-1-git-send-email-wenxu@ucloud.cn>
 <20190114214043.pji6usreyngezczt@salvia>
 <20190114221510.pvge3hmb3qyicry4@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenxu@ucloud.cn, netdev@vger.kernel.org, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114221510.pvge3hmb3qyicry4@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 14, 2019 at 11:15:10PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Jan 12, 2019 at 08:03:19AM +0800, wenxu@ucloud.cn wrote:
> > > From: wenxu <wenxu@ucloud.cn>
> > > 
> > > In the ip_rcv the skb go through the PREROUTING hook first,
> > > Then jump in vrf device go through the same hook again.
> > > When conntrack dnat work with vrf, there will be some conflict for rules.
> > > Because the package go through the hook twice with different nf status
> > 
> > Then, the first hook applies NAT, while the second is simply ignored.
> 
> Yes, but re-entry occurs with munged addresses in case DNAT was applied.
> I'm not sure about this patch either though.
> 
> If vrf is used, then it seems its enough to add a 'meta iifname vr+ accept'
> rule to prevent false matches/re-invocation.

Then this is a misconfiguration issue.

> If the name isn't enough, I think we should consider extending meta to
> query 'interface is vrf' so userspace can add the 'don't re-do entire
> ruleset for vrf' policy itself.

This sounds good, this problem is solved via policy.

> I am not sure kernel should auto-enforce bypass based on conntrack
> state, there is no precedence for this and I don't like
> arbitrarily-chosen behaviour.

Agreed.
