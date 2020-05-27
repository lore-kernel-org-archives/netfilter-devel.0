Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624FDC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414AA2073B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgE0Wku (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 18:40:50 -0400
Received: from correo.us.es ([193.147.175.20]:33448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgE0Wkp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 18:40:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CFF3EB474
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:40:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F142DA714
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:40:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53431DA701; Thu, 28 May 2020 00:40:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1750EDA701;
        Thu, 28 May 2020 00:40:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 28 May 2020 00:40:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DC56542EF4E0;
        Thu, 28 May 2020 00:40:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/3] netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build
Date:   Thu, 28 May 2020 00:40:18 +0200
Message-Id: <20200527224018.3610-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527224018.3610-1-pablo@netfilter.org>
References: <20200527224018.3610-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

>> include/linux/netfilter/nf_conntrack_pptp.h:13:20: warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
extern const char *const pptp_msg_name(u_int16_t msg);
^~~~~~

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 4c559f15efcc ("netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_pptp.h | 2 +-
 net/netfilter/nf_conntrack_pptp.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 6a4ff6d5ebc2..a28aa289afdc 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -10,7 +10,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
-extern const char *const pptp_msg_name(u_int16_t msg);
+const char *pptp_msg_name(u_int16_t msg);
 
 /* state of the control session */
 enum pptp_ctrlsess_state {
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 7ad247784cfa..1f44d523b512 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -91,7 +91,7 @@ static const char *const pptp_msg_name_array[PPTP_MSG_MAX + 1] = {
 	[PPTP_SET_LINK_INFO]		= "SET_LINK_INFO"
 };
 
-const char *const pptp_msg_name(u_int16_t msg)
+const char *pptp_msg_name(u_int16_t msg)
 {
 	if (msg > PPTP_MSG_MAX)
 		return pptp_msg_name_array[0];
-- 
2.20.1

