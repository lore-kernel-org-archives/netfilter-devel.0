Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0899BC33CA1
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12A1214D8
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNrZzQVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgAFSzA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:55:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgAFSy7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=cyEUulfJMQ30x0JL7+AGFmavC06ya4HiP9c0QUiD5x0=;
        b=bNrZzQVM0j1bzGgV9J39F4NQpn3lJpB8YIDeO7rMaA/Af4W0T8eKJ7eTDkqr9g81UhGexw
        67aO3VrIYhwJ1bY5sIPKalqIomG2oYadrOvw0AXBUzAS2YRQBLTn00qWdNJut8dbio//uf
        sgP2iQ6OUNKMYcihTzFbkEjpuAdxPEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-_Y9Cp2XcNVK2q3wQGVqQLQ-1; Mon, 06 Jan 2020 13:54:54 -0500
X-MC-Unique: _Y9Cp2XcNVK2q3wQGVqQLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9497107ACC5;
        Mon,  6 Jan 2020 18:54:52 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9873F5D9E5;
        Mon,  6 Jan 2020 18:54:49 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 1/9] netfilter: normalize x_table function declarations
Date:   Mon,  6 Jan 2020 13:54:02 -0500
Message-Id: <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Git context diffs were being produced with unhelpful declaration types
in the place of function names to help identify the funciton in which
changes were made.

Normalize x_table function declarations so that git context diff
function labels work as expected.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/x_tables.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ce70c2576bb2..0094853ab42a 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -77,8 +77,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_register_target);
 
-void
-xt_unregister_target(struct xt_target *target)
+void xt_unregister_target(struct xt_target *target)
 {
 	u_int8_t af = target->family;
 
@@ -88,8 +87,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_unregister_target);
 
-int
-xt_register_targets(struct xt_target *target, unsigned int n)
+int xt_register_targets(struct xt_target *target, unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
@@ -108,8 +106,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_register_targets);
 
-void
-xt_unregister_targets(struct xt_target *target, unsigned int n)
+void xt_unregister_targets(struct xt_target *target, unsigned int n)
 {
 	while (n-- > 0)
 		xt_unregister_target(&target[n]);
@@ -127,8 +124,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_register_match);
 
-void
-xt_unregister_match(struct xt_match *match)
+void xt_unregister_match(struct xt_match *match)
 {
 	u_int8_t af = match->family;
 
@@ -138,8 +134,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_unregister_match);
 
-int
-xt_register_matches(struct xt_match *match, unsigned int n)
+int xt_register_matches(struct xt_match *match, unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
@@ -158,8 +153,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_register_matches);
 
-void
-xt_unregister_matches(struct xt_match *match, unsigned int n)
+void xt_unregister_matches(struct xt_match *match, unsigned int n)
 {
 	while (n-- > 0)
 		xt_unregister_match(&match[n]);
@@ -204,8 +198,8 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL(xt_find_match);
 
-struct xt_match *
-xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
+struct xt_match *xt_request_find_match(u8 nfproto, const char *name,
+				       u8 revision)
 {
 	struct xt_match *match;
 
@@ -391,8 +385,8 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-static char *
-textify_hooks(char *buf, size_t size, unsigned int mask, uint8_t nfproto)
+static char *textify_hooks(char *buf, size_t size, unsigned int mask,
+			   uint8_t nfproto)
 {
 	static const char *const inetbr_names[] = {
 		"PREROUTING", "INPUT", "FORWARD",
@@ -1349,11 +1343,10 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
+struct xt_table_info *xt_replace_table(struct xt_table *table,
+				       unsigned int num_counters,
+				       struct xt_table_info *newinfo,
+				       int *error)
 {
 	struct xt_table_info *private;
 	unsigned int cpu;
@@ -1542,7 +1535,7 @@ enum {
 };
 
 static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
-    bool is_target)
+			      bool is_target)
 {
 	static const uint8_t next_class[] = {
 		[MTTG_TRAV_NFP_UNSPEC] = MTTG_TRAV_NFP_SPEC,
@@ -1583,7 +1576,7 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 }
 
 static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
-    bool is_target)
+			       bool is_target)
 {
 	struct nf_mttg_trav *trav = seq->private;
 	unsigned int j;
@@ -1692,8 +1685,8 @@ static int xt_target_seq_show(struct seq_file *seq, void *v)
  * This function will create the nf_hook_ops that the x_table needs
  * to hand to xt_hook_link_net().
  */
-struct nf_hook_ops *
-xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
+struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *table,
+				      nf_hookfn *fn)
 {
 	unsigned int hook_mask = table->valid_hooks;
 	uint8_t i, num_hooks = hweight32(hook_mask);
-- 
1.8.3.1

