From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v4 0/2] ipset: add "inner" flag version support
Date: Mon, 8 Jul 2013 19:02:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307081843001.28827@blackhole.kfki.hu>
References: <51D74772.7000906@googlemail.com> <alpine.DEB.2.00.1307080940420.27310@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:47743 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GHRCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:02:36 -0400
In-Reply-To: <alpine.DEB.2.00.1307080940420.27310@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 8 Jul 2013, Jozsef Kadlecsik wrote:

> On Fri, 5 Jul 2013, Dash Four wrote:
> 
> > This series of 2 patches supplements the previous version (v3) and adds
> > "inner" flag version support to all registered ipset types
> > (kernel + userspace).
> > 
> > Dash Four (2):
> >   ipset: add set match "inner" flag support
> >   ipset (userspace): add "inner" flag version support
> 
> All of your patches (including the previous series) are mangled and I'm 
> unable to apply them. It seems there's an extra space at the beginning of 
> every line starting with a whitespace character or something like that. 
> Please check your patches and resubmit the fixed ones.

Meanwhile, while looking at your code on how to extend it, I have noticed 
two issues:

- From ip_set_get_ip4_inner_hdr and ip_set_get_ip6_inner_hdr you pass back
  the pointer to a local buffer, which is not good. Please move the local
  buffer definitions into all of the functions which call *_inner_hdr.

- The second is an optimization issue: for two or more dimensional
  sets the *_inner_hdr functions are called multiple times instead of 
  once. *_inner_hdr functions should pass back the pointer to the IP
  header/buffer (and use simple ip[46]addrptr inline functions on that) 
  and set protooff for *get_port.

  So it should be something like this:

hash_ipportip4_kadt(...
	const struct hash_ipportip *h = set->data;
	ipset_adtfn adtfn = set->variant->adt[adt];
	struct hash_ipportip4_elem e = { };
	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
	struct iphdr _iph, *iph = &_iph;
	unsigned int protooff = ip_hdrlen(skb);

	if (!ip_set_get_ip4_inner_hdr(skb, &protooff, iph,
				opt->cmdflags & IPSET_FLAG_INNER) ||
	    !ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
				 &e.port, &e.proto, protooff))
		return -EINVAL

	ip4addrptr(iph, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
	ip4addrptr(iph, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
	...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
