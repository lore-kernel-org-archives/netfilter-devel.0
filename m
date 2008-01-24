From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL]: Fix nfnl_queue_msg_get_packetid() return type
Date: Thu, 24 Jan 2008 13:28:08 +0100
Message-ID: <47988458.4020209@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060105090600080005060809"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYAXM2L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:28:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060105090600080005060809
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch is a bugfix on top of my previous libnl
patches for nfnetlink_queue support.


--------------060105090600080005060809
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 06934fe9e4818802d1b3e6099977883416e96677
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 24 13:27:10 2008 +0100

    [LIBNL]: Fix nfnl_queue_msg_get_packetid() return type
    
    The packet-ID is a 32 bit value, but nfnl_queue_msg_get_packetid() returns
    an uint16_t. Makes queueing fail after 2^16 packets.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/netlink/netfilter/queue_msg.h b/include/netlink/netfilter/queue_msg.h
index daf7b3c..bb63236 100644
--- a/include/netlink/netfilter/queue_msg.h
+++ b/include/netlink/netfilter/queue_msg.h
@@ -41,7 +41,7 @@ extern uint8_t			nfnl_queue_msg_get_family(const struct nfnl_queue_msg *);
 
 extern void			nfnl_queue_msg_set_packetid(struct nfnl_queue_msg *, uint32_t);
 extern int			nfnl_queue_msg_test_packetid(const struct nfnl_queue_msg *);
-extern uint16_t			nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *);
+extern uint32_t			nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *);
 
 extern void			nfnl_queue_msg_set_hwproto(struct nfnl_queue_msg *, uint16_t);
 extern int			nfnl_queue_msg_test_hwproto(const struct nfnl_queue_msg *);
diff --git a/lib/netfilter/queue_msg_obj.c b/lib/netfilter/queue_msg_obj.c
index f86d6f6..476d920 100644
--- a/lib/netfilter/queue_msg_obj.c
+++ b/lib/netfilter/queue_msg_obj.c
@@ -227,7 +227,7 @@ int nfnl_queue_msg_test_packetid(const struct nfnl_queue_msg *msg)
 	return !!(msg->ce_mask & QUEUE_MSG_ATTR_PACKETID);
 }
 
-uint16_t nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *msg)
+uint32_t nfnl_queue_msg_get_packetid(const struct nfnl_queue_msg *msg)
 {
 	return msg->queue_msg_packetid;
 }

--------------060105090600080005060809--
