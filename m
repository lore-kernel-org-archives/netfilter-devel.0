From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 14:39:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
References: <20080703003942.GA2012@linuxace.com>
 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50766 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbYGCMjK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:39:10 -0400
In-Reply-To: <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 3 Jul 2008, Jan Engelhardt wrote:

> You know what's been bugging me... why don't we replace the entire
> routing infrastructure by an xtables "route" table, with something like
> 
> # rp_filter
> iptables -t route -A ROUTING -m route ! --route-src-exists -j DROP
> 
> # policy routing
> iptables -t route -A ROUTING -m statistic --mode nth --every 2
> -j ROUTE --dev eth0
> 
> # ipsec (vaguely)
> iptables -t route -A OUTPUT -s 192.168.1.0/24 -d 192.168.2.0/24
> -j IPSEC --mode tunnel --right-side 82.83.84.85
> 
> That would get rid of the tons of different-kind tables (xt tables,
> routing tables, routing rules, xfrm policy and xfrm subs) and
> put it into one thing people understand reasonably well.

The nf-hipac people also suggested it long time ago.

One can find a lot of smaller and bigger missing pieces, like a new table, 
new hook, if we'd associate a 'routing table' to a 'chain in the iptables 
route table', then we'd need a default policy support (i.e. default route) 
for the user defined chains too, etc.

If iptables were converted to netlink, that'd be a huge step toward such a 
goal.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
