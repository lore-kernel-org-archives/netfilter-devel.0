From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH PATCH net-next 05/18] mpls: remove trailing whitepace
Date: Tue, 24 Jul 2018 12:29:05 -0700
Message-ID: <20180724192918.31165-6-sthemmin@microsoft.com>
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
 net/mpls/mpls_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 6e558a419f60..94f53a9b7d1a 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -224,7 +224,7 @@ static int mpls_fill_encap_info(struct sk_buff *skb,
 				struct lwtunnel_state *lwtstate)
 {
 	struct mpls_iptunnel_encap *tun_encap_info;
-	
+
 	tun_encap_info = mpls_lwtunnel_encap(lwtstate);
 
 	if (nla_put_labels(skb, MPLS_IPTUNNEL_DST, tun_encap_info->labels,
-- 
2.18.0
