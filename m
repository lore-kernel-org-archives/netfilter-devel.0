From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: A general question about IP fragmented packets and netfilter
Date: Thu, 23 Jul 2009 11:01:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907231051350.1651@fbirervta.pbzchgretzou.qr>
References: <885896af0907222340m77ef2d6p9767421a608cfdee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34675 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZGWJBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:01:05 -0400
In-Reply-To: <885896af0907222340m77ef2d6p9767421a608cfdee@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-07-23 08:40, Giacomo wrote:
>
>Starting from NF_IP_PRE_ROUTING, where destination NAT and
>de-masquerading takes place, do the packets arrive fragmented - and
>netfilter takes care of the fragments - or do they arrive already
>reassembled from the IP stack?
>
>In the first case, what is, generally speaking, the technique
>adopted to track fragmented IP packets and assign each of them to
>the correct flow?

Connection tracking does not care about packets or their fragment
bits per se.

Because it reads out the layer-4 header (TCP/etc.) however,
it defragments packets for simplicity.

>In the second case, if I register with netfilter NF_IP_PRE_ROUTING
>hook, which is the correct "priority"
>to assign during registration to receive packets already reassembled?

Before NF_IP_PRI_CONNTRACK_DEFRAG.
