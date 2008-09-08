From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 24/33] netns ct: SIP conntracking in netns
Date: Mon,  8 Sep 2008 07:03:01 +0400
Message-ID: <1220842990-30500-24-git-send-email-adobriyan@gmail.com>
References: <48C01046.2070704@trash.net>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:48601 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYIHDC7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 23:02:59 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1163113muf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Sep 2008 20:02:58 -0700 (PDT)
In-Reply-To: <48C01046.2070704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index a006080..6813f1c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -736,6 +736,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp, *rtp_exp, *rtcp_exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct net *net = nf_ct_net(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
@@ -775,7 +776,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 
 	rcu_read_lock();
 	do {
-		exp = __nf_ct_expect_find(&init_net, &tuple);
+		exp = __nf_ct_expect_find(net, &tuple);
 
 		if (!exp || exp->master == ct ||
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
