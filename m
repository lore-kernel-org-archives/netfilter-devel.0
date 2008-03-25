From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/32]: nf_conntrack_sip: flush expectations on call termination
Date: Tue, 25 Mar 2008 15:15:22 +0100 (MET)
Message-ID: <20080325141521.10539.52742.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32952 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYCYOPX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:23 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: flush expectations on call termination

Flush the RTP expectations we've created when a call is hung up or
terminated otherwise.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 26599b7c1bd613fbb4f397ebfb64fd01a5f34068
tree 70f97fa632aa7a92787d0e8e527269099fb04769
parent fc1d4b6b9937a801590c454b68317734a809be0b
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:11 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:57 +0100

 net/netfilter/nf_conntrack_sip.c |   52 +++++++++++++++++++++++++++++++++++---
 1 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 71f744a..8e7e5b4 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter.h>
 
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
@@ -533,6 +534,22 @@ int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_sdp_header);
 
+static void flush_expectations(struct nf_conn *ct)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n, *next;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+		if (!del_timer(&exp->timeout))
+			continue;
+		nf_ct_unlink_expect(exp);
+		nf_ct_expect_put(exp);
+	}
+	spin_unlock_bh(&nf_conntrack_lock);
+}
+
 static int set_expected_rtp(struct sk_buff *skb,
 			    const char **dptr, unsigned int *datalen,
 			    union nf_inet_addr *addr, __be16 port)
@@ -606,32 +623,58 @@ static int process_invite_response(struct sk_buff *skb,
 				   const char **dptr, unsigned int *datalen,
 				   unsigned int cseq, unsigned int code)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
-
-	return NF_ACCEPT;
+	else {
+		flush_expectations(ct);
+		return NF_ACCEPT;
+	}
 }
 
 static int process_update_response(struct sk_buff *skb,
 				   const char **dptr, unsigned int *datalen,
 				   unsigned int cseq, unsigned int code)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
-
-	return NF_ACCEPT;
+	else {
+		flush_expectations(ct);
+		return NF_ACCEPT;
+	}
 }
 
 static int process_prack_response(struct sk_buff *skb,
 				  const char **dptr, unsigned int *datalen,
 				  unsigned int cseq, unsigned int code)
 {
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
+	else {
+		flush_expectations(ct);
+		return NF_ACCEPT;
+	}
+}
+
+static int process_bye_request(struct sk_buff *skb,
+			       const char **dptr, unsigned int *datalen,
+			       unsigned int cseq)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
+	flush_expectations(ct);
 	return NF_ACCEPT;
 }
 
@@ -640,6 +683,7 @@ static const struct sip_handler sip_handlers[] = {
 	SIP_HANDLER("UPDATE", process_sdp, process_update_response),
 	SIP_HANDLER("ACK", process_sdp, NULL),
 	SIP_HANDLER("PRACK", process_sdp, process_prack_response),
+	SIP_HANDLER("BYE", process_bye_request, NULL),
 };
 
 static int process_sip_response(struct sk_buff *skb,
