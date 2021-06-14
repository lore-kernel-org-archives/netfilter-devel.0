Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1336C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 19:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A11061185
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 19:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhFNTn1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:43:27 -0400
Received: from mx4.wp.pl ([212.77.101.11]:40284 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhFNTn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 15:43:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 15:43:27 EDT
Received: (wp-smtpd smtp.wp.pl 40357 invoked from network); 14 Jun 2021 21:34:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1623699282; bh=J8ZHENogAgHJpZv62l2QpZDKSmhVsnC1tt0LZn14i6s=;
          h=From:To:Cc:Subject;
          b=x7Be3rC+4YgD85DdCHqMmoEDT3pnsfGGGgXJ+xbfiopD8Qmd9mcir7CPSuq25143p
           WRadQoyMTNbcZWLSz7My6sDQpOIpkVGtSH+1lfkVunBGSao54ef93Avcz3YL8TXeFF
           C2yLmKtG6VxnhcC4Aqz37bAnW7FYB4DeznTbeV2g=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <pablo@netfilter.org>; 14 Jun 2021 21:34:42 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, roid@nvidia.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw refresh bit"
Date:   Mon, 14 Jun 2021 21:34:40 +0200
Message-Id: <20210614193440.3813-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: cfed751c488ff419c585294260b454d3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kVM0]                               
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit c07531c01d8284aedaf95708ea90e76d11af0e21.

The previously mentioned commit significantly reduces NAT performance
in OpenWRT. Another user reports a high ping issue. The results of
IPv4 NAT benchmark on BT Home Hub 5A (with software flow offloading):
* 5.4.124             515 Mb/s
* 5.10.41             570 Mb/s
* 5.10.42             250 Mb/s
* 5.10.42 + revert    580 Mb/s

Reverting this commit fixes this issue.

Fixes: c07531c01d8284aedaf95708ea90e76d11af0e21 ("netfilter: flowtable: Remove redundant hw refresh bit")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 include/net/netfilter/nf_flow_table.h | 1 +
 net/netfilter/nf_flow_table_core.c    | 3 ++-
 net/netfilter/nf_flow_table_offload.c | 7 +++----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 48ef7460ff30..51d8eb99764d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -157,6 +157,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
+	NF_FLOW_HW_REFRESH,
 	NF_FLOW_HW_PENDING,
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1d02650dd715..39c02d1aeedf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -306,7 +306,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 {
 	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
+	if (likely(!nf_flowtable_hw_offload(flow_table) ||
+		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
 		return;
 
 	nf_flow_offload_add(flow_table, flow);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 528b2f172684..2af7bdb38407 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -902,11 +902,10 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		goto out;
-
-	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
+	else
+		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 
-out:
 	nf_flow_offload_destroy(flow_rule);
 }
 
-- 
2.30.2

