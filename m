From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH PATCH net-next 18/18] net: remove blank lines at end of file
Date: Tue, 24 Jul 2018 12:29:18 -0700
Message-ID: <20180724192918.31165-19-sthemmin@microsoft.com>
References: <20180724192918.31165-1-sthemmin@microsoft.com>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-hams-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-decnet-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org,
        linux-wpan-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-x25-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org,
        lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, jreuter-K7Hl1MveuGQ@public.gmane.org,
        pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org,
        alex.aring-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stefan-OrPQZGeq07wqhVmZOOOmNx2eb7JE58TQ@public.gmane.org,
        kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org,
        johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org,
        xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
        steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180724192918.31165-1-sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Several files have extra line at end of file.

Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
---
 net/8021q/Makefile              | 1 -
 net/Kconfig                     | 2 +-
 net/core/neighbour.c            | 1 -
 net/dns_resolver/dns_key.c      | 1 -
 net/ieee802154/core.c           | 1 -
 net/ieee802154/nl_policy.c      | 1 -
 net/ipv4/Kconfig                | 4 ++--
 net/ipv4/Makefile               | 2 +-
 net/ipv6/Kconfig                | 2 +-
 net/iucv/af_iucv.c              | 1 -
 net/kcm/Kconfig                 | 1 -
 net/kcm/kcmsock.c               | 1 -
 net/mac80211/rc80211_minstrel.c | 1 -
 13 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/8021q/Makefile b/net/8021q/Makefile
index 9b703454b93e..e05d4d7aab35 100644
--- a/net/8021q/Makefile
+++ b/net/8021q/Makefile
@@ -9,4 +9,3 @@ obj-$(CONFIG_VLAN_8021Q)		+= 8021q.o
 8021q-$(CONFIG_VLAN_8021Q_GVRP)		+= vlan_gvrp.o
 8021q-$(CONFIG_VLAN_8021Q_MVRP)		+= vlan_mvrp.o
 8021q-$(CONFIG_PROC_FS)			+= vlanproc.o
-
diff --git a/net/Kconfig b/net/Kconfig
index f738a6f27665..228dfa382eec 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -12,7 +12,7 @@ menuconfig NET
 	  The reason is that some programs need kernel networking support even
 	  when running on a stand-alone machine that isn't connected to any
 	  other computer.
-	  
+
 	  If you are upgrading from an older kernel, you
 	  should consider updating your networking tools too because changes
 	  in the kernel and the tools often go hand in hand. The tools are
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index cbe85d8d4cc2..aa19d86937af 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3274,4 +3274,3 @@ static int __init neigh_init(void)
 }
 
 subsys_initcall(neigh_init);
-
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 0c9478b91fa5..7f4534828f6c 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -320,4 +320,3 @@ static void __exit exit_dns_resolver(void)
 module_init(init_dns_resolver)
 module_exit(exit_dns_resolver)
 MODULE_LICENSE("GPL");
-
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index cb7176cd4cd6..fe225d9a1877 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -400,4 +400,3 @@ module_exit(wpan_phy_class_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("IEEE 802.15.4 configuration interface");
 MODULE_AUTHOR("Dmitry Eremin-Solenikov");
-
diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
index 35c432668454..78f6f1233194 100644
--- a/net/ieee802154/nl_policy.c
+++ b/net/ieee802154/nl_policy.c
@@ -75,4 +75,3 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
 	[IEEE802154_ATTR_LLSEC_DEV_OVERRIDE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_LLSEC_DEV_KEY_MODE] = { .type = NLA_U8, },
 };
-
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 80dad301361d..32cae39cdff6 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -430,7 +430,7 @@ config INET_DIAG
 	  Support for INET (TCP, DCCP, etc) socket monitoring interface used by
 	  native Linux tools such as ss. ss is included in iproute2, currently
 	  downloadable at:
-	  
+
 	    http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2
 
 	  If unsure, say Y.
@@ -600,7 +600,7 @@ config TCP_CONG_VENO
 	distinguishing to circumvent the difficult judgment of the packet loss
 	type. TCP Veno cuts down less congestion window in response to random
 	loss packets.
-	See <http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=1177186> 
+	See <http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=1177186>
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index eec9569ffa5c..7446b98661d8 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_INET_XFRM_MODE_TRANSPORT) += xfrm4_mode_transport.o
 obj-$(CONFIG_INET_XFRM_MODE_TUNNEL) += xfrm4_mode_tunnel.o
 obj-$(CONFIG_IP_PNP) += ipconfig.o
 obj-$(CONFIG_NETFILTER)	+= netfilter.o netfilter/
-obj-$(CONFIG_INET_DIAG) += inet_diag.o 
+obj-$(CONFIG_INET_DIAG) += inet_diag.o
 obj-$(CONFIG_INET_TCP_DIAG) += tcp_diag.o
 obj-$(CONFIG_INET_UDP_DIAG) += udp_diag.o
 obj-$(CONFIG_INET_RAW_DIAG) += raw_diag.o
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index b3885ca22d6f..613282c65a10 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -15,7 +15,7 @@ menuconfig IPV6
 	  Documentation/networking/ipv6.txt and read the HOWTO at
 	  <http://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/>
 
-	  To compile this protocol support as a module, choose M here: the 
+	  To compile this protocol support as a module, choose M here: the
 	  module will be called ipv6.
 
 if IPV6
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 893a022f9620..8d1c43f8fed4 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2515,4 +2515,3 @@ MODULE_DESCRIPTION("IUCV Sockets ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_IUCV);
-
diff --git a/net/kcm/Kconfig b/net/kcm/Kconfig
index 87fca36e6c47..9ca83f2ade6f 100644
--- a/net/kcm/Kconfig
+++ b/net/kcm/Kconfig
@@ -8,4 +8,3 @@ config AF_KCM
 	  KCM (Kernel Connection Multiplexor) sockets provide a method
 	  for multiplexing messages of a message based application
 	  protocol over kernel connectons (e.g. TCP connections).
-
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index d3601d421571..571d824e4e24 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -2104,4 +2104,3 @@ module_exit(kcm_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_KCM);
-
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 76048b53c5b2..07fb219327d6 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -751,4 +751,3 @@ rc80211_minstrel_exit(void)
 {
 	ieee80211_rate_control_unregister(&mac80211_minstrel);
 }
