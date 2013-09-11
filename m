From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Wed, 11 Sep 2013 09:05:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309110858510.27719@blackhole.kfki.hu>
References: <1378847564-35416-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309102351170.26446@blackhole.kfki.hu> <21246863.YTu25Qqz4P@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:45126 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3IKHFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:05:05 -0400
In-Reply-To: <21246863.YTu25Qqz4P@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Sep 2013, Oliver wrote:

> On Tuesday 10 September 2013 23:55:14 Jozsef Kadlecsik wrote:
> > On Tue, 10 Sep 2013, Oliver wrote:
> > > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > > 
> > > This fixes a serious bug affecting all hash types with a net element -
> > > specifically, if a CIDR value is deleted such that none of the same size
> > > exist any more, all larger (less-specific) values will then fail to
> > > match. Adding back any prefix with a CIDR equal to or more specific than
> > > the one deleted will fix it.
> > > 
> > > Steps to reproduce:
> > > ipset -N test hash:net
> > > ipset -A test 1.1.0.0/16
> > > ipset -A test 2.2.2.0/24
> > > ipset -T test 1.1.1.1		#1.1.1.1 IS in set
> > > ipset -D test 2.2.2.0/24
> > > ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set
> > > 
> > > This is due to the fact that the nets counter was unconditionally
> > > decremented prior to the iteration that shifts up the entries. Now, we
> > > first check if there is a proceeding entry and if not, decrement it and
> > > return. Otherwise, we proceed to iterate and then clean up the last
> > > element afterwards.
> > > 
> > > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > Good catch! But unconditionally checking the next entry may point over the
> > array.
> 
> Are you sure? In mtype_del_cidr() we only iterate up to (nets_length - 1) 
> rather than nets_length, so I didn't think that i+1 could end up going over 
> the end of the array.

(nets_length - 1) is the last index in the array. In the first for loop 
"i" can reach this value, so "i+1" is over the array.

Also, your patch decrements the nets[i] value only if the next entry is 
empty, that an error too.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
