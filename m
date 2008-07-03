From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 13:22:48 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35726 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbYGCL7G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:59:06 -0400
In-Reply-To: <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 11:50, Jozsef Kadlecsik wrote:
>> 
>> >	Ingress filtering:
>> >		iptables -A FORWARD -i $EXTERNAL_IF -m route --route-src-exists -j DROP
>> 
>> rp_filter again.
>
>Quick and not good examples, I'd say. The main problem with rp_filter is 
>that it drops the packets >silently<. The real benefit of such a match is 
>the possibility to log (and drop) faked packets. If the patch had IPv6 
>support, one could add that additionally (as far as I know) there's no 
>rp_filter for IPv6 at all.

You know what's been bugging me... why don't we replace the entire
routing infrastructure by an xtables "route" table, with something like

# rp_filter
iptables -t route -A ROUTING -m route ! --route-src-exists -j DROP

# policy routing
iptables -t route -A ROUTING -m statistic --mode nth --every 2
-j ROUTE --dev eth0

# ipsec (vaguely)
iptables -t route -A OUTPUT -s 192.168.1.0/24 -d 192.168.2.0/24
-j IPSEC --mode tunnel --right-side 82.83.84.85

That would get rid of the tons of different-kind tables (xt tables,
routing tables, routing rules, xfrm policy and xfrm subs) and
put it into one thing people understand reasonably well.
