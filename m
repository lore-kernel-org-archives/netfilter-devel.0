From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] Add SELinux context support to AUDIT target
Date: Fri, 20 May 2011 02:09:46 +0100
Message-ID: <4DD5BF5A.2030108@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab1ETBJu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2011 21:09:50 -0400
Received: by wwa36 with SMTP id 36so3465031wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2011 18:09:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add SELinux context support for AUDIT target. Typical (raw auditd) output after applying this patch would be:

type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3 len=52 inif=? outif=eth0 subj=system_u:object_r:sshd_packet_t:s0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 proto=6 sport=56150 dport=22


Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 net/netfilter/xt_AUDIT.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 363a99e..438f82a 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_AUDIT.h>
 #include <linux/netfilter_bridge/ebtables.h>
+#include <linux/security.h>
 #include <net/ipv6.h>
 #include <net/ip.h>
 
@@ -122,6 +123,10 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	u32 len;
+	char *secctx;
+#endif
 
 	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
@@ -135,6 +140,14 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (skb->mark)
 		audit_log_format(ab, " mark=%#x", skb->mark);
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	if (skb->secmark)
+	  	if (!security_secid_to_secctx(skb->secmark, &secctx, &len)) {
+			audit_log_format(ab, " subj=%s", secctx);
+			security_release_secctx(secctx, len);
+		}
+#endif
+
 	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
 		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
 				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
-- 
1.7.3.4



