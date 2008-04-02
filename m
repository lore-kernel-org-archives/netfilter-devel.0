From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 18/24] [NETFILTER]: Replace anon union by nf_conntrack_man_proto
Date: Wed,  2 Apr 2008 13:12:00 +0200
Message-ID: <bcddf41af9dbfc455d871cc15cf2f4d14e0e0f97.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYDBLML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:11 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
-- 
1.5.4.4

