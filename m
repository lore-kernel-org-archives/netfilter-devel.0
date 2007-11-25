From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC NETFILTER 0/4]: rate estimator target/match for load-based
 routing
Date: Sun, 25 Nov 2007 18:15:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251813580.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACC8.9060300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44464 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXKYRPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:15:24 -0500
In-Reply-To: <4749ACC8.9060300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 25 2007 18:11, Patrick McHardy wrote:
>
> # route based on available bandwidth
> iptables -t mangle -A BALANCE -m helper --helper ftp \
>                              -m connmark --mark 0x0 \
>                              -m rateest --rateest-delta \
>                                         --rateest1 eth0 \
>                                         --rateest-bps1 2.5mbit \
>                                         --rateest-gt \
>                                         --rateest2 ppp0 \
>                                         --rateest-bps2 2mbit \
>                              -j CONNMARK --set-mark 0x1 
>
Ah gotcha. I smell an implicit -m conntrack --ctstate NEW :-)
