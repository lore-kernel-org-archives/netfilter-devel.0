From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next v2] net: move decnet to staging
Date: Mon, 13 Nov 2017 09:11:42 -0800
Message-ID: <20171113171142.19476-1-sthemmin@microsoft.com>
Cc: devel@driverdev.osuosl.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
To: davem@davemloft.net, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Support for Decnet has been orphaned for some time.
In the interest of reducing the potential bug surface and pre-holiday
cleaning, move the decnet protocol into staging for eventual removal.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
Note original submission was hour or so before net-next closed.
Not sure if you want to wait on this until after 4.15-rc1

v2 - update TODO and move include/net/dn.h to staging as well

 MAINTAINERS                                        |  2 +-
 drivers/staging/Kconfig                            |  5 +++
 drivers/staging/Makefile                           |  1 +
 {net => drivers/staging}/decnet/Kconfig            |  0
 {net => drivers/staging}/decnet/Makefile           |  3 +-
 {net => drivers/staging}/decnet/README             |  0
 drivers/staging/decnet/TODO                        |  4 +++
 {net => drivers/staging}/decnet/af_decnet.c        |  0
 {net => drivers/staging}/decnet/dn_dev.c           |  0
 {net => drivers/staging}/decnet/dn_fib.c           |  0
 {net => drivers/staging}/decnet/dn_neigh.c         |  0
 {net => drivers/staging}/decnet/dn_nsp_in.c        |  0
 {net => drivers/staging}/decnet/dn_nsp_out.c       |  0
 {net => drivers/staging}/decnet/dn_route.c         |  0
 {net => drivers/staging}/decnet/dn_rules.c         |  0
 {net => drivers/staging}/decnet/dn_table.c         |  0
 {net => drivers/staging}/decnet/dn_timer.c         |  0
 .../staging/decnet/include}/net/dn.h               |  0
 {net => drivers/staging}/decnet/netfilter/Kconfig  |  0
 {net => drivers/staging}/decnet/netfilter/Makefile |  3 +-
 .../staging}/decnet/netfilter/dn_rtmsg.c           |  0
 .../staging}/decnet/sysctl_net_decnet.c            |  0
 net/Kconfig                                        |  2 --
 net/Makefile                                       |  1 -
 net/decnet/TODO                                    | 41 ----------------------
 25 files changed, 15 insertions(+), 47 deletions(-)
 rename {net => drivers/staging}/decnet/Kconfig (100%)
 rename {net => drivers/staging}/decnet/Makefile (84%)
 rename {net => drivers/staging}/decnet/README (100%)
 create mode 100644 drivers/staging/decnet/TODO
 rename {net => drivers/staging}/decnet/af_decnet.c (100%)
 rename {net => drivers/staging}/decnet/dn_dev.c (100%)
 rename {net => drivers/staging}/decnet/dn_fib.c (100%)
 rename {net => drivers/staging}/decnet/dn_neigh.c (100%)
 rename {net => drivers/staging}/decnet/dn_nsp_in.c (100%)
 rename {net => drivers/staging}/decnet/dn_nsp_out.c (100%)
 rename {net => drivers/staging}/decnet/dn_route.c (100%)
 rename {net => drivers/staging}/decnet/dn_rules.c (100%)
 rename {net => drivers/staging}/decnet/dn_table.c (100%)
 rename {net => drivers/staging}/decnet/dn_timer.c (100%)
 rename {include => drivers/staging/decnet/include}/net/dn.h (100%)
 rename {net => drivers/staging}/decnet/netfilter/Kconfig (100%)
 rename {net => drivers/staging}/decnet/netfilter/Makefile (62%)
 rename {net => drivers/staging}/decnet/netfilter/dn_rtmsg.c (100%)
 rename {net => drivers/staging}/decnet/sysctl_net_decnet.c (100%)
 delete mode 100644 net/decnet/TODO

diff --git a/MAINTAINERS b/MAINTAINERS
index 29aa89a1837b..66e2d302d9eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3968,7 +3968,7 @@ W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Orphan
 F:	Documentation/networking/decnet.txt
-F:	net/decnet/
+F:	drivers/staging/decnet/
 
 DECSTATION PLATFORM SUPPORT
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 554683912cff..e30af73c3797 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -30,6 +30,11 @@ source "drivers/staging/wlan-ng/Kconfig"
 
 source "drivers/staging/comedi/Kconfig"
 
+if NETFILTER
+source "drivers/staging/decnet/netfilter/Kconfig"
+endif
+source "drivers/staging/decnet/Kconfig"
+
 source "drivers/staging/olpc_dcon/Kconfig"
 
 source "drivers/staging/rtl8192u/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 6e536020029a..89655cc80a91 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IRDA)		+= irda/net/
 obj-$(CONFIG_IRDA)		+= irda/drivers/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_COMEDI)		+= comedi/
+obj-$(CONFIG_DECNET)		+= decnet/
 obj-$(CONFIG_FB_OLPC_DCON)	+= olpc_dcon/
 obj-$(CONFIG_RTL8192U)		+= rtl8192u/
 obj-$(CONFIG_RTL8192E)		+= rtl8192e/
diff --git a/net/decnet/Kconfig b/drivers/staging/decnet/Kconfig
similarity index 100%
rename from net/decnet/Kconfig
rename to drivers/staging/decnet/Kconfig
diff --git a/net/decnet/Makefile b/drivers/staging/decnet/Makefile
similarity index 84%
rename from net/decnet/Makefile
rename to drivers/staging/decnet/Makefile
index 9e38122d942b..bda16fefbef2 100644
--- a/net/decnet/Makefile
+++ b/drivers/staging/decnet/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+ccflags-y := -I$(srctree)/drivers/staging/decnet/include
+
 obj-$(CONFIG_DECNET) += decnet.o
 
 decnet-y := af_decnet.o dn_nsp_in.o dn_nsp_out.o \
@@ -8,4 +10,3 @@ decnet-$(CONFIG_DECNET_ROUTER) += dn_fib.o dn_rules.o dn_table.o
 decnet-y += sysctl_net_decnet.o
 
 obj-$(CONFIG_NETFILTER) += netfilter/
-
diff --git a/net/decnet/README b/drivers/staging/decnet/README
similarity index 100%
rename from net/decnet/README
rename to drivers/staging/decnet/README
diff --git a/drivers/staging/decnet/TODO b/drivers/staging/decnet/TODO
new file mode 100644
index 000000000000..a0ec2e444885
--- /dev/null
+++ b/drivers/staging/decnet/TODO
@@ -0,0 +1,4 @@
+The DecNet code will be removed soon from the kernel tree as it is old,
+obsolete, and buggy.
+
+Don't worry about fixing up anything here, it's not needed.
diff --git a/net/decnet/af_decnet.c b/drivers/staging/decnet/af_decnet.c
similarity index 100%
rename from net/decnet/af_decnet.c
rename to drivers/staging/decnet/af_decnet.c
diff --git a/net/decnet/dn_dev.c b/drivers/staging/decnet/dn_dev.c
similarity index 100%
rename from net/decnet/dn_dev.c
rename to drivers/staging/decnet/dn_dev.c
diff --git a/net/decnet/dn_fib.c b/drivers/staging/decnet/dn_fib.c
similarity index 100%
rename from net/decnet/dn_fib.c
rename to drivers/staging/decnet/dn_fib.c
diff --git a/net/decnet/dn_neigh.c b/drivers/staging/decnet/dn_neigh.c
similarity index 100%
rename from net/decnet/dn_neigh.c
rename to drivers/staging/decnet/dn_neigh.c
diff --git a/net/decnet/dn_nsp_in.c b/drivers/staging/decnet/dn_nsp_in.c
similarity index 100%
rename from net/decnet/dn_nsp_in.c
rename to drivers/staging/decnet/dn_nsp_in.c
diff --git a/net/decnet/dn_nsp_out.c b/drivers/staging/decnet/dn_nsp_out.c
similarity index 100%
rename from net/decnet/dn_nsp_out.c
rename to drivers/staging/decnet/dn_nsp_out.c
diff --git a/net/decnet/dn_route.c b/drivers/staging/decnet/dn_route.c
similarity index 100%
rename from net/decnet/dn_route.c
rename to drivers/staging/decnet/dn_route.c
diff --git a/net/decnet/dn_rules.c b/drivers/staging/decnet/dn_rules.c
similarity index 100%
rename from net/decnet/dn_rules.c
rename to drivers/staging/decnet/dn_rules.c
diff --git a/net/decnet/dn_table.c b/drivers/staging/decnet/dn_table.c
similarity index 100%
rename from net/decnet/dn_table.c
rename to drivers/staging/decnet/dn_table.c
diff --git a/net/decnet/dn_timer.c b/drivers/staging/decnet/dn_timer.c
similarity index 100%
rename from net/decnet/dn_timer.c
rename to drivers/staging/decnet/dn_timer.c
diff --git a/include/net/dn.h b/drivers/staging/decnet/include/net/dn.h
similarity index 100%
rename from include/net/dn.h
rename to drivers/staging/decnet/include/net/dn.h
diff --git a/net/decnet/netfilter/Kconfig b/drivers/staging/decnet/netfilter/Kconfig
similarity index 100%
rename from net/decnet/netfilter/Kconfig
rename to drivers/staging/decnet/netfilter/Kconfig
diff --git a/net/decnet/netfilter/Makefile b/drivers/staging/decnet/netfilter/Makefile
similarity index 62%
rename from net/decnet/netfilter/Makefile
rename to drivers/staging/decnet/netfilter/Makefile
index 255c1ae9daeb..d3478f8b29d8 100644
--- a/net/decnet/netfilter/Makefile
+++ b/drivers/staging/decnet/netfilter/Makefile
@@ -2,5 +2,6 @@
 # Makefile for DECnet netfilter modules
 #
 
-obj-$(CONFIG_DECNET_NF_GRABULATOR) += dn_rtmsg.o
+ccflags-y := -I$(srctree)/drivers/staging/decnet/include
 
+obj-$(CONFIG_DECNET_NF_GRABULATOR) += dn_rtmsg.o
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/drivers/staging/decnet/netfilter/dn_rtmsg.c
similarity index 100%
rename from net/decnet/netfilter/dn_rtmsg.c
rename to drivers/staging/decnet/netfilter/dn_rtmsg.c
diff --git a/net/decnet/sysctl_net_decnet.c b/drivers/staging/decnet/sysctl_net_decnet.c
similarity index 100%
rename from net/decnet/sysctl_net_decnet.c
rename to drivers/staging/decnet/sysctl_net_decnet.c
diff --git a/net/Kconfig b/net/Kconfig
index 9dba2715919d..38c873f20d5a 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -195,7 +195,6 @@ config BRIDGE_NETFILTER
 source "net/netfilter/Kconfig"
 source "net/ipv4/netfilter/Kconfig"
 source "net/ipv6/netfilter/Kconfig"
-source "net/decnet/netfilter/Kconfig"
 source "net/bridge/netfilter/Kconfig"
 
 endif
@@ -210,7 +209,6 @@ source "net/802/Kconfig"
 source "net/bridge/Kconfig"
 source "net/dsa/Kconfig"
 source "net/8021q/Kconfig"
-source "net/decnet/Kconfig"
 source "net/llc/Kconfig"
 source "net/ipx/Kconfig"
 source "drivers/net/appletalk/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 14fede520840..20b27479c907 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -39,7 +39,6 @@ obj-$(CONFIG_AF_KCM)		+= kcm/
 obj-$(CONFIG_STREAM_PARSER)	+= strparser/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_L2TP)		+= l2tp/
-obj-$(CONFIG_DECNET)		+= decnet/
 obj-$(CONFIG_PHONET)		+= phonet/
 ifneq ($(CONFIG_VLAN_8021Q),)
 obj-y				+= 8021q/
diff --git a/net/decnet/TODO b/net/decnet/TODO
deleted file mode 100644
index ebb5ac69d128..000000000000
--- a/net/decnet/TODO
+++ /dev/null
@@ -1,41 +0,0 @@
-Steve's quick list of things that need finishing off:
-[they are in no particular order and range from the trivial to the long winded]
-
- o Proper timeouts on each neighbour (in routing mode) rather than
-   just the 60 second On-Ethernet cache value.
-
- o Support for X.25 linklayer
-
- o Support for DDCMP link layer
-
- o The DDCMP device itself
-
- o PPP support (rfc1762)
-
- o Lots of testing with real applications
-
- o Verify errors etc. against POSIX 1003.1g (draft)
-
- o Using send/recvmsg() to get at connect/disconnect data (POSIX 1003.1g) 
-   [maybe this should be done at socket level... the control data in the
-    send/recvmsg() calls should simply be a vector of set/getsockopt()
-    calls]
-
- o check MSG_CTRUNC is set where it should be.
-
- o Find all the commonality between DECnet and IPv4 routing code and extract 
-   it into a small library of routines. [probably a project for 2.7.xx]
-
- o Add perfect socket hashing - an idea suggested by Paul Koning. Currently
-   we have a half-way house scheme which seems to work reasonably well, but
-   the full scheme is still worth implementing, its not not top of my list
-   right now.
-
- o Add session control message flow control
-
- o Add NSP message flow control
-
- o DECnet sendpages() function
-
- o AIO for DECnet
-
-- 
2.11.0
