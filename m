Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E36C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0090B20693
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbfIMLb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:31:58 -0400
Received: from correo.us.es ([193.147.175.20]:42632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388105AbfIMLbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 397874FFE1A
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C8ABA7E16
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22110A7E18; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 148EDA7EC1;
        Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D87224265A5A;
        Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/27] netfilter: ip_tables: remove unused function declarations.
Date:   Fri, 13 Sep 2019 13:30:47 +0200
Message-Id: <20190913113102.15776-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Two headers include declarations of functions which are never defined.
Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/ip_tables.h  | 2 --
 include/linux/netfilter_ipv6/ip6_tables.h | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index f40a65481df4..0b0d43ad9ed9 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -23,8 +23,6 @@
 #include <linux/init.h>
 #include <uapi/linux/netfilter_ipv4/ip_tables.h>
 
-extern void ipt_init(void) __init;
-
 #if IS_ENABLED(CONFIG_NETFILTER)
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 53b7309613bf..666450c117bf 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -23,9 +23,8 @@
 #include <linux/init.h>
 #include <uapi/linux/netfilter_ipv6/ip6_tables.h>
 
-extern void ip6t_init(void) __init;
-
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
+
 #if IS_ENABLED(CONFIG_NETFILTER)
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
-- 
2.11.0

