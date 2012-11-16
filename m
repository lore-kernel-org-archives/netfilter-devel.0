From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] Handle the routing changes in the MASQUERADE target
Date: Fri, 16 Nov 2012 11:09:14 +0100
Message-ID: <20121116100914.GB25964@1984>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu>
 <20121115114444.GA31335@1984>
 <alpine.DEB.2.00.1211151532500.7485@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55530 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2KPKJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:09:26 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211151532500.7485@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Thu, Nov 15, 2012 at 03:42:14PM +0100, Jozsef Kadlecsik wrote:
> On Thu, 15 Nov 2012, Pablo Neira Ayuso wrote:
> 
> > Two comments on this patch:
> > 
> > On Tue, Nov 13, 2012 at 09:17:37PM +0100, Jozsef Kadlecsik wrote:
> > > When the routing changes, MASQUERADE should delete the conntrack
> > > entries where the source NATed address changes due to the routing
> > > change. As a first approximation, delete all entries which are
> > > marked with the new "--route-dependent" flag of the MASQUERADE
> > > target.
> > > 
> > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > ---
> > >  include/uapi/linux/netfilter/nf_conntrack_common.h |    4 ++
> > >  include/uapi/linux/netfilter/nf_nat.h              |    1 +
> > >  net/ipv4/netfilter/ipt_MASQUERADE.c                |   40 ++++++++++++++++++++
> > >  3 files changed, 45 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > > index 1644cdd..1c698b5 100644
> > > --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> > > +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > > @@ -87,6 +87,10 @@ enum ip_conntrack_status {
> > >  	/* Conntrack got a helper explicitly attached via CT target. */
> > >  	IPS_HELPER_BIT = 13,
> > >  	IPS_HELPER = (1 << IPS_HELPER_BIT),
> > > +
> > > +	/* Conntrack must be deleted when routing changed (NAT) */
> > > +	IPS_ROUTING_DEPENDENT_BIT = 14,
> > > +	IPS_ROUTING_DEPENDENT = (1 << IPS_ROUTING_DEPENDENT_BIT),
> > 
> > This seems to me a bit too specific for the masquerade module. I've
> > been checking the struct nf_conn_nat to squash that information there,
> > but I don't find the way to make it without increasing the length of
> > the NAT area.
> 
> I know, we waste a status bit. But I couldn't find a better way to store 
> the information in conntrack.
>
> > >  };
> > >  
> > >  /* Connection tracking event types */
> > > diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
> > > index bf0cc37..a0dfac7 100644
> > > --- a/include/uapi/linux/netfilter/nf_nat.h
> > > +++ b/include/uapi/linux/netfilter/nf_nat.h
> > > @@ -8,6 +8,7 @@
> > >  #define NF_NAT_RANGE_PROTO_SPECIFIED	2
> > >  #define NF_NAT_RANGE_PROTO_RANDOM	4
> > >  #define NF_NAT_RANGE_PERSISTENT		8
> > > +#define NF_NAT_ROUTING_DEPENDENT	16
> > >  
> > >  struct nf_nat_ipv4_range {
> > >  	unsigned int			flags;
> > > diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
> > > index 5d5d4d1..ecf3063 100644
> > > --- a/net/ipv4/netfilter/ipt_MASQUERADE.c
> > > +++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
> > 
> > We now have IPv6 NAT support, so I guess you need to patch
> > /net/ipv6/netfilter/ip6t_MASQUERADE.c
> 
> Ohh, yes, I missed that. I'll add the required code there.
> 
> Currently I'm trying to find a way to purge just the entries which are 
> affected by the routing change (for example when there are muliple VPN 
> tunnels). However that requires a new conntrack extension and it's 
> nontrivial (at least for me) to figure out the required data from struct 
> fib_info.
> 
> If the conntrack extension is used then of course the status bit is not 
> required.

We can register now variable length conntrack extensions. I think we
can use that feature to extend nf_conn_nat to allocate extra
information for all working modes of MASQUERADE. It may require
changing the nf_nat_setup_info interface to pass some new flags.

Regarding the variable length conntrack extensions, please check
nf_ct_ext_add_length in net/netfilter/nf_conntrack_helper.c for
instance.
