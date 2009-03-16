From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: remove IPvX specific parts from nf_conntrack_l4proto.h
Date: Mon, 16 Mar 2009 15:16:38 +0100
Message-ID: <49BE5F46.8060407@trash.net>
References: <1236615258-12897-1-git-send-email-christoph.paasch@gmail.com> <alpine.LSU.2.00.0903101714170.23653@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Paasch <christoph.paasch@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46103 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217AbZCPOQm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:16:42 -0400
In-Reply-To: <alpine.LSU.2.00.0903101714170.23653@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Monday 2009-03-09 17:14, Christoph Paasch wrote:
> 
>> Moving the structure definitions to the corresponding IPvX specific header files.
>> ---
>> include/net/netfilter/nf_conntrack_l4proto.h   |    5 +----
>> net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
>> net/netfilter/nf_conntrack_proto_tcp.c         |    2 ++
>> net/netfilter/nf_conntrack_proto_udp.c         |    2 ++
>> 4 files changed, 6 insertions(+), 4 deletions(-)
> 
> 
> Seems good to go to me. Patrick?

Me too, applied.

Next time please sign off your patches though.
