Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA49C47099
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31C0A6140C
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFCW77 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:59:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45830 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhFCW77 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 18:59:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0E98A64207
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 00:57:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2 4/5] extensions: libxt_tcp: rework translation to use flags match representation
Date:   Fri,  4 Jun 2021 00:58:05 +0200
Message-Id: <20210603225806.13625-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603225806.13625-1-pablo@netfilter.org>
References: <20210603225806.13625-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the new flags match representation available since nftables 0.9.9
to simplify the translation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_TCPMSS.txlate |  4 ++--
 extensions/libxt_tcp.c         | 10 +++++-----
 extensions/libxt_tcp.txlate    |  6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_TCPMSS.txlate b/extensions/libxt_TCPMSS.txlate
index 6a64d2ce9bfd..3dbbad66c560 100644
--- a/extensions/libxt_TCPMSS.txlate
+++ b/extensions/libxt_TCPMSS.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
-nft add rule ip filter FORWARD tcp flags & (syn|rst) == syn counter tcp option maxseg size set rt mtu
+nft add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set rt mtu
 
 iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 90
-nft add rule ip filter FORWARD tcp flags & (syn|rst) == syn counter tcp option maxseg size set 90
+nft add rule ip filter FORWARD tcp flags syn / syn,rst counter tcp option maxseg size set 90
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 58f3c0a0c3c2..4bcd94630111 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -381,7 +381,7 @@ static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 		for (i = 0; (flags & tcp_flag_names_xlate[i].flag) == 0; i++);
 
 		if (have_flag)
-			xt_xlate_add(xl, "|");
+			xt_xlate_add(xl, ",");
 
 		xt_xlate_add(xl, "%s", tcp_flag_names_xlate[i].name);
 		have_flag = 1;
@@ -435,11 +435,11 @@ static int tcp_xlate(struct xt_xlate *xl,
 		return 0;
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
-		xt_xlate_add(xl, "%stcp flags & (", space);
-		print_tcp_xlate(xl, tcpinfo->flg_mask);
-		xt_xlate_add(xl, ") %s ",
-			   tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!=": "==");
+		xt_xlate_add(xl, "%stcp flags %s", space,
+			     tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!= ": "");
 		print_tcp_xlate(xl, tcpinfo->flg_cmp);
+		xt_xlate_add(xl, " / ");
+		print_tcp_xlate(xl, tcpinfo->flg_mask);
 	}
 
 	return 1;
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
index bba63324df2b..921d4af024d3 100644
--- a/extensions/libxt_tcp.txlate
+++ b/extensions/libxt_tcp.txlate
@@ -11,13 +11,13 @@ iptables-translate -I OUTPUT -p tcp --dport 1020:1023 --sport 53 -j ACCEPT
 nft insert rule ip filter OUTPUT tcp sport 53 tcp dport 1020-1023 counter accept
 
 iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
-nft add rule ip filter INPUT tcp flags & fin|ack == fin counter drop
+nft add rule ip filter INPUT tcp flags fin / fin,ack counter drop
 
 iptables-translate -A INPUT -p tcp --syn -j ACCEPT
-nft add rule ip filter INPUT tcp flags & (fin|syn|rst|ack) == syn counter accept
+nft add rule ip filter INPUT tcp flags syn / fin,syn,rst,ack counter accept
 
 iptables-translate -A INPUT -p tcp --syn --dport 80 -j ACCEPT
-nft add rule ip filter INPUT tcp dport 80 tcp flags & (fin|syn|rst|ack) == syn counter accept
+nft add rule ip filter INPUT tcp dport 80 tcp flags syn / fin,syn,rst,ack counter accept
 
 iptables-translate -A INPUT -f -p tcp
 nft add rule ip filter INPUT ip frag-off & 0x1fff != 0 ip protocol tcp counter
-- 
2.20.1

