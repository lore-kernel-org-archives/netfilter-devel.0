From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 09:18:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936994AbYGCHSU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:18:20 -0400
In-Reply-To: <20080703003942.GA2012@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 02:39, Phil Oester wrote:

>Attached is a new "route" match, which matches against entries
>in the kernel routing table.  I've had a need for this functionality
>for quite some time, and finally decided to code it up.  

There is also the 'realm' match..

ip route replace 10.10.96.0/20 dev sis0 realm 5 src 10.10.106.161
iptables -t mangle -A POSTROUTING -m realm 5 -j dowhateveryouwant

>
>TODO: add IPv6 support to kernel side
>
>Options
>
>[!] --route-src-exists      Route for src exists
>    --route-src-eq value    Route for src exists with prefix-length == value
>    --route-src-gt value    Route for src exists with prefix-length  > value
>    --route-src-lt value    Route for src exists with prefix-length  < value
>[!] --route-dst-exists      Route for dst exists
>    --route-dst-eq value    Route for dst exists with prefix-length == value
>    --route-dst-gt value    Route for dst exists with prefix-length  > value
>    --route-dst-lt value    Route for dst exists with prefix-length  < value
>
>Examples:
>
>	Egress filtering:
>		iptables -A FORWARD -m route ! --route-src-exists -j DROP

That's what rp_filter is for.

>	Ingress filtering:
>		iptables -A FORWARD -i $EXTERNAL_IF -m route --route-src-exists -j DROP

rp_filter again.

>	Allow a user to only browse internal websites:
>		iptables -A FORWARD -p tcp --dport 80 -m route --route-dst-exists -j ACCEPT

If there was no fitting dst route, the packet would never get to FORWARD in
the first place.

>	Allow an SNMP collector to reach all internal routers (/30 or /32 interfaces)
>		iptables -A FORWARD -p udp --dport 161 -m route --route-dst-gt 29 -j ACCEPT

And this could be modeled with -s xxx/30 -d xxx/30 maybe.
