From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] add hash:ip,mark data type to ipset
Date: Tue, 12 Nov 2013 08:54:14 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311120851460.9471@blackhole.kfki.hu>
References: <1383146590-4626-1-git-send-email-vytas.dauksa@smoothwall.net> <alpine.DEB.2.10.1311112106200.8236@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:53765 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3KLHyS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:54:18 -0500
In-Reply-To: <alpine.DEB.2.10.1311112106200.8236@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 11 Nov 2013, Jozsef Kadlecsik wrote:

> On Wed, 30 Oct 2013, Vytas Dauksa wrote:
> 
> > Introduce packet mark support with new ip,mark hash set. This includes
> > userspace and kernelspace code, hash:ip,mark set tests and updates man
> > page.
> 
> Please give an example which demonstrates the usefulness of the set type.
> 
> See my comments below about the code.
[...]
> > +/* Member elements */
> > +struct hash_ipmark4_elem {
> > +	__be32 ip;
> > +	__be32 mark;
> 
> Mark is in host order, so __u32 is more appropriate.
> 
> > +};
> > +
> > +/* Common functions */
> > +
> > +static inline bool
> > +hash_ipmark4_data_equal(const struct hash_ipmark4_elem *ip1,
> > +			const struct hash_ipmark4_elem *ip2,
> > +			u32 *multi)
> > +{
> > +	return ip1->ip == ip2->ip &&
> > +	       ip1->mark == ip2->mark;
> > +}
> > +
> > +static bool
> > +hash_ipmark4_data_list(struct sk_buff *skb,
> > +		       const struct hash_ipmark4_elem *data)
> > +{
> > +	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
> > +	    nla_put_net32(skb, IPSET_ATTR_MARK, data->mark))

Here a htonl conversion is required for data->mark if mark is stored in 
host order.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
