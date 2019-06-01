Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC087C28CC4
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90CA227775
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFASYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 14:24:22 -0400
Received: from mail.us.es ([193.147.175.20]:40072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfFASYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B5EFFEFB0
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEBC7DA703
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DDF28FF2CC; Sat,  1 Jun 2019 20:23:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2611FDA702;
        Sat,  1 Jun 2019 20:23:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BAA1B4265A32;
        Sat,  1 Jun 2019 20:23:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/15] netfilter: ipv4: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:35 +0200
Message-Id: <20190601182340.2662-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

.. so skb_make_writable can be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arpt_mangle.c            | 2 +-
 net/ipv4/netfilter/ipt_ECN.c                | 4 ++--
 net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c | 2 +-
 net/netfilter/nf_nat_sip.c                  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 87ca2c42359b..a4e07e5e9c11 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -17,7 +17,7 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	unsigned char *arpptr;
 	int pln, hln;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return NF_DROP;
 
 	arp = arp_hdr(skb);
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index aaaf9a81fbc9..9f6751893660 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -32,7 +32,7 @@ set_ect_ip(struct sk_buff *skb, const struct ipt_ECN_info *einfo)
 
 	if ((iph->tos & IPT_ECN_IP_MASK) != (einfo->ip_ect & IPT_ECN_IP_MASK)) {
 		__u8 oldtos;
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return false;
 		iph = ip_hdr(skb);
 		oldtos = iph->tos;
@@ -61,7 +61,7 @@ set_ect_tcp(struct sk_buff *skb, const struct ipt_ECN_info *einfo)
 	     tcph->cwr == einfo->proto.tcp.cwr))
 		return true;
 
-	if (!skb_make_writable(skb, ip_hdrlen(skb) + sizeof(*tcph)))
+	if (skb_ensure_writable(skb, ip_hdrlen(skb) + sizeof(*tcph)))
 		return false;
 	tcph = (void *)ip_hdr(skb) + ip_hdrlen(skb);
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 7875c98072eb..15f2b2604890 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -59,7 +59,7 @@ static int set_addr(struct sk_buff *skb, unsigned int protoff,
 			net_notice_ratelimited("nf_nat_h323: nf_nat_mangle_udp_packet error\n");
 			return -1;
 		}
-		/* nf_nat_mangle_udp_packet uses skb_make_writable() to copy
+		/* nf_nat_mangle_udp_packet uses skb_ensure_writable() to copy
 		 * or pull everything in a linear buffer, so we can safely
 		 * use the skb pointers now */
 		*data = skb->data + ip_hdrlen(skb) + sizeof(struct udphdr);
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index 657d2dcec3cc..717b726504fe 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -186,7 +186,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 		return NF_DROP;
 	}
 
-	if (!skb_make_writable(skb, skb->len)) {
+	if (skb_ensure_writable(skb, skb->len)) {
 		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 464387b3600f..07805bf4d62a 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -285,7 +285,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 	if (dir == IP_CT_DIR_REPLY && ct_sip_info->forced_dport) {
 		struct udphdr *uh;
 
-		if (!skb_make_writable(skb, skb->len)) {
+		if (skb_ensure_writable(skb, skb->len)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle packet");
 			return NF_DROP;
 		}
-- 
2.11.0

