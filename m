Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E176AC47096
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C999E613C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhFAWIV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhFAWIT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C18A4641CC;
        Wed,  2 Jun 2021 00:05:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/16] netfilter: Remove leading spaces in Kconfig
Date:   Wed,  2 Jun 2021 00:06:18 +0200
Message-Id: <20210601220629.18307-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Juerg Haefliger <juerg.haefliger@canonical.com>

Remove leading spaces before tabs in Kconfig file(s) by running the
following command:

  $ find net/netfilter -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig      | 2 +-
 net/netfilter/ipvs/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 56a2531a3402..172d74560632 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -816,7 +816,7 @@ config NETFILTER_XT_TARGET_CLASSIFY
 	  the priority of a packet. Some qdiscs can use this value for
 	  classification, among these are:
 
-  	  atm, cbq, dsmark, pfifo_fast, htb, prio
+	  atm, cbq, dsmark, pfifo_fast, htb, prio
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index d61886874940..271da8447b29 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -318,7 +318,7 @@ config IP_VS_MH_TAB_INDEX
 comment 'IPVS application helper'
 
 config	IP_VS_FTP
-  	tristate "FTP protocol helper"
+	tristate "FTP protocol helper"
 	depends on IP_VS_PROTO_TCP && NF_CONNTRACK && NF_NAT && \
 		NF_CONNTRACK_FTP
 	select IP_VS_NFCT
-- 
2.30.2

