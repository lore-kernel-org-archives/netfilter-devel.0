Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402D7ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5EC2064A
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbfJONsn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 09:48:43 -0400
Received: from correo.us.es ([193.147.175.20]:42458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfJONsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 09:48:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCF75396273
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 15:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE995DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 15:48:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3ED6D1911; Tue, 15 Oct 2019 15:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 623332DC79
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 15:48:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 15:48:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4937C42EE38F
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 15:48:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: fix flowtable memleaks
Date:   Tue, 15 Oct 2019 15:48:33 +0200
Message-Id: <20191015134833.2147-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[...]
==13530== 694 (536 direct, 158 indirect) bytes in 1 blocks are definitely lost in loss record 7 of 7
==13530==    at 0x483577F: malloc (vg_replace_malloc.c:309)
==13530==    by 0x489C3A8: xmalloc (utils.c:36)
==13530==    by 0x489C479: xzalloc (utils.c:65)
==13530==    by 0x487CE1D: flowtable_alloc (rule.c:2091)
==13530==    by 0x488EC7F: netlink_delinearize_flowtable (netlink.c:1115)
==13530==    by 0x488EC7F: list_flowtable_cb (netlink.c:1151)
==13530==    by 0x4CCA424: nftnl_flowtable_list_foreach (flowtable.c:673)
==13530==    by 0x489104E: netlink_list_flowtables (netlink.c:1171)
==13530==    by 0x487BE0D: cache_init_objects (rule.c:183)
==13530==    by 0x487BE0D: cache_init (rule.c:222)
==13530==    by 0x487BE0D: cache_update (rule.c:272)
==13530==    by 0x48A12BE: nft_evaluate (libnftables.c:406)
==13530==    by 0x48A1AC1: nft_run_cmd_from_buffer (libnftables.c:447)
==13530==    by 0x10954E: main (main.c:350)

[...]
==13768== 14 (8 direct, 6 indirect) bytes in 1 blocks are definitel
==13768==    at 0x4837B65: calloc (vg_replace_malloc.c:762)
==13768==    by 0x488EDC3: netlink_delinearize_flowtable (netlink.c
==13768==    by 0x488EDC3: list_flowtable_cb (netlink.c:1151)
==13768==    by 0x4CCA424: nftnl_flowtable_list_foreach (flowtable.
==13768==    by 0x48910FE: netlink_list_flowtables (netlink.c:1171)
==13768==    by 0x487BE7D: cache_init_objects (rule.c:183)
==13768==    by 0x487BE7D: cache_init (rule.c:222)
==13768==    by 0x487BE7D: cache_update (rule.c:272)
==13768==    by 0x48A136E: nft_evaluate (libnftables.c:406)
==13768==    by 0x48A1B71: nft_run_cmd_from_buffer (libnftables.c:4
==13768==    by 0x10953E: main (main.c:326)

Fixes: db0697ce7f60 ("src: support for flowtable listing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 2d35bae44c9e..e86e1a01c6ed 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1179,6 +1179,7 @@ struct table *table_alloc(void)
 
 void table_free(struct table *table)
 {
+	struct flowtable *flowtable, *nflowtable;
 	struct chain *chain, *next;
 	struct set *set, *nset;
 	struct obj *obj, *nobj;
@@ -1191,6 +1192,8 @@ void table_free(struct table *table)
 		set_free(set);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
+	list_for_each_entry_safe(flowtable, nflowtable, &table->flowtables, list)
+		flowtable_free(flowtable);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
 	xfree(table);
@@ -2104,8 +2107,15 @@ struct flowtable *flowtable_get(struct flowtable *flowtable)
 
 void flowtable_free(struct flowtable *flowtable)
 {
+	int i;
+
 	if (--flowtable->refcnt > 0)
 		return;
+
+	for (i = 0; i < flowtable->dev_array_len; i++)
+		xfree(flowtable->dev_array[i]);
+
+	free(flowtable->dev_array);
 	handle_free(&flowtable->handle);
 	expr_free(flowtable->priority.expr);
 	xfree(flowtable);
-- 
2.11.0

