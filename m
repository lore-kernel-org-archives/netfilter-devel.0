From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 13 Dec 2006 12:00:05 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612131156530.25870@yvahk01.tjqt.qr>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<44824.195.55.244.106.1166001170.squirrel@www.arcoscom.com>
	<457FC50E.70009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	linux@arcoscom.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <457FC50E.70009@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


>> Then, the actual and updated and maintained substitute for ROUTE is using
>> CONNMARK and/or MARK and then add filters/rules to routes table with ip.
>> Am I in the truth?
>
>That has always been the better way. The route target is a hack, I'm
>don't know why it exists at all.

The biggest problem with Linux is that you have to match packets thrice 
(three times) if you use all of the fluffy features (netfilter, policy 
routing and QoS). That's a real PITA and a CPU burner too.

Well, as far as an example goes it could be like

  iptables -m time --blah sundays -j ROUTE -o eth1 (terminating target)
  default route eth0

On the other hand, using MARK would require

  iptables -t mangle -A OUTPUT -m time --sundays -j MARK --set-mark 0x1
  ip route ... funky comand matching 0x1

Plus there is yet some repition inside iptables itself, e.g. if one was 
able to MARK packets while they were filtered:

Requirement as of today: MARK must be in mangle. If you have tons of 
rules, you need a lot of MARK operations. However, if MARK could be used 
inside the filter table, you could drop all packets you are not 
interested in first, then mark them.


	-`J'
-- 
