From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT, not doing route_me_harder?
Date: Wed, 26 Jun 2002 12:18:38 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020626101838.GA9824@balabit.hu>
References: <20020626084136.GA25908@balabit.hu> <200206261113.16886.hno@marasystems.com> <20020626095557.GB4140@balabit.hu> <200206261204.23831.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206261204.23831.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 26, 2002 at 12:04:23PM +0200, Henrik Nordstrom wrote:
> Balazs Scheidler wrote:
> > I think I now understand, have my packets marked in local OUTPUT, route
> > based on that mark, and SNAT based on the marks. Is this the way you
> > suggested? Hmm.. this sounds reasonable on the programmer's perspective,
> > but is difficult to maintain from the user's: it needs two rules.
> 
> Yes, it requires three custom rules rather than two (there is also the routing 
> policy rule)
> 
> Having NAT reroute all packets due to source nat transformations would be a 
> significant performance impact only to support the corner cases where it is 
> handy..

Why? The rerouting would be triggered only if the user requests it, so
normal path would not be affected. And as routing decisions are heavily
cached, it is said (I think it was Harald who said that) that routing
decisions are not expensive. It would add a simple bit-test in normal path,
and a second routing decision if explicitly requested:

something like this in ip_nat_fn(), after do_bindings is called:

	saddr = (*pskb)->nh.iph->saddr;
	daddr = (*pskb)->nh.iph->daddr;

	ret = do_bindings(ct, ctinfo, info, hooknum, pskb);
	if (ret != NF_DROP && ret != NF_STOLEN && (ct->flags & IP_NAT_REROUTE)) {
	        if (((*pskb)->nh.iph->saddr != saddr || (*pskb)->nh.iph->daddr != daddr))
	                ret = (ip_route_me_harder(pskb) == 0) ? ret : NF_DROP;
	
	}
	return ret;

This could also be extended with the local output case, so ip_nat_fn() and
ip_nat_local_fn() could be merged. (the if condition would become:

if (ret != NF_DROP && ret != NF_STOLEN && (hooknum == NF_IP_LOCAL_OUT || ct->flags & IP_NAT_REROUTE)) {
	...
}


-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
