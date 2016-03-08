From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: ipset: Check IPSET_ATTR_ETHER netlink
 attribute length
Date: Tue, 8 Mar 2016 22:46:48 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603082243030.20978@blackhole.kfki.hu>
References: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu> <1457466260-20373-2-git-send-email-kadlec@blackhole.kfki.hu> <56DF3593.7020507@iogearbox.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50493 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbcCHVqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 16:46:08 -0500
In-Reply-To: <56DF3593.7020507@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Daniel,

On Tue, 8 Mar 2016, Daniel Borkmann wrote:

> On 03/08/2016 08:44 PM, Jozsef Kadlecsik wrote:
> > Julia Lawall pointed out that IPSET_ATTR_ETHER netlink attribute length
> > was not checked explicitly, just for the maximum possible size. Malicious
> > netlink clients could send shorter attribute and thus resulting a kernel
> > read after the buffer.
> > 
> > The patch adds the explicit length checkings.
> > 
> > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >   net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 ++
> >   net/netfilter/ipset/ip_set_hash_mac.c     | 3 ++-
> >   2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > index 29dde20..9a065f6 100644
> > --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> > @@ -267,6 +267,8 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr
> > *tb[],
> > 
> >   	e.id = ip_to_id(map, ip);
> >   	if (tb[IPSET_ATTR_ETHER]) {
> > +		if (nla_len(tb[IPSET_ATTR_ETHER]) != ETH_ALEN)
> > +			return -IPSET_ERR_PROTOCOL;
> 
> Any reason to not just remove the 'NLA_BINARY' from the policy?
> 
> include/net/netlink.h +191:
> 
>  * Meaning of `len' field:
> [...]
>  *    NLA_BINARY           Maximum length of attribute payload
> [...]
>  *    All other            Minimum length of attribute payload
> 
> validate_nla() will just do the right thing and check for minlen.

The exact payload length must be checked anyway, because we copy the 
attribute into a buffer[ETH_ALEN]. So that'd mean a bigger patch :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
