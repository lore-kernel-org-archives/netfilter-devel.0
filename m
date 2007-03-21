From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_netlink: add missing dependency on
	NF_NAT
Date: Wed, 21 Mar 2007 06:21:47 +0100 (MET)
Message-ID: <20070321052123.6534.58919.sendpatchset@localhost.localdomain>
References: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_netlink: add missing dependency on NF_NAT

NF_CT_NETLINK=y, NF_NAT=m results in:

 LD      .tmp_vmlinux1
 net/built-in.o: dans la fonction « nfnetlink_parse_nat_proto »:
 nf_conntrack_netlink.c:(.text+0x28db9): référence indéfinie vers « nf_nat_proto_find_get »
 nf_conntrack_netlink.c:(.text+0x28dd6): référence indéfinie vers « nf_nat_proto_put »
 net/built-in.o: dans la fonction « ctnetlink_new_conntrack »:
 nf_conntrack_netlink.c:(.text+0x29959): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29b35): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29cf7): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29de2): référence indéfinie vers « nf_nat_setup_info »
 make: *** [.tmp_vmlinux1] Erreur 1 

Reported by Kevin Baradon <kevin.baradon@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b8ea8f4f4091c6e4424b46e8d56bb0366dfd3ee
tree 70c237a3e129df7366ac4a52f6efa142aa0a7d98
parent cd05a1f818073a623455a58e756c5b419fc98db9
author Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +0100

 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 253fce3..54698af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -275,6 +275,7 @@ config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
 	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	depends on NF_NAT=n || NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
 
