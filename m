From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/53] netfilter: conntrack: use u8 for extension sizes again
Date: Mon,  1 May 2017 12:46:58 +0200
Message-ID: <1493635640-24325-32-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 223b02d923ecd7c84cf9780bb3686f455d279279
("netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len")
had to increase size of the extension offsets because total size of the
extensions had increased to a point where u8 did overflow.

3 years later we've managed to diet extensions a bit and we no longer
need u16.  Furthermore we can now add a compile-time assertion for this
problem.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
