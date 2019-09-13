Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A40C4CEC5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C8720693
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388211AbfIMLbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:31:39 -0400
Received: from correo.us.es ([193.147.175.20]:42650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbfIMLbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1FD3DA725
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA23BA7E0F
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFE38A7E21; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0C00A7E16;
        Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7304C4265A5A;
        Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/27] netfilter: conntrack: remove CONFIG_NF_CONNTRACK checks from nf_conntrack_zones.h.
Date:   Fri, 13 Sep 2019 13:31:01 +0200
Message-Id: <20190913113102.15776-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_conntrack_zones.h was wrapped in a CONFIG_NF_CONNTRACK check in order
to fix compilation failures:

  37ee3d5b3e97 ("netfilter: nf_defrag_ipv4: fix compilation error with NF_CONNTRACK=n")

Subsequent changes mean that these failures will no longer occur and the
check is unnecessary.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_zones.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 33b91d19cb7d..48dbadb96fb3 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -3,9 +3,6 @@
 #define _NF_CONNTRACK_ZONES_H
 
 #include <linux/netfilter/nf_conntrack_zones_common.h>
-
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 #include <net/netfilter/nf_conntrack.h>
 
 static inline const struct nf_conntrack_zone *
@@ -88,5 +85,5 @@ static inline bool nf_ct_zone_equal_any(const struct nf_conn *a,
 	return true;
 #endif
 }
-#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_ZONES_H */
-- 
2.11.0

