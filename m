From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] netfilter: xt_AUDIT: only generate audit log when audit enabled
Date: Mon, 4 Mar 2013 18:29:12 +0800
Message-ID: <1362392952-11268-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: tgraf@redhat.com, Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9649 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3CDK2x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:28:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should stop generting audit log if audit is disabled.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/xt_AUDIT.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index ba92824..3228d7f 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -124,6 +124,9 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_audit_info *info = par->targinfo;
 	struct audit_buffer *ab;
 
+	if (audit_enabled == 0)
+		goto errout;
+
 	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
-- 
1.7.11.7

