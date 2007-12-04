From: Patrick McHardy <kaber@trash.net>
Subject: [NET 10/49]: Constify include/net/dsfield.h
Date: Tue,  4 Dec 2007 13:02:09 +0100 (MET)
Message-ID: <20071204120209.2442.35204.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62127 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbXLDMCK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:10 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NET]: Constify include/net/dsfield.h

Constify include/net/dsfield.h

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 93a030a957dbe5c4ff8648e6dec5f7ac09bd3a5d
tree 87dc4a20d080269a0e9b6bc34b5443ce4c9ed0ca
parent 08d5ebfa5d171ca207ccdd5086cc86eadf99ebea
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:47:02 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:23:15 +0100

 include/net/dsfield.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/dsfield.h b/include/net/dsfield.h
index eb65bf2..8a8d4e0 100644
--- a/include/net/dsfield.h
+++ b/include/net/dsfield.h
@@ -12,15 +12,15 @@
 #include <asm/byteorder.h>
 
 
-static inline __u8 ipv4_get_dsfield(struct iphdr *iph)
+static inline __u8 ipv4_get_dsfield(const struct iphdr *iph)
 {
 	return iph->tos;
 }
 
 
-static inline __u8 ipv6_get_dsfield(struct ipv6hdr *ipv6h)
+static inline __u8 ipv6_get_dsfield(const struct ipv6hdr *ipv6h)
 {
-	return ntohs(*(__be16 *) ipv6h) >> 4;
+	return ntohs(*(const __be16 *)ipv6h) >> 4;
 }
 
 
