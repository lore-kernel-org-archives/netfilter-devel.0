From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Wed, 11 Sep 2013 00:10:50 +0200
Message-ID: <21246863.YTu25Qqz4P@gentoovm>
References: <1378847564-35416-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309102351170.26446@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60478 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3IJWS0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:18:26 -0400
In-Reply-To: <alpine.DEB.2.00.1309102351170.26446@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 10 September 2013 23:55:14 Jozsef Kadlecsik wrote:
> On Tue, 10 Sep 2013, Oliver wrote:
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > This fixes a serious bug affecting all hash types with a net element -
> > specifically, if a CIDR value is deleted such that none of the same size
> > exist any more, all larger (less-specific) values will then fail to
> > match. Adding back any prefix with a CIDR equal to or more specific than
> > the one deleted will fix it.
> > 
> > Steps to reproduce:
> > ipset -N test hash:net
> > ipset -A test 1.1.0.0/16
> > ipset -A test 2.2.2.0/24
> > ipset -T test 1.1.1.1		#1.1.1.1 IS in set
> > ipset -D test 2.2.2.0/24
> > ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set
> > 
> > This is due to the fact that the nets counter was unconditionally
> > decremented prior to the iteration that shifts up the entries. Now, we
> > first check if there is a proceeding entry and if not, decrement it and
> > return. Otherwise, we proceed to iterate and then clean up the last
> > element afterwards.
> > 
> > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> Good catch! But unconditionally checking the next entry may point over the
> array.

Are you sure? In mtype_del_cidr() we only iterate up to (nets_length - 1) 
rather than nets_length, so I didn't think that i+1 could end up going over 
the end of the array.

Kind Regards,
Oliver.
