From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Tue, 07 Jun 2011 11:32:35 +0100
Message-ID: <4DEDFE43.5060402@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@redhat.com>, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux-audit <linux-audit@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65434 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1FGKcj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:32:39 -0400
Received: by wya21 with SMTP id 21so3440188wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jun 2011 03:32:38 -0700 (PDT)
In-Reply-To: <4DEDEB99.4070601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add SELinux context support to AUDIT target - 3rd revision (style-type changes made *only* since 2nd revision of this patch). Typical (raw auditd) output after applying this patch would be:

type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=1 len=52 inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 proto=6 sport=56150 dport=22 obj=system_u:object_r:ssh_packet_t:s0
type=NETFILTER_PKT msg=audit(1306772064.079:56): action=0 hook=3 len=48 inif=eth0 outif=? smac=00:05:5d:7c:27:0b dmac=00:02:b3:0a:7f:81 macproto=0x0800 saddr=10.1.2.1 daddr=10.1.1.7 ipid=462 proto=6 sport=3561 dport=22 obj=system_u:object_r:ssh_packet_t:s0

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 net/netfilter/xt_AUDIT.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 363a99e..26933ef 100644
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
@@ -163,6 +170,15 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		break;
 	}
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	if (skb->secmark) {
+	  	if (!security_secid_to_secctx(skb->secmark, &secctx, &len)) {
+			audit_log_format(ab, " obj=%s", secctx);
+			security_release_secctx(secctx, len);
+		}
+	}
+#endif
+
 	audit_log_end(ab);
 
 errout:
-- 
1.7.3.4


