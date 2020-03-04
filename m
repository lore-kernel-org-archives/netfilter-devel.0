Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA5AC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 02:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A16720842
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 02:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgCDCZJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:25:09 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:56680 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgCDCZJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 21:25:09 -0500
Received: from localhost ([::1]:41538 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j9Jie-000891-07; Wed, 04 Mar 2020 03:25:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] connlabel: Allow numeric labels even if connlabel.conf exists
Date:   Wed,  4 Mar 2020 03:24:59 +0100
Message-Id: <20200304022459.6433-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Existing code is a bit quirky: If no connlabel.conf was found, the local
function connlabel_value_parse() is called which tries to interpret
given label as a number. If the config exists though,
nfct_labelmap_get_bit() is called instead which doesn't care about
"undefined" connlabel names. So unless installed connlabel.conf contains
entries for all possible numeric labels, rules added by users may stop
working if a connlabel.conf is created. Fix this by falling back to
connlabel_value_parse() function also if connlabel_open() returned 0 but
nfct_labelmap_get_bit() returned an error.

Fixes: 3a3bb480a738a ("extensions: connlabel: Fallback on missing connlabel.conf")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_connlabel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 5a01fe7237bd8..1fc92f42cd969 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -71,7 +71,7 @@ static void connlabel_mt_parse(struct xt_option_call *cb)
 {
 	struct xt_connlabel_mtinfo *info = cb->data;
 	bool have_labelmap = !connlabel_open();
-	int tmp;
+	int tmp = -1;
 
 	xtables_option_parse(cb);
 
@@ -79,7 +79,7 @@ static void connlabel_mt_parse(struct xt_option_call *cb)
 	case O_LABEL:
 		if (have_labelmap)
 			tmp = nfct_labelmap_get_bit(map, cb->arg);
-		else
+		if (tmp < 0)
 			tmp = connlabel_value_parse(cb->arg);
 
 		if (tmp < 0)
-- 
2.25.1

