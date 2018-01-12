From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [nf-next 2/3] netfilter: add an option to control iptables SEG6 target support
Date: Fri, 12 Jan 2018 05:39:35 +0100
Message-ID: <1515731976-6338-2-git-send-email-amsalam20@gmail.com>
References: <1515731976-6338-1-git-send-email-amsalam20@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515731976-6338-1-git-send-email-amsalam20@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds a new option CONFIG_IP6_NF_TARGET_SEG6 to
enable/disable support of iptables SEG6 target.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 net/ipv6/netfilter/Kconfig  | 12 ++++++++++++
 net/ipv6/netfilter/Makefile |  1 +
 2 files changed, 13 insertions(+)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4a634b7..8e98afc 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -364,6 +364,18 @@ config IP6_NF_TARGET_NPT
 
 endif # IP6_NF_NAT
 
+if IPV6_SEG6_LWTUNNEL
+config IP6_NF_TARGET_SEG6
+        tristate 'IPv6 Segment Routing "SEG6" target support'
+        depends on NETFILTER_ADVANCED
+        help
+          SEG6 is an special target for IPv6 Segment Routing encapsualted
+          packets. It supports a set of Segment Routing specific actions
+          that are based on SRH information. It is useful for SRv6 Service
+          Function chaining use-cases.
+
+          To compile it as a module, choose M here.  If unsure, say N.
+endif # IPV6_SEG6_LWTUNNEL
 endif # IP6_NF_IPTABLES
 
 endmenu
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index d984057..67eff84 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_IP6_NF_TARGET_MASQUERADE) += ip6t_MASQUERADE.o
 obj-$(CONFIG_IP6_NF_TARGET_NPT) += ip6t_NPT.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
 obj-$(CONFIG_IP6_NF_TARGET_SYNPROXY) += ip6t_SYNPROXY.o
+obj-$(CONFIG_IP6_NF_TARGET_SEG6) += ip6t_SEG6.o
-- 
2.1.4
