From: Mikael Pettersson <mikpe@it.uu.se>
Subject: [PATCH 2.6.20-rc5] netfilter: xt_state compile failure
Date: Mon, 15 Jan 2007 09:02:43 +0100
Message-ID: <17835.13603.658813.332230@alkaid.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932098AbXAOIDZ@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This config:

CONFIG_NF_CONNTRACK_ENABLED=m
# CONFIG_NF_CONNTRACK_SUPPORT is not set
CONFIG_IP_NF_CONNTRACK_SUPPORT=y
CONFIG_IP_NF_CONNTRACK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_MATCH_STATE=m

causes this compilation failure:

  gcc -m32 -Wp,-MD,net/netfilter/.xt_state.o.d  -nostdinc -isystem /local/home/mikpeadm/pkgs/linux-ppc/gcc-4.1.1/lib/gcc/powerpc-unknown-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Iarch/powerpc -Iarch/powerpc/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -msoft-float -pipe -Iarch/powerpc -ffixed-r2 -mmultiple -mno-altivec -funit-at-a-time -mstring -mcpu=powerpc -Wa,-maltivec -fomit-frame-pointer  -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign   -DMODULE -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(xt_state)"  -D"KBUILD_MODNAME=KBUILD_STR(xt_state)" -c -o net/netfilter/xt_state.o net/netfilter/xt_state.c
In file included from net/netfilter/xt_state.c:13:
include/net/netfilter/nf_conntrack_compat.h: In function 'nf_ct_l3proto_try_module_get':
include/net/netfilter/nf_conntrack_compat.h:70: error: 'PF_INET' undeclared (first use in this function)
include/net/netfilter/nf_conntrack_compat.h:70: error: (Each undeclared identifier is reported only once
include/net/netfilter/nf_conntrack_compat.h:70: error: for each function it appears in.)
include/net/netfilter/nf_conntrack_compat.h:71: warning: control reaches end of non-void function
make[2]: *** [net/netfilter/xt_state.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

A simple fix is to have nf_conntrack_compat.h #include <linux/socket.h>.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

--- linux-2.6.20-rc5/include/net/netfilter/nf_conntrack_compat.h.~1~    2007-01-15 09:00:26.000000000 +0100
+++ linux-2.6.20-rc5/include/net/netfilter/nf_conntrack_compat.h        2007-01-15 09:00:32.000000000 +0100
@@ -6,6 +6,7 @@
 #if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/socket.h>
 
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
 static inline u_int32_t *nf_ct_get_mark(const struct sk_buff *skb,
