From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: Send complete hardware header in NFLOG.
Date: Thu, 17 Jul 2008 11:01:08 +0200
Message-ID: <487F0A54.5090002@trash.net>
References: <487CA584.3030200@trash.net> <1216247094-21285-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000504070802010904090703"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49595 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYGQJBL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:01:11 -0400
In-Reply-To: <1216247094-21285-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000504070802010904090703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Eric Leblond wrote:
> This patch adds some fields to NFLOG to be able to send the complete
> hardware header with all necessary informations.
> It sends to userspace:
>  * the type of hardware link
>  * the lenght of hardware header
>  * the hardware header

Looks good. I've applied it with a minor change to use the endian
aware netlink macros.

I need a Signed-off-by: line from you though.


--------------000504070802010904090703
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 204dcae..9a35b57 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -454,9 +454,9 @@ __build_packet_message(struct nfulnl_instance *inst,
 	}
 
 	if (indev && skb_mac_header_was_set(skb)) {
-		NLA_PUT_U16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
-		NLA_PUT_U16(inst->skb, NFULA_HWLEN,
-			    htons(skb->dev->hard_header_len));
+		NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
+		NLA_PUT_BE16(inst->skb, NFULA_HWLEN,
+			     htons(skb->dev->hard_header_len));
 		NLA_PUT(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
 			skb_mac_header(skb));
 	}

--------------000504070802010904090703--
