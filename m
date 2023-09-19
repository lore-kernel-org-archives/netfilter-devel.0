Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8788CE79A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 16:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjISQSj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjISQSj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 12:18:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A38EB92
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 09:18:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com
Subject: [PATCH nft] datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
Date:   Tue, 19 Sep 2023 18:18:25 +0200
Message-Id: <20230919161825.643827-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Matching on ct event makes no sense since this is mostly used as
statement to globally filter out ctnetlink events, but do not crash
if it is used from concatenations.

Add the missing slot in the datatype array so this does not crash.

Fixes: 2595b9ad6840 ("ct: add conntrack event mask support")
Reported-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h   | 1 +
 src/ct.c       | 2 +-
 src/datatype.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ct.h b/include/ct.h
index aa0504c5ace7..0a705fd06ee1 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -40,5 +40,6 @@ extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
 extern const struct datatype ct_status_type;
 extern const struct datatype ct_label_type;
+extern const struct datatype ct_event_type;
 
 #endif /* NFTABLES_CT_H */
diff --git a/src/ct.c b/src/ct.c
index d7dec25559b3..b2635543e6ec 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -132,7 +132,7 @@ static const struct symbol_table ct_events_tbl = {
 	},
 };
 
-static const struct datatype ct_event_type = {
+const struct datatype ct_event_type = {
 	.type		= TYPE_CT_EVENTBIT,
 	.name		= "ct_event",
 	.desc		= "conntrack event bits",
diff --git a/src/datatype.c b/src/datatype.c
index ee0e97014185..14d5a0e60146 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -75,6 +75,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_ECN]		= &ecn_type,
 	[TYPE_FIB_ADDR]         = &fib_addr_type,
 	[TYPE_BOOLEAN]		= &boolean_type,
+	[TYPE_CT_EVENTBIT]	= &ct_event_type,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
 	[TYPE_TIME_DATE]	= &date_type,
-- 
2.30.2

