From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT, not doing route_me_harder?
Date: Wed, 26 Jun 2002 11:13:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206261113.16886.hno@marasystems.com>
References: <20020626084136.GA25908@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@lists.samba.org
In-Reply-To: <20020626084136.GA25908@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs Scheidler wrote:
> Hi,
>
> I was wondering what the reason is for NAT not rerouting modified packets?
>
> If anything important is modified by a mangle rule that affects routing,
> the routing decision is automatically redone as this code fragment shows:

[snip]

This is done only in the OUTPUT chain, and only because the TCP kernel has 
already routed locally originating packets before they first hit netfilter.

> NAT doesn't do anything like this. So given an SNAT rule changes the source
> address in POSTROUTING, the routing tables are not looked up again, so
> source address dependant policy routing rules are not applied.

It sure does, in the same spot as mangle, which only is when there is a 
destnination nat transformations applied to a locally originated packet.

in ip_nat_local_fn():
        ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
        if (ret != NF_DROP && ret != NF_STOLEN
            && ((*pskb)->nh.iph->saddr != saddr
                || (*pskb)->nh.iph->daddr != daddr))
                return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;

For the other cases (including mangle), all the transformations that are 
assumed to affect routing is done in PREROUTING. SNAT is not among them.

There is a number of ways to route SNAT:ed packets differently if needed. The 
method I use is usually to use the nfmark of mangle PREROUTING or OUTPUT in 
combination with SNAT in POSTROUTING. Mangle marks the packet telling that 
this should be NAT:ed according to policy X, this nfmark is then used in 
routing to route the packet in the correct direction and by nat POSTROUTING 
to apply the correct NAT rule.

Regards
Henrik
