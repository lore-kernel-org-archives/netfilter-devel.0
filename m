From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/10] accessors to internal member in conntrack
Date: Thu, 01 Sep 2005 18:14:17 +0900 (JST)
Message-ID: <200509010914.j819EHvS005525@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_17_2005_135)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Sep__1_18_14_17_2005_135)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


These inline functions make it for matches/targets easy to access to
the internal members in conntrack without compatibility considerations
and more costs.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_17_2005_135)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-compat.patch"

[NETFILTER] accessors to internal member in conntrack

These inline functions make it easy for match/targets to access to
the internal members in conntrack without compatibility considerations
and more costs.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 2ca0aa6572fa17a994195213a2e8b23921fbf889
tree f8ccd876f2e31526da6938e7ed96f97fa3365ec6
parent 80387d5afee17b1f3119aa6d068f6351450bac0e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:28:50 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:28:50 +0900

 include/linux/netfilter/nf_conntrack_compat.h |  108 +++++++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_compat.h b/include/linux/netfilter/nf_conntrack_compat.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_compat.h
@@ -0,0 +1,108 @@
+#ifndef _NF_CONNTRACK_COMPAT_H
+#define _NF_CONNTRACK_COMPAT_H
+
+#ifdef __KERNEL__
+
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
+static inline u_int32_t *nf_ct_get_mark(const struct sk_buff *skb,
+					u_int32_t *ctinfo)
+{
+	struct ip_conntrack *ct = ip_conntrack_get(skb, ctinfo);
+
+	if (ct)
+		return &ct->mark;
+	else
+		return NULL;
+}
+#endif /* CONFIG_IP_NF_CONNTRACK_MARK */
+
+#ifdef CONFIG_IP_NF_CT_ACCT
+static inline struct ip_conntrack_counter *
+nf_ct_get_counters(const struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack *ct = ip_conntrack_get(skb, &ctinfo);
+
+	if (ct)
+		return ct->counters;
+	else
+		return NULL;
+}
+#endif /* CONFIG_IP_NF_CT_ACCT */
+
+static inline int nf_ct_is_untracked(const struct sk_buff *skb)
+{
+	return (skb->nfct == &ip_conntrack_untracked.ct_general);
+}
+
+static inline void nf_ct_untrack(struct sk_buff *skb)
+{
+	skb->nfct = &ip_conntrack_untracked.ct_general;
+}
+
+static inline int nf_ct_get_ctinfo(const struct sk_buff *skb,
+				   enum ip_conntrack_info *ctinfo)
+{
+	struct ip_conntrack *ct = ip_conntrack_get(skb, ctinfo);
+	return (ct != NULL);
+}
+
+#else /* CONFIG_IP_NF_CONNTRACK */
+
+#include <linux/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <linux/netfilter/nf_conntrack.h>
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+
+static inline u_int32_t *nf_ct_get_mark(const struct sk_buff *skb,
+					u_int32_t *ctinfo)
+{
+	struct nf_conn *ct = nf_ct_get(skb, ctinfo);
+
+	if (ct)
+		return &ct->mark;
+	else
+		return NULL;
+}
+#endif /* CONFIG_NF_CONNTRACK_MARK */
+
+#ifdef CONFIG_NF_CT_ACCT
+static inline struct ip_conntrack_counter *
+nf_ct_get_counters(const struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
+	if (ct)
+		return ct->counters;
+	else
+		return NULL;
+}
+#endif /* CONFIG_NF_CT_ACCT */
+
+static inline int nf_ct_is_untracked(const struct sk_buff *skb)
+{
+	return (skb->nfct == &nf_conntrack_untracked.ct_general);
+}
+
+static inline void nf_ct_untrack(struct sk_buff *skb)
+{
+	skb->nfct = &nf_conntrack_untracked.ct_general;
+}
+
+static inline int nf_ct_get_ctinfo(const struct sk_buff *skb,
+				   enum ip_conntrack_info *ctinfo)
+{
+	struct nf_conn *ct = nf_ct_get(skb, ctinfo);
+	return (ct != NULL);
+}
+
+#endif /* CONFIG_IP_NF_CONNTRACK */
+
+#endif /* __KERNEL__ */
+
+#endif /* _NF_CONNTRACK_COMPAT_H */

----Next_Part(Thu_Sep__1_18_14_17_2005_135)----
