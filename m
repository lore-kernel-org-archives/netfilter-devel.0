Return-Path: <SRS0=pWrg=ED=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E55C388F7
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Oct 2020 22:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3CEE20728
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Oct 2020 22:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389763AbgJ1Wwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389775AbgJ1Wwq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Oct 2020 18:52:46 -0400
X-Greylist: delayed 4201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Oct 2020 15:52:46 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DC9C0613CF
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2020 15:52:46 -0700 (PDT)
Received: from [90.77.255.23] (helo=localhost.localdomain)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <pablo@netfilter.org>)
        id 1kXr5z-0007e9-BL
        for netfilter-devel@vger.kernel.org; Wed, 28 Oct 2020 20:27:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] conntrack: allow to filter event by family
Date:   Wed, 28 Oct 2020 20:26:44 +0100
Message-Id: <20201028192644.5697-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to filter event through -f, e.g.

 conntrack -E -f ipv4

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index db35b070dadb..66f513b84a2c 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -393,7 +393,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
 /*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
 /*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,0,2,2,2,2,2,2,2,2,0,0,2,2},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
 /*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 /*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 /*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
@@ -1425,6 +1425,7 @@ exp_event_sighandler(int s)
 
 static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
+	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 	unsigned int op_type = NFCT_O_DEFAULT;
 	struct nf_conntrack *obj = data;
 	enum nf_conntrack_msg_type type;
@@ -1456,7 +1457,9 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 	if (nfct_nlmsg_parse(nlh, ct) < 0)
 		goto out;
 
-	if (nfct_filter(obj, ct))
+	if ((filter_family != AF_UNSPEC &&
+	     filter_family != nfh->nfgen_family) ||
+	    nfct_filter(obj, ct))
 		goto out;
 
 	if (output_mask & _O_XML) {
-- 
2.20.1

