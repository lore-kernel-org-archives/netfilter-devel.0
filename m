From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:26 +0100
Message-ID: <1206468391-368-24-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-19-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-20-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-21-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-22-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-23-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52543 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbYCYSGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:38 -0400
In-Reply-To: <1206468391-368-23-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: Replace anon union by nf_conntrack_man_proto
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_tuple.h |   28 +++++---------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 2c7e115..6db3df6 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -37,7 +37,12 @@ union nf_conntrack_man_proto
 		__be16 port;
 	} udp;
 	struct {
-		__be16 id;
+		union {
+			__be16 id;
+			struct {
+				__u8 type, code;
+			};
+		};
 	} icmp;
 	struct {
 		__be16 port;
@@ -64,26 +69,7 @@ struct nf_conntrack_tuple
 	/* These are the parts of the tuple which are fixed. */
 	struct {
 		union nf_inet_addr u3;
-		union {
-			/* Add other protocols here. */
-			__be16 all;
-
-			struct {
-				__be16 port;
-			} tcp;
-			struct {
-				__be16 port;
-			} udp;
-			struct {
-				u_int8_t type, code;
-			} icmp;
-			struct {
-				__be16 port;
-			} sctp;
-			struct {
-				__be16 key;
-			} gre;
-		} u;
+		union nf_conntrack_man_proto u;
 
 		/* The protocol. */
 		u_int8_t protonum;
