From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables -t nat -A OUTPUT -j DNAT ... checksum incorrect
Date: Mon, 10 Aug 2009 17:23:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908101721080.15342@fbirervta.pbzchgretzou.qr>
References: <885896af0908050553kefeadd2l2fb30190ade2f521@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37440 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZHJPXO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:23:14 -0400
In-Reply-To: <885896af0908050553kefeadd2l2fb30190ade2f521@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-08-05 14:53, Giacomo wrote:

>Hi to all.
>
>With the rule
>
>
>iptables -t nat -A OUTPUT -p tcp -j DNAT -d 151.8.71.28
>--to-destination 140.105.5.88:8080
>
>
>I see the GET http request with checksum incorrect (on the wireshark
>traffic analyzer):

Normally the checksum should be recalculated at the same time
the NAT transformation is applied, but I think there is also
a way where this might not happen - TSO, GSO or hardware
checksumming, or something.
If that is the case, skb->checksum should be containing an
approprivate value (CHECKSUM_NONE/CHECKSUM_UNNECESSARY/etc.)
Best is: try to printk skb->checksum. (was it skb->csum?)
