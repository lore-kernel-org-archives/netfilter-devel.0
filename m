Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744D8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351298AbiCXPf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 11:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349339AbiCXPf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 11:35:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34A24833C
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2022 08:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X1p1mprM6dVne8DCTj1T/gmImIAAxQ9fXAGZM3A9hRQ=; b=c1REQxUOW7cWXXNe4EbS7APtij
        73NLamiNsuniQt3dPHCAGZYkW2JlcAp5YEhTza7jqPTaHijP4j00cHAqRaHi3eebNDOIS0qk+hpkP
        AkS/TlVDUVDspBokKO8tFb3LeE/UZ5tKoxzJl6VnjEv8kHJFlVmz1xI0/4Tbje9eRicqIugBCcTAy
        mLHMpRrF2HL+hue6nsTKFhcgsLWM7k9K79WdTl/BbgF+weQfBFpXdvjOtjD5g63BGsuu6lc7TdZAW
        cNxMSTrmYoiyfzGYYaCllthlknlQGtIOlwA3/fBbihPIzPl77VrU/gBKO0m83iHx+BgsIB3VQYT+z
        d4UxzRxA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXPTk-0004Ey-0Z; Thu, 24 Mar 2022 16:34:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: nf_log_syslog: Consolidate entry checks
Date:   Thu, 24 Mar 2022 16:34:22 +0100
Message-Id: <20220324153422.8497-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Every syslog logging callback has to perform the same check to cover for
rogue containers, introduce a helper for clarity. Drop the FIXME as
there is a viable solution since commit 2851940ffee31 ("netfilter: allow
logging from non-init namespaces").

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_log_syslog.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index a7ff6fdbafc94..77bcb10fc586a 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -40,6 +40,12 @@ struct arppayload {
 	unsigned char ip_dst[4];
 };
 
+/* Guard against containers flooding syslog. */
+static bool nf_log_allowed(const struct net *net)
+{
+	return net_eq(net, &init_net) || sysctl_nf_log_all_netns;
+}
+
 static void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
 {
 	u16 vid;
@@ -133,8 +139,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -831,8 +836,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -867,8 +871,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -904,8 +907,7 @@ static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
-- 
2.34.1

