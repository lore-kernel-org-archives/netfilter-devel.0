From: Glen Miner <shaggie76@hotmail.com>
Subject: RE: iptables at scale
Date: Wed, 11 Mar 2015 17:54:20 -0400
Message-ID: <SNT152-W704BB03A2583E6AB5F1631B8190@phx.gbl>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>,<CAJ26g5SeC-shnX+PT2nijqJMLk45zg8VVqvEVk7xG-6r7XgP-w@mail.gmail.com>
 <SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>,<alpine.LSU.2.11.1503112242290.9828@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt004-omc1s43.hotmail.com ([65.54.61.80]:50923 "EHLO
	SNT004-OMC1S43.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbbCKVyV convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 17:54:21 -0400
In-Reply-To: <alpine.LSU.2.11.1503112242290.9828@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> If all you do is the NAT mappings, then directly using conntrack(8)
> and/or libnetfilter_conntrack should suffice, especially since UDP CT
> entries stay around until their known timeout.

Hmm. That's basically what you said back in January:

List: netfilter
Subject: Re: Stateless NAT with iptables
From: Jan Engelhardt
Date: 2015-01-09 23:54:16

http://marc.info/?l=netfilter&m=142084805119379&w=2

But I tried that and couldn't get it working; Marcelo Ricardo Leitner said

"Having the conntrack entry is not enough to get your packets NATed"

List: netfilter
Subject: Re: Stateless NAT with iptables
From: Marcelo Ricardo Leitner <marcelo.leitner () gmail ! com>
Date: 2015-01-12 22:06:31
Message-ID: 54B44567.2050707 () gmail ! com

Which seemed to match my observations. I'll go back in the hole if people here seem to think it's viable and I'm missing something, though.

Thanks for reading!
-g 		 	   		  