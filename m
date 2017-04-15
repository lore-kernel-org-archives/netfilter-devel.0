From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/6] netfilter: conntrack: use u8 for extension sizes again
Date: Sun, 16 Apr 2017 01:29:19 +0200
Message-ID: <20170415232919.13671-7-fw@strlen.de>
References: <20170415232919.13671-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57850 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755202AbdDOX32 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 19:29:28 -0400
In-Reply-To: <20170415232919.13671-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 223b02d923ecd7c84cf9780bb3686f455d279279
("netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len")
had to increase size of the extension offsets because total size of the
extensions had increased to a point where u8 did overflow.

3 years later we've managed to diet extensions a bit and we no longer
need u16.  Furthermore we can now add a compile-time assertion for this
problem.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h |  4 ++--
 net/netfilter/nf_conntrack_core.c           | 33 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 4ec645c8b647..5fc908dc9f32 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -43,8 +43,8 @@ enum nf_ct_ext_id {
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
 	struct rcu_head rcu;
-	u16 offset[NF_CT_EXT_NUM];
-	u16 len;
+	u8 offset[NF_CT_EXT_NUM];
+	u8 len;
 	char data[0];
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 03150f60714d..62368b05cef5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1804,12 +1804,45 @@ EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
+static unsigned int total_extension_size(void)
+{
+	/* remember to add new extensions below */
+	BUILD_BUG_ON(NF_CT_EXT_NUM > 9);
+
+	return sizeof(struct nf_ct_ext) +
+	       sizeof(struct nf_conn_help)
+#if IS_ENABLED(CONFIG_NF_NAT)
+		+ sizeof(struct nf_conn_nat)
+#endif
+		+ sizeof(struct nf_conn_seqadj)
+		+ sizeof(struct nf_conn_acct)
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+		+ sizeof(struct nf_conntrack_ecache)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+		+ sizeof(struct nf_conn_tstamp)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+		+ sizeof(struct nf_conn_timeout)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+		+ sizeof(struct nf_conn_labels)
+#endif
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
+		+ sizeof(struct nf_conn_synproxy)
+#endif
+	;
+};
+
 int nf_conntrack_init_start(void)
 {
 	int max_factor = 8;
 	int ret = -ENOMEM;
 	int i;
 
+	/* struct nf_ct_ext uses u8 to store offsets/size */
+	BUILD_BUG_ON(total_extension_size() > 255u);
+
 	seqcount_init(&nf_conntrack_generation);
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
-- 
2.10.2

