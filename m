From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH PATCH net-next 12/18] ax25: remove blank line at EOF
Date: Tue, 24 Jul 2018 12:29:12 -0700
Message-ID: <20180724192918.31165-13-sthemmin@microsoft.com>
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

Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
---
 net/ax25/ax25_addr.c    | 1 -
 net/ax25/ax25_ds_in.c   | 1 -
 net/ax25/ax25_ds_subr.c | 1 -
 net/ax25/ax25_ip.c      | 1 -
 net/ax25/ax25_out.c     | 1 -
 5 files changed, 5 deletions(-)

diff --git a/net/ax25/ax25_addr.c b/net/ax25/ax25_addr.c
index ac2542b7be88..a14cfa736b63 100644
--- a/net/ax25/ax25_addr.c
+++ b/net/ax25/ax25_addr.c
@@ -304,4 +304,3 @@ void ax25_digi_invert(const ax25_digi *in, ax25_digi *out)
 		}
 	}
 }
-
diff --git a/net/ax25/ax25_ds_in.c b/net/ax25/ax25_ds_in.c
index 891596e74278..488fc2d7085a 100644
--- a/net/ax25/ax25_ds_in.c
+++ b/net/ax25/ax25_ds_in.c
@@ -299,4 +299,3 @@ int ax25_ds_frame_in(ax25_cb *ax25, struct sk_buff *skb, int type)
 
 	return queued;
 }
-
diff --git a/net/ax25/ax25_ds_subr.c b/net/ax25/ax25_ds_subr.c
index 28827e81ba2b..bc0329f43013 100644
--- a/net/ax25/ax25_ds_subr.c
+++ b/net/ax25/ax25_ds_subr.c
@@ -205,4 +205,3 @@ void ax25_dama_off(ax25_cb *ax25)
 	ax25->condition &= ~AX25_COND_DAMA_MODE;
 	ax25_dev_dama_off(ax25->ax25_dev);
 }
-
diff --git a/net/ax25/ax25_ip.c b/net/ax25/ax25_ip.c
index 183b1c583d56..70417e9b932d 100644
--- a/net/ax25/ax25_ip.c
+++ b/net/ax25/ax25_ip.c
@@ -249,4 +249,3 @@ const struct header_ops ax25_header_ops = {
 
 EXPORT_SYMBOL(ax25_header_ops);
 EXPORT_SYMBOL(ax25_ip_xmit);
-
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index b11a5f466fcc..3e5afc8dc93e 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -394,4 +394,3 @@ int ax25_check_iframes_acked(ax25_cb *ax25, unsigned short nr)
 	}
 	return 0;
 }
