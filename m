From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v5] netfilter: ipset: Fix serious failure in CIDR
 tracking
Date: Sun, 15 Sep 2013 15:01:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309151500440.8707@blackhole.kfki.hu>
References: <1379149553-18945-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37147 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab3IONBi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:01:38 -0400
In-Reply-To: <1379149553-18945-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 14 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This fixes a serious bug affecting all hash types with a net element -
> specifically, if a CIDR value is deleted such that none of the same size
> exist any more, all larger (less-specific) values will then fail to
> match. Adding back any prefix with a CIDR equal to or more specific than
> the one deleted will fix it.
> 
> Steps to reproduce:
> ipset -N test hash:net
> ipset -A test 1.1.0.0/16
> ipset -A test 2.2.2.0/24
> ipset -T test 1.1.1.1		#1.1.1.1 IS in set
> ipset -D test 2.2.2.0/24
> ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set
> 
> This is due to the fact that the nets counter was unconditionally
> decremented prior to the iteration that shifts up the entries. Now, we
> first check if there is a proceeding entry and if not, decrement it and
> return. Otherwise, we proceed to iterate and then zero the last element,
> which, in most cases, will already be zero.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Patch is applied, thanks. I'm going to release a new ipset version next 
week.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
