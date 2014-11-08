From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] nft-arp: fix inversion of matches
Date: Sat, 08 Nov 2014 22:35:49 +0100
Message-ID: <20141108213434.27991.30805.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50227 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752501AbaKHVgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:36:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Inversion of matches is failing because NFT_CMP_EQ is used unconditionally.

The family agnostic functions don't need this fix, because arp inv flags
are translated to ipt inv flags, and these flags are well handled there.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
NOTES: This patch is for the master branch of iptables tree.
       Compile-tested only. Please comment.

 iptables/nft-arp.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index f45ad0f..cb3623d 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -164,6 +164,7 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	struct arptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->fw;
 	uint8_t flags = arpt_to_ipt_flags(fw->arp.invflags);
+	uint32_t op = NFT_CMP_EQ;
 	int ret = 0;
 
 	if (fw->arp.iniface[0] != '\0')
@@ -174,12 +175,24 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.arhrd != 0) {
 		add_payload(r, offsetof(struct arphdr, ar_hrd), 2);
-		add_cmp_u16(r, fw->arp.arhrd, NFT_CMP_EQ);
+
+		if (fw->arp.invflags & ARPT_INV_ARPHRD)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_u16(r, fw->arp.arhrd, op);
 	}
 
 	if (fw->arp.arpro != 0) {
 	        add_payload(r, offsetof(struct arphdr, ar_pro), 2);
-		add_cmp_u16(r, fw->arp.arpro, NFT_CMP_EQ);
+
+		if (fw->arp.invflags & ARPT_INV_ARPPRO)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_u16(r, fw->arp.arpro, op);
 	}
 
 	if (fw->arp.arhln != 0)
@@ -190,12 +203,24 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.arpop != 0) {
 		add_payload(r, offsetof(struct arphdr, ar_op), 2);
-		add_cmp_u16(r, fw->arp.arpop, NFT_CMP_EQ);
+
+		if (fw->arp.invflags & ARPT_INV_ARPOP)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_u16(r, fw->arp.arpop, op);
 	}
 
 	if (fw->arp.src_devaddr.addr[0] != '\0') {
 		add_payload(r, sizeof(struct arphdr), fw->arp.arhln);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.src_devaddr.addr, fw->arp.arhln);
+
+		if (fw->arp.invflags & ARPT_INV_SRCDEVADDR)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_ptr(r, op, fw->arp.src_devaddr.addr, fw->arp.arhln);
 	}
 
 	if (fw->arp.src.s_addr != 0) {
@@ -206,7 +231,13 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
 		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
+
+		if (fw->arp.invflags & ARPT_INV_TGTDEVADDR)
+			op = NFT_CMP_NEQ;
+		else
+			op = NFT_CMP_EQ;
+
+		add_cmp_ptr(r, op, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
 	}
 
 	if (fw->arp.tgt.s_addr != 0) {

