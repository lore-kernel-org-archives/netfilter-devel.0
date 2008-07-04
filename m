From: "James King" <t.james.king@gmail.com>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 17:19:36 -0700
Message-ID: <38bcb3ec0807031719n6cdc3233m605271c638b5716f@mail.gmail.com>
References: <20080703003942.GA2012@linuxace.com>
	 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0807032348310.3107@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0807040054120.1890@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	"Phil Oester" <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:40740 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYGDATk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:19:40 -0400
Received: by nf-out-0910.google.com with SMTP id d3so317805nfc.21
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Jul 2008 17:19:36 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807040054120.1890@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 3, 2008 at 4:02 PM, Jan Engelhardt <jengelh@medozas.de> wrote:

> Routing tables become xtables chains. We would not lose anything.
> In fact, you would gain the possibilty to jump to further chains,
> something not possible in routing today.
>
> rt input:
>
> ip rule fwmark 5 table 5
> ip rule fwmark 6 table 6
> ip route add 10.10.96.2/32 dev eth2 table 5
> ip route add via 10.10.96.1 dev eth0 table 5 # default route
> ip route add via 10.11.96.1 dev eth1 table 6 # default orute
>
> in xtables (ROUTE is a terminating target):
>
> -N table5
> -N table6
> -A table5 -d 10.10.96.2 -j ROUTE --dev eth2
> -A table5 -j ROUTE --via 10.10.96.1 --dev eth0  # default route!
> -A table6 -j ROUTE --via 10.11.96.1 --dev eth1  # also a default
> -A ROUTING -m mark --mark 5 -j table5
> -A ROUTING -m mark --mark 6 -j table6

Wouldn't this break with normal routing concepts, since xtables
traverses the chain linearly, while routing lookups use longest prefix
match (most specific route wins)?  IOW, unless xtables automatically
inserted the rule into the correct spot in the chain (as opposed to
just appending to the end of the chain like -A implies), you could run
into situations where specifying the rules out of order would send the
packet to the wrong next-hop.


Regards,
James
