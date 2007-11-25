From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC NETFILTER 0/4]: rate estimator target/match for load-based
 routing
Date: Sun, 25 Nov 2007 18:17:35 +0100
Message-ID: <4749AE2F.40000@trash.net>
References: <4749ACC8.9060300@trash.net> <Pine.LNX.4.64.0711251813580.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64365 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXKYRSN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:18:13 -0500
In-Reply-To: <Pine.LNX.4.64.0711251813580.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 25 2007 18:11, Patrick McHardy wrote:
>> # route based on available bandwidth
>> iptables -t mangle -A BALANCE -m helper --helper ftp \
>>                              -m connmark --mark 0x0 \
>>                              -m rateest --rateest-delta \
>>                                         --rateest1 eth0 \
>>                                         --rateest-bps1 2.5mbit \
>>                                         --rateest-gt \
>>                                         --rateest2 ppp0 \
>>                                         --rateest-bps2 2mbit \
>>                              -j CONNMARK --set-mark 0x1 
>>
> Ah gotcha. I smell an implicit -m conntrack --ctstate NEW :-)


Right, that would be easier to read. It a left-over from a
previous attempt where I used periodic rebalancing by resetting
the mark to 0x0. Still thinking about something like that for
the case that a connection is routed over the slower line and
the faster one gets free.


