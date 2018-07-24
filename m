From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH PATCH net-next 01/18] sched: fix trailing whitespace
Date: Tue, 24 Jul 2018 12:29:01 -0700
Message-ID: <20180724192918.31165-2-sthemmin@microsoft.com>
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

Remove trailing whitespace and blank lines at EOF

Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
---
 net/sched/Kconfig        | 4 ++--
 net/sched/Makefile       | 2 +-
 net/sched/act_connmark.c | 1 -
 net/sched/act_pedit.c    | 1 -
 net/sched/cls_basic.c    | 1 -
 5 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 7af246764a35..bba71225adbd 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -1,6 +1,6 @@
 #
 # Traffic control configuration.
-# 
+#
 
 menuconfig NET_SCHED
 	bool "QoS and/or fair queueing"
@@ -706,7 +706,7 @@ config NET_CLS_ACT
 
 config NET_ACT_POLICE
 	tristate "Traffic Policing"
-        depends on NET_CLS_ACT 
+        depends on NET_CLS_ACT
         ---help---
 	  Say Y here if you want to do traffic policing, i.e. strict
 	  bandwidth limiting. This action replaces the existing policing
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 673ee7d26ff2..910ec7463a36 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
 obj-$(CONFIG_NET_SCH_HFSC)	+= sch_hfsc.o
 obj-$(CONFIG_NET_SCH_RED)	+= sch_red.o
 obj-$(CONFIG_NET_SCH_GRED)	+= sch_gred.o
-obj-$(CONFIG_NET_SCH_INGRESS)	+= sch_ingress.o 
+obj-$(CONFIG_NET_SCH_INGRESS)	+= sch_ingress.o
 obj-$(CONFIG_NET_SCH_DSMARK)	+= sch_dsmark.o
 obj-$(CONFIG_NET_SCH_SFB)	+= sch_sfb.o
 obj-$(CONFIG_NET_SCH_SFQ)	+= sch_sfq.o
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 1e31f0e448e2..2f9bc833d046 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -252,4 +252,3 @@ module_exit(connmark_cleanup_module);
 MODULE_AUTHOR("Felix Fietkau <nbd-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>");
 MODULE_DESCRIPTION("Connection tracking mark restoring");
 MODULE_LICENSE("GPL");
-
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cc8ffcd1ddb5..9ab5d81aff1a 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -516,4 +516,3 @@ static void __exit pedit_cleanup_module(void)
 
 module_init(pedit_init_module);
 module_exit(pedit_cleanup_module);
-
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 95367f37098d..6a5dce8baf19 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -324,4 +324,3 @@ static void __exit exit_basic(void)
 module_init(init_basic)
 module_exit(exit_basic)
 MODULE_LICENSE("GPL");
