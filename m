From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] Add hash:net,net ipset for storage of v4/v6 CIDR
 pairs.
Date: Tue, 3 Sep 2013 10:56:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309031048130.2504@blackhole.kfki.hu>
References: <7121481.vIdJUAPkhx@gentoovm> <1377825634-20308-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309022104310.1199@blackhole.kfki.hu> <1456379.dYSmDFJkLx@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:55682 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab3ICI41 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:56:27 -0400
In-Reply-To: <1456379.dYSmDFJkLx@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 3 Sep 2013, Oliver wrote:

> > > +static inline void
> > > +hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem, struct
> > > hash_netnet4_elem *orig) +{
> > > +	elem->ip2 = orig->ip2;
> > > +}
> > 
> > Shouldn't elem->cidr2 be reset to the original value too?
> 
> No, that's not necessary since cidr2 is never overwritten. The reason 
> this function was added is because when we iterate over ip2, it is 
> successively ANDed in-place with each CIDR we test, which means that the 
> address bits are destroyed. Once we do a new iteration of ip1, we have 
> to first restore ip2, the cidr values don't get touched so they're fine.

mtype_data_reset_elem is called to undo what mtype_data_netmask did. And 
that sets cidr2 too.

A tiny optimization in mtype_test_cidrs is to split up mtype_data_netmask 
into two functions, so that ip/cidr is set in the first loop and ip2/cidr2 
in the second loop. Currently ip/cidr is unnecessarily set in the second 
loop again and again.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
