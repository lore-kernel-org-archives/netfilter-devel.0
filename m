Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC66C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A5C20881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfEWNnq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:46 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48828 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNnq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0W-0007jS-7l; Thu, 23 May 2019 15:43:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/8] netfilter: ipv4: prefer skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:08 +0200
Message-Id: <20190523134412.3295-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

.. so skb_make_writable can be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arpt_mangle.c            | 2 +-
 net/ipv4/netfilter/ipt_ECN.c                | 4 ++--
 net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c | 2 +-
 net/netfilter/nf_nat_sip.c                  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a5e52a9f0a12..b3624cbf4b6e 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -16,7 +16,7 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
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
index 0a8a60c1bf9a..3361d05ad600 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -196,7 +196,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
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
2.21.0

