From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH arptables-compat] arptables-compat: remove save code
Date: Thu,  9 Oct 2014 13:12:12 +0200
Message-ID: <1412853132-13747-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38263 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaJILK6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:10:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is not native arptables-save. The original author provides
perl scripts to implement arptables-save and arptables-restore.
We should use them to mimic arptables behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 3345877..f45ad0f 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -609,25 +609,6 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 		fputc('\n', stdout);
 }
 
-static void nft_arp_save_firewall(const void *data,
-				  unsigned int format)
-{
-	const struct arptables_command_state *cs = data;
-	const struct arpt_entry *fw = &cs->fw;
-
-	print_fw_details((struct arpt_entry *)fw, format);
-
-	if (cs->target) {
-		if (cs->target->print)
-			/* Print the target information. */
-			cs->target->print(&fw->arp, cs->target->t,
-					  format & FMT_NUMERIC);
-	} else if (strlen(cs->jumpto) > 0) {
-		printf("-j %s", cs->jumpto);
-	}
-	printf("\n");
-}
-
 static bool nft_arp_is_same(const void *data_a,
 			    const void *data_b)
 {
@@ -675,14 +656,6 @@ static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 	return true;
 }
 
-static void nft_arp_save_counters(const void *data)
-{
-	const struct arptables_command_state *cs = data;
-	const struct arpt_entry *fw = &cs->fw;
-
-	save_counters(fw->counters.pcnt, fw->counters.bcnt);
-}
-
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -692,8 +665,8 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_immediate	= nft_arp_parse_immediate,
 	.print_header		= nft_arp_print_header,
 	.print_firewall		= nft_arp_print_firewall,
-	.save_firewall		= nft_arp_save_firewall,
-	.save_counters		= nft_arp_save_counters,
+	.save_firewall		= NULL,
+	.save_counters		= NULL,
 	.post_parse		= NULL,
 	.rule_find		= nft_arp_rule_find,
 	.parse_target		= nft_arp_parse_target,
-- 
1.7.10.4

