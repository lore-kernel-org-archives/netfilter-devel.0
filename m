From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3] nfctnetlink: fixes and adding support ICMPv6
Date: Fri, 09 Dec 2005 11:42:40 +0900 (JST)
Message-ID: <200512090242.jB92gfMp028039@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
Content-Disposition: inline; filename="01-nfctnetlink-warning.patch"
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

[NETFILTER] nf_conntrack: fixed compiler warning due to missing symbols.

These functions are used only if nfctnetlink are built.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 27993a8d4f8b6b6fef00dd745762ce17452f2025
tree 0db6efb40fee5d91564be9b779447a181ff2359f
parent c03d140a1f9b287beecea06dc125b10b8c2af657
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 00:13:14 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 00:13:14 +0900

 net/netfilter/nf_conntrack_standalone.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4c82f37..d17e42b 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -884,5 +884,8 @@ EXPORT_SYMBOL(nf_conntrack_hash_insert);
 EXPORT_SYMBOL(__nf_conntrack_expect_find);
 EXPORT_SYMBOL(nf_conntrack_expect_find);
 EXPORT_SYMBOL(nf_conntrack_expect_list);
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
 EXPORT_SYMBOL(nf_ct_port_tuple_to_nfattr);
 EXPORT_SYMBOL(nf_ct_port_nfattr_to_tuple);
+#endif
