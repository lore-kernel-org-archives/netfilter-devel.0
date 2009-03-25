From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 15:33:22 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38566 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZCYOdY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:33:24 -0400
In-Reply-To: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-03-25 15:27, Kristian Evensen wrote:

>Hello,
>
>I have a setup where I have a sender and a multihomed receiver
>connected through a switch, and I am working on a module that
>currently does more or less the same as RAWDNAT [1] (at least it is
>supposed to). My goal is to redirect packets destined for one
>interface on the multihomed receiver to the other, and changing the IP
>address works. Unfortunately, the packet keeps the original
>destination MAC-address, so it arrives at the wrong interface on the
>multihomed receiver.

Ah that might also explain why I observed that packets get lost sometimes..

>My theory is that the original MAC-address is somehow added to the SKB
>before it reaches the output-part of the RAW-table (which is where I
>hook in),

Routing is done before rawpost, yes, but before the (traditional) raw table.
(it's in skb->dst)

>because of the sender's mapping between the original
>destination IP and MAC. However, I have not been able to figure this
>out. Also, I  looked at the NAT-code, but it seems to "only" change
>IP-address as well. Have I overlooked something or am I correct?

Most likely RAWS/DNAT should gain another option to also tweak the
MAC daddr, by calling ip_route_output_key to get a new skb->dst.

>Btw, RAWDNAT throws up a couple of errors on my machine, so I have not
>been able to see it it does what I want to do.

Which errors?
