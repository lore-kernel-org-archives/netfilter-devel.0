From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 1/2] netfilter: ipset: Add hash:net,net module to
 kernel.
Date: Fri, 20 Sep 2013 22:23:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309202221140.28758@blackhole.kfki.hu>
References: <1379664834-41326-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379664834-41326-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:46048 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab3ITUXI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:23:08 -0400
In-Reply-To: <1379664834-41326-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This adds a new set that provides the ability to configure pairs of
> subnets. A small amount of additional handling code has been added to
> the generic hash header file - this code is conditionally activated by a
> preprocessor definition.

Patch is applied with a small modification:
[...] 
> +static int
> +hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
> +	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
> +{
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet6_elem e = { .cidr[0] = HOST_MASK,
> +				       .cidr[1] = HOST_MASK };
> +	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
> +	int ret;
> +
> +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> +		return -IPSET_ERR_PROTOCOL;
> +	if (unlikely(tb[IPSET_ATTR_IP_TO]))
> +		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;

The testing of tb[IPSET_ATTR_IP2_TO] was still missing, so I added here.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
