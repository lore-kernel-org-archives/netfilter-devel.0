From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental3 PATCH 1/2] nft-bridge: fix inversion
 of matches
Date: Sat, 08 Nov 2014 22:39:33 +0100
Message-ID: <20141108213750.28047.14081.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36512 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591AbaKHVjm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:39:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The inversion in bridge specific matches is failing because before this
patch NFT_CMP_EQ is used unconditionally.

No need to change the invesion in family-agnostic functions, given
ebt inv flags are translated to ipt inv flags and inversion is properly
calculated there.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
NOTE: I think the previous patch to fix this isse was wrong in several aspects.
      This is a new approach. Compile-tested only. Please comment.

 iptables/nft-bridge.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 0e21b46..66bbefd 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -165,6 +165,7 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 	struct ebtables_command_state *cs = data;
 	struct ebt_entry *fw = &cs->fw;
 	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
+	uint32_t op = NFT_CMP_EQ;
 	char *addr;
 
 	if (fw->in[0] != '\0')
@@ -182,18 +183,36 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_source), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->sourcemac, 6);
+
+		if (fw->invflags & EBT_ISOURCE)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_ptr(r, op, fw->sourcemac, 6);
 	}
 
 	addr = ether_ntoa((struct ether_addr *) fw->destmac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_dest), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->destmac, 6);
+
+		if (fw->invflags & EBT_IDEST)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_ptr(r, op, fw->destmac, 6);
 	}
 
 	if (fw->ethproto != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
-		add_cmp_u16(r, fw->ethproto, NFT_CMP_EQ);
+
+		if (fw->invflags & EBT_IPROTO)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_u16(r, fw->ethproto, op);
 	}
 
 	return _add_action(r, cs);

