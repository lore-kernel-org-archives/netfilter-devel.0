From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: Fix removal of GRE expectation entries created by PPTP
Date: Tue, 10 Nov 2015 17:36:29 +0100
Message-ID: <1447173390-2993-2-git-send-email-pablo@netfilter.org>
References: <1447173390-2993-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52895 "EHLO salida-rhel7.int"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753804AbbKJQgr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 11:36:47 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by salida-rhel7.int (Postfix) with ESMTP id 7DBE31373CC
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:36:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6A9314DC03
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:36:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 305B14EED2
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:36:41 +0100 (CET)
In-Reply-To: <1447173390-2993-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>

The uninitialized tuple structure caused incorrect hash calculation
and the lookup failed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=106441
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
---
Original patch posted on kernel bugzilla.

 net/ipv4/netfilter/nf_nat_pptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 657d230..b3ca21b 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -45,7 +45,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	struct net *net = nf_ct_net(ct);
 	const struct nf_conn *master = ct->master;
 	struct nf_conntrack_expect *other_exp;
-	struct nf_conntrack_tuple t;
+	struct nf_conntrack_tuple t = {};
 	const struct nf_ct_pptp_master *ct_pptp_info;
 	const struct nf_nat_pptp *nat_pptp_info;
 	struct nf_nat_range range;
-- 
2.1.4

