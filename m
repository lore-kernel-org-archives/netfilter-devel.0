From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] xt_AUDIT.c: add SELinux context support to AUDIT target
Date: Sat, 21 May 2011 00:03:24 +0100
Message-ID: <4DD6F33C.8080202@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@redhat.com>, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57953 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1ETXD2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 19:03:28 -0400
Received: by wwa36 with SMTP id 36so4466606wwa.1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2011 16:03:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All,


I have just realised that when I posted this patch on the netfilter-dev list yesterday I managed to miss all of your email addresses (that will teach me not to work long hours!), so I am re-sending it again - please ignore the previous patch I posted yesterday. So, here goes: 

The following patch adds SELinux context support for AUDIT target. Typical (raw auditd) output after applying this patch would be:

type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3 len=52 inif=? outif=eth0 subj=system_u:object_r:sshd_packet_t:s0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 proto=6 sport=56150 dport=22

This allows filtering by SELinux context as well as the ability to control it via auditctl.

 Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 net/netfilter/xt_AUDIT.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 363a99e..e823f18 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -20,6 +20,9 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_AUDIT.h>
 #include <linux/netfilter_bridge/ebtables.h>
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+#include <linux/security.h>
+#endif
 #include <net/ipv6.h>
 #include <net/ip.h>
 
@@ -122,6 +125,10 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	u32 len;
+	char *secctx;
+#endif
 
 	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
@@ -135,6 +142,14 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
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


