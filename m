From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/2] xtables-compat-restore: fix several memory leaks
Date: Tue,  8 Aug 2017 20:53:45 +0200
Message-ID: <20170808185346.3183-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36755 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdHHSyE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 14:54:04 -0400
Received: by mail-wr0-f195.google.com with SMTP id y67so3043764wrb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2017 11:54:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following memory leaks are detected by valgrind when
ip[6]tables-compat-restore is executed:

valgrind --leak-check=full iptables-compat-restore test-ruleset

==2548== 16 bytes in 1 blocks are definitely lost in loss record 1 of 20
==2548==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2548==    by 0x4E39D67: __mnl_socket_open (socket.c:110)
==2548==    by 0x4E39DDE: mnl_socket_open (socket.c:133)
==2548==    by 0x11A48E: nft_init (nft.c:765)
==2548==    by 0x11589F: xtables_restore_main (xtables-restore.c:463)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 16 bytes in 1 blocks are definitely lost in loss record 2 of 20
==2548==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2548==    by 0x504C7CD: nftnl_chain_list_alloc (chain.c:874)
==2548==    by 0x11B2DB: nftnl_chain_list_get (nft.c:1194)
==2548==    by 0x11B377: nft_chain_dump (nft.c:1210)
==2548==    by 0x114DF9: get_chain_list (xtables-restore.c:167)
==2548==    by 0x114EF8: xtables_restore_parse (xtables-restore.c:217)
==2548==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 40 bytes in 1 blocks are definitely lost in loss record 5 of 20
==2548==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2548==    by 0x56ABB99: xtables_calloc (xtables.c:291)
==2548==    by 0x116DA7: command_jump (xtables.c:623)
==2548==    by 0x117D5B: do_parse (xtables.c:923)
==2548==    by 0x1188BA: do_commandx (xtables.c:1183)
==2548==    by 0x115655: xtables_restore_parse (xtables-restore.c:405)
==2548==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 40 bytes in 1 blocks are definitely lost in loss record 6 of 20
==2548==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==2548==    by 0x4E3AE07: mnl_nlmsg_batch_start (nlmsg.c:441)
==2548==    by 0x1192B7: mnl_nftnl_batch_alloc (nft.c:106)
==2548==    by 0x11931A: mnl_nftnl_batch_page_add (nft.c:122)
==2548==    by 0x11DB0C: nft_action (nft.c:2402)
==2548==    by 0x11DB65: nft_commit (nft.c:2413)
==2548==    by 0x114FBB: xtables_restore_parse (xtables-restore.c:238)
==2548==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 80 bytes in 5 blocks are definitely lost in loss record 8 of 20
==2548==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2548==    by 0x50496FE: nftnl_table_list_alloc (table.c:433)
==2548==    by 0x11DF88: nft_xtables_config_load (nft.c:2539)
==2548==    by 0x11B037: nft_rule_append (nft.c:1116)
==2548==    by 0x116639: add_entry (xtables.c:429)
==2548==    by 0x118A3B: do_commandx (xtables.c:1187)
==2548==    by 0x115655: xtables_restore_parse (xtables-restore.c:405)
==2548==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 80 bytes in 5 blocks are definitely lost in loss record 9 of 20
==2548==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2548==    by 0x504C7CD: nftnl_chain_list_alloc (chain.c:874)
==2548==    by 0x11DF91: nft_xtables_config_load (nft.c:2540)
==2548==    by 0x11B037: nft_rule_append (nft.c:1116)
==2548==    by 0x116639: add_entry (xtables.c:429)
==2548==    by 0x118A3B: do_commandx (xtables.c:1187)
==2548==    by 0x115655: xtables_restore_parse (xtables-restore.c:405)
==2548==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)
==2548==
==2548== 135,168 bytes in 1 blocks are definitely lost in loss record 19 of 20
==2548==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==2548==    by 0x119280: mnl_nftnl_batch_alloc (nft.c:102)
==2548==    by 0x11A51F: nft_init (nft.c:777)
==2548==    by 0x11589F: xtables_restore_main (xtables-restore.c:463)
==2548==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)
==2548==    by 0x12FF39: subcmd_main (xshared.c:211)
==2548==    by 0x10F63C: main (xtables-compat-multi.c:41)

An additional leak occurs if a rule-set already exits:

==2735== 375 (312 direct, 63 indirect) bytes in 3 blocks are definitely lost in loss record 19 of 24
==2735==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==2735==    by 0x504AAE9: nftnl_chain_alloc (chain.c:92)
==2735==    by 0x11B1F1: nftnl_chain_list_cb (nft.c:1172)
==2735==    by 0x4E3A2E8: __mnl_cb_run (callback.c:78)
==2735==    by 0x4E3A4A7: mnl_cb_run (callback.c:162)
==2735==    by 0x11920D: mnl_talk (nft.c:70)
==2735==    by 0x11B343: nftnl_chain_list_get (nft.c:1203)
==2735==    by 0x11B377: nft_chain_dump (nft.c:1210)
==2735==    by 0x114DF9: get_chain_list (xtables-restore.c:167)
==2735==    by 0x114EF8: xtables_restore_parse (xtables-restore.c:217)
==2735==    by 0x115B43: xtables_restore_main (xtables-restore.c:526)
==2735==    by 0x115B88: xtables_ip4_restore_main (xtables-restore.c:534)

Fix these memory leaks.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft.c             | 10 +++++++---
 iptables/xtables-restore.c |  8 +++++++-
 iptables/xtables.c         |  2 ++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index fee91bc7..76e45466 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -147,7 +147,8 @@ static void mnl_nftnl_batch_reset(void)
 
 	list_for_each_entry_safe(batch_page, next, &batch_page_list, head) {
 		list_del(&batch_page->head);
-		free(batch_page->batch);
+		free(mnl_nlmsg_batch_head(batch_page->batch));
+		mnl_nlmsg_batch_stop(batch_page->batch);
 		free(batch_page);
 		batch_num_pages--;
 	}
@@ -2536,8 +2537,8 @@ static void xtables_config_perror(uint32_t flags, const char *fmt, ...)
 int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			    uint32_t flags)
 {
-	struct nftnl_table_list *table_list = nftnl_table_list_alloc();
-	struct nftnl_chain_list *chain_list = nftnl_chain_list_alloc();
+	struct nftnl_table_list *table_list = NULL;
+	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_table_list_iter *titer = NULL;
 	struct nftnl_chain_list_iter *citer = NULL;
 	struct nftnl_table *table;
@@ -2548,6 +2549,9 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	if (h->restore)
 		return 0;
 
+	table_list = nftnl_table_list_alloc();
+	chain_list = nftnl_chain_list_alloc();
+
 	if (xtables_config_parse(filename, table_list, chain_list) < 0) {
 		if (errno == ENOENT) {
 			xtables_config_perror(flags,
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 7e243152..fc39ad9c 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -180,8 +180,10 @@ static void chain_delete(struct nftnl_chain_list *clist, const char *curtable,
 	/* This chain has been found, delete from list. Later
 	 * on, unvisited chains will be purged out.
 	 */
-	if (chain_obj != NULL)
+	if (chain_obj != NULL) {
 		nftnl_chain_list_del(chain_obj);
+		nftnl_chain_free(chain_obj);
+	}
 }
 
 struct nft_xt_restore_cb restore_cb = {
@@ -433,6 +435,9 @@ void xtables_restore_parse(struct nft_handle *h,
 				xt_params->program_name, line + 1);
 		exit(1);
 	}
+
+	if (chain_list)
+		nftnl_chain_list_free(chain_list);
 }
 
 static int
@@ -525,6 +530,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 
 	xtables_restore_parse(&h, &p, &restore_cb, argc, argv);
 
+	nft_fini(&h);
 	fclose(p.in);
 	return 0;
 }
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 286866f7..ac113254 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1281,6 +1281,8 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	*table = p.table;
 
 	xtables_rule_matches_free(&cs.matches);
+	if (cs.target)
+		free(cs.target->t);
 
 	if (h->family == AF_INET) {
 		free(args.s.addr.v4);
-- 
2.13.2

