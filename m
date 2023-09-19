Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBC6CE79A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 16:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjISQNF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjISQNF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 12:13:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DFAFA1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 09:12:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com
Subject: [PATCH nft] datatype: initialize TYPE_CT_LABEL slot in datatype array
Date:   Tue, 19 Sep 2023 18:12:54 +0200
Message-Id: <20230919161254.640998-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, ct label with concatenations such as:

 table ip x {
        chain y {
                ct label . ct mark  { 0x1 . 0x1 }
        }
 }

crashes:

../include/datatype.h:196:11: runtime error: member access within null pointer of type 'const struct datatype'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==640948==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000000 (pc 0x7fc970d3199b bp 0x7fffd1f20560 sp 0x7fffd1f20540 T0)
==640948==The signal is caused by a READ memory access.
==640948==Hint: address points to the zero page.
sudo     #0 0x7fc970d3199b in datatype_equal ../include/datatype.h:196

Fixes: 2fcce8b0677b ("ct: connlabel matching support")
Reported-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h   | 1 +
 src/ct.c       | 2 +-
 src/datatype.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ct.h b/include/ct.h
index efb2d4185543..aa0504c5ace7 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -39,5 +39,6 @@ extern const char *ct_label2str(const struct symbol_table *tbl,
 extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
 extern const struct datatype ct_status_type;
+extern const struct datatype ct_label_type;
 
 #endif /* NFTABLES_CT_H */
diff --git a/src/ct.c b/src/ct.c
index 6760b08570de..d7dec25559b3 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -217,7 +217,7 @@ static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
 	return NULL;
 }
 
-static const struct datatype ct_label_type = {
+const struct datatype ct_label_type = {
 	.type		= TYPE_CT_LABEL,
 	.name		= "ct_label",
 	.desc		= "conntrack label",
diff --git a/src/datatype.c b/src/datatype.c
index 70c84846f70e..ee0e97014185 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -65,6 +65,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_CT_DIR]		= &ct_dir_type,
 	[TYPE_CT_STATUS]	= &ct_status_type,
 	[TYPE_ICMP6_TYPE]	= &icmp6_type_type,
+	[TYPE_CT_LABEL]		= &ct_label_type,
 	[TYPE_PKTTYPE]		= &pkttype_type,
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
-- 
2.30.2

