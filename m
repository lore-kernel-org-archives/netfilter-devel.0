From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 1/5] payload: fix update context with wrong byteorder
Date: Sat, 16 Aug 2014 15:17:42 +0100
Message-ID: <20140816141742.GB9697@acer.localdomain>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
 <1407168011-6424-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64217 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaHPORr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:17:47 -0400
Content-Disposition: inline
In-Reply-To: <1407168011-6424-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:00:07PM +0200, Alvaro Neira Ayuso wrote:
> In the evaluation and delinealize steps, we update the protocol
> context. The expression must be in host endian byteorder when we update the
> context. However, this is not the case because we see them in network
> byteorder.
> 
> Fix this by converting to the appropriate byteorder before updating
> the protocol context otherwise this doesn't work.
> 
> nft add rule bridge filter input ether type ip
> 
> We have a expression like this:
> 
> [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
> 
> The byteorder of this expressions is big endian and it's in
> host endian, for that when we try to update the context, we
> don't find the protocol with this number. This is a output,
> example:
> 
> update network layer protocol context:
>  link layer          : ether
>  network layer       : none <-
>  transport layer     : none

So after looking into this, the problem seems really simple, the ETH_P_*
values are in host byteorder and we incorrectly mark them as being in
network byteorder, so they are not converted automatically.

Could you please test whether this fixes the problem you're seeing?

diff --git a/src/proto.c b/src/proto.c
index e5f49cb..050dd90 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -772,7 +779,7 @@ const struct datatype ethertype_type = {
 	.type		= TYPE_ETHERTYPE,
 	.name		= "ether_type",
 	.desc		= "Ethernet protocol",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.basefmt	= "0x%.4Zx",
