From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH nf] netfilter: conntrack: warn the user if there is a better helper to use
Date: Thu, 21 May 2015 10:57:12 -0300
Message-ID: <78dd7b4675383719e968db577fd89094729641e3.1432216169.git.mleitner@redhat.com>
Cc: daniel@iogearbox.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbbEUN5U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2015 09:57:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

After db29a9508a92 ("netfilter: conntrack: disable generic tracking for
known protocols"), if the specific helper is built but not loaded
(a standard for most distributions) systems with a restrictive firewall
but weak configuration regarding netfilter modules to load, will
silently stop working.

This patch then puts a warning message so the sysadmin knows where to
start looking into. It's a pr_warn_once regardless of protocol itself
but it should be enough to give a hint on where to look.

Cc: Florian Westphal <fw@strlen.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/netfilter/nf_conntrack_proto_generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 60865f1103099383c4263a1a56e691b3c86c3720..2281be419a74b6d8abe0fd7da8d7e8b35d304600 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -90,7 +90,13 @@ static int generic_packet(struct nf_conn *ct,
 static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
 			unsigned int dataoff, unsigned int *timeouts)
 {
-	return nf_generic_should_process(nf_ct_protonum(ct));
+	bool ret;
+
+	ret = nf_generic_should_process(nf_ct_protonum(ct));
+	if (!ret)
+		pr_warn_once("conntrack: generic helper won't handle protocol %d. Please consider loading the specific helper module.\n",
+			     nf_ct_protonum(ct));
+	return ret;
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-- 
2.4.1

