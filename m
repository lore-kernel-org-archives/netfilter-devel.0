From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/6] secmark: export binary yes/no rather than kernel internal
	secid
Date: Fri, 24 Sep 2010 16:45:31 -0400
Message-ID: <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jmorris@namei.org, sds@tycho.nsa.gov, jengelh@medozas.de,
	paul.moore@hp.com, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently the nfconntrack export code sends the kernel internal secid to
userspace in a couple of proc files and over netlink as an integer.  This
is wrong.  This number is a kernel internal.  This patch changes the export
code to output either 0 or 1 for this value.  A future patch will implement
sending the name rather than the number in a new field.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    2 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 244f7cb..053d7d3 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -149,7 +149,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	if (seq_printf(s, "secmark=%u ", ct->secmark))
+	if (seq_printf(s, "secmark=%u ", ct->secmark ? 1 : 0))
 		goto release;
 #endif
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5bae1cd..3a50699 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -247,7 +247,7 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark));
+	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark ? 1 : 0));
 	return 0;
 
 nla_put_failure:
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index eb973fc..a5761d3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -169,7 +169,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	if (seq_printf(s, "secmark=%u ", ct->secmark))
+	if (seq_printf(s, "secmark=%u ", ct->secmark ? 1 : 0))
 		goto release;
 #endif
 
