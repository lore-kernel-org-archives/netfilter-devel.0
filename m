From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT, not doing route_me_harder?
Date: Wed, 26 Jun 2002 11:55:57 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020626095557.GB4140@balabit.hu>
References: <20020626084136.GA25908@balabit.hu> <200206261113.16886.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206261113.16886.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> This is done only in the OUTPUT chain, and only because the TCP kernel has 
> already routed locally originating packets before they first hit netfilter.
> 
> > NAT doesn't do anything like this. So given an SNAT rule changes the source
> > address in POSTROUTING, the routing tables are not looked up again, so
> > source address dependant policy routing rules are not applied.
> 
> It sure does, in the same spot as mangle, which only is when there is a 
> destnination nat transformations applied to a locally originated packet.
> 
> in ip_nat_local_fn():
>         ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
>         if (ret != NF_DROP && ret != NF_STOLEN
>             && ((*pskb)->nh.iph->saddr != saddr
>                 || (*pskb)->nh.iph->daddr != daddr))
>                 return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
> 
> For the other cases (including mangle), all the transformations that are 
> assumed to affect routing is done in PREROUTING. SNAT is not among them.
> 
> There is a number of ways to route SNAT:ed packets differently if needed. The 
> method I use is usually to use the nfmark of mangle PREROUTING or OUTPUT in 
> combination with SNAT in POSTROUTING. Mangle marks the packet telling that 
> this should be NAT:ed according to policy X, this nfmark is then used in 
> routing to route the packet in the correct direction and by nat POSTROUTING 
> to apply the correct NAT rule.

But what happens when you initiate a connection on the host running
netfilter, thus you have no PREROUTING chain?

Scenario:

I have a default route to gateway A on interface a, but I want my SMTP
traffic to leave the box on a different interface b with a different gateway
B. Of course this means a different source address is to be assigned to the
outgoing connection. Assume it is not possible to set the bind address of
the MTA (or setting it affects mail delivery in other directions).

I have source based routing, that makes packets go to the correct direction
based on their source address.

If I'm doing SNAT in POSTROUTING, the routing decision is not redone, thus
it leaves with the specified source address, but on the wrong interface.

I think I now understand, have my packets marked in local OUTPUT, route
based on that mark, and SNAT based on the marks. Is this the way you
suggested? Hmm.. this sounds reasonable on the programmer's perspective, but
is difficult to maintain from the user's: it needs two rules.

iptables -t mangle -A OUTPUT -p tcp ! -s <intranet> -d 0/0 --dport 25 -j MARK --set-mark 100
iptables -t nat -A POSTROUTING -m mark --mark 100 -j SNAT --to-source <b ip address>

instead of:

iptables -t nat -A POSTROUTING -p tcp ! -s <intranet> -d 0/0 --dport 25 -m reroute -j SNAT --to-source <b ipaddress>

Hmm... as I think some more, the 2nd case might not even be possible, as the
nat rule is triggered only once during a session, and it would mean that syn
would be routed correctly, but packets following it would not. Solution:
instead of nfcache the flag could be stored in ip_conntrack.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
