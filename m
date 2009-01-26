From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_proto_generic, assigned to 0
Date: Mon, 26 Jan 2009 14:19:33 +0100
Message-ID: <497DB865.8050003@trash.net>
References: <200901241622.36634.christoph.paasch@student.uclouvain.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43623 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAZNTf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:19:35 -0500
In-Reply-To: <200901241622.36634.christoph.paasch@student.uclouvain.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph Paasch wrote:
> Hi,
> 
> while reading through the source-code I remarked, that for the generic l4 
> protocol handler (nf_conntrack_proto_generic.c)  the protocol number 0 is 
> used. While linux/in.h defines IPPROTO_IP = 0 (and says "a dummy protocol for 
> tcp", whatever that may mean), in net/ipv6.h, the protocol 0 is used for the 
> hop-by-hop header. And as IANA states, 0 is assigned to the IPv6 Hop-by-hop 
> option.
> 
> Even, if netfilter doesn't tracks the hop-by-hop protocol, it shouldn't use 
> this number for the generic protocol handler, because this might be confusing.
> In my opinion, 255 should be used, which is assigned as "Reserved" by IANA.
> 
> What do you think?

It doesn't make a difference currently since in both cases we'd use
generic for HBH. But I think you're suggestion makes sense, could
you send a patch for this?
