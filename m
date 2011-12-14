From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 14:45:20 +0100
Message-ID: <1323870320.2334.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
	 <1323861408.2334.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111214124122.GA2749@1984>
	 <1323868723.2334.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNNpY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:45:24 -0500
Received: by wgbdr13 with SMTP id dr13so1847241wgb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:45:23 -0800 (PST)
In-Reply-To: <1323868723.2334.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 14 d=C3=A9cembre 2011 =C3=A0 14:18 +0100, Eric Dumazet a =C3=
=A9crit :
> Le mercredi 14 d=C3=A9cembre 2011 =C3=A0 13:41 +0100, Pablo Neira Ayu=
so a =C3=A9crit :
>=20
> > Not related to this, but we can also replace this in the connection
> > tracking system.
>=20
> Very good point indeed ;)
>=20
>=20

[PATCH] conntrack: use atomic64 for acct counters

We can use atomic64_t infrastructure to avoid taking a spinlock in fast
path, and remove inaccuracies while reading values in
ctnetlink_dump_counters() and connbytes_mt() on 32bit arches.

Suggested by Pablo

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/netfilter/nf_conntrack_acct.h |    4 +-
 net/netfilter/nf_conntrack_acct.c         |    4 +-
 net/netfilter/nf_conntrack_core.c         |   14 +++-----
 net/netfilter/nf_conntrack_netlink.c      |   12 +++++--
 net/netfilter/xt_connbytes.c              |   32 ++++++++++----------
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/ne=
tfilter/nf_conntrack_acct.h
index 4e9c63a..463ae8e 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -15,8 +15,8 @@
 #include <net/netfilter/nf_conntrack_extend.h>
=20
 struct nf_conn_counter {
-	u_int64_t packets;
-	u_int64_t bytes;
+	atomic64_t packets;
+	atomic64_t bytes;
 };
=20
 static inline
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_connt=
rack_acct.c
index 369df3f..9332906 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -46,8 +46,8 @@ seq_print_acct(struct seq_file *s, const struct nf_co=
nn *ct, int dir)
 		return 0;
=20
 	return seq_printf(s, "packets=3D%llu bytes=3D%llu ",
-			  (unsigned long long)acct[dir].packets,
-			  (unsigned long long)acct[dir].bytes);
+			  (unsigned long long)atomic64_read(&acct[dir].packets),
+			  (unsigned long long)atomic64_read(&acct[dir].bytes));
 };
 EXPORT_SYMBOL_GPL(seq_print_acct);
=20
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_connt=
rack_core.c
index 7202b06..8b2842e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1044,10 +1044,8 @@ acct:
=20
 		acct =3D nf_conn_acct_find(ct);
 		if (acct) {
-			spin_lock_bh(&ct->lock);
-			acct[CTINFO2DIR(ctinfo)].packets++;
-			acct[CTINFO2DIR(ctinfo)].bytes +=3D skb->len;
-			spin_unlock_bh(&ct->lock);
+			atomic64_inc(&acct[CTINFO2DIR(ctinfo)].packets);
+			atomic64_add(skb->len, &acct[CTINFO2DIR(ctinfo)].bytes);
 		}
 	}
 }
@@ -1063,11 +1061,9 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
=20
 		acct =3D nf_conn_acct_find(ct);
 		if (acct) {
-			spin_lock_bh(&ct->lock);
-			acct[CTINFO2DIR(ctinfo)].packets++;
-			acct[CTINFO2DIR(ctinfo)].bytes +=3D
-				skb->len - skb_network_offset(skb);
-			spin_unlock_bh(&ct->lock);
+			atomic64_inc(&acct[CTINFO2DIR(ctinfo)].packets);
+			atomic64_add(skb->len - skb_network_offset(skb),
+				     &acct[CTINFO2DIR(ctinfo)].bytes);
 		}
 	}
=20
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_co=
nntrack_netlink.c
index ef21b22..a36e655 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -219,9 +219,9 @@ ctnetlink_dump_counters(struct sk_buff *skb, const =
struct nf_conn *ct,
 		goto nla_put_failure;
=20
 	NLA_PUT_BE64(skb, CTA_COUNTERS_PACKETS,
-		     cpu_to_be64(acct[dir].packets));
+		     cpu_to_be64(atomic64_read(&acct[dir].packets)));
 	NLA_PUT_BE64(skb, CTA_COUNTERS_BYTES,
-		     cpu_to_be64(acct[dir].bytes));
+		     cpu_to_be64(atomic64_read(&acct[dir].bytes)));
=20
 	nla_nest_end(skb, nest_count);
=20
@@ -720,8 +720,12 @@ restart:
 				struct nf_conn_counter *acct;
=20
 				acct =3D nf_conn_acct_find(ct);
-				if (acct)
-					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
+				if (acct) {
+					atomic64_set(&acct[IP_CT_DIR_ORIGINAL].bytes, 0);
+					atomic64_set(&acct[IP_CT_DIR_ORIGINAL].packets, 0);
+					atomic64_set(&acct[IP_CT_DIR_REPLY].bytes, 0);
+					atomic64_set(&acct[IP_CT_DIR_REPLY].packets, 0);
+					}
 			}
 		}
 		if (cb->args[1]) {
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.=
c
index 5b13850..2b8418c 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -40,46 +40,46 @@ connbytes_mt(const struct sk_buff *skb, struct xt_a=
ction_param *par)
 	case XT_CONNBYTES_PKTS:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what =3D counters[IP_CT_DIR_ORIGINAL].packets;
+			what =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].packets);
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what =3D counters[IP_CT_DIR_REPLY].packets;
+			what =3D atomic64_read(&counters[IP_CT_DIR_REPLY].packets);
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			what =3D counters[IP_CT_DIR_ORIGINAL].packets;
-			what +=3D counters[IP_CT_DIR_REPLY].packets;
+			what =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].packets);
+			what +=3D atomic64_read(&counters[IP_CT_DIR_REPLY].packets);
 			break;
 		}
 		break;
 	case XT_CONNBYTES_BYTES:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what =3D counters[IP_CT_DIR_ORIGINAL].bytes;
+			what =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].bytes);
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what =3D counters[IP_CT_DIR_REPLY].bytes;
+			what =3D atomic64_read(&counters[IP_CT_DIR_REPLY].bytes);
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			what =3D counters[IP_CT_DIR_ORIGINAL].bytes;
-			what +=3D counters[IP_CT_DIR_REPLY].bytes;
+			what =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].bytes);
+			what +=3D atomic64_read(&counters[IP_CT_DIR_REPLY].bytes);
 			break;
 		}
 		break;
 	case XT_CONNBYTES_AVGPKT:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			bytes =3D counters[IP_CT_DIR_ORIGINAL].bytes;
-			pkts  =3D counters[IP_CT_DIR_ORIGINAL].packets;
+			bytes =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].bytes);
+			pkts  =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].packets);
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			bytes =3D counters[IP_CT_DIR_REPLY].bytes;
-			pkts  =3D counters[IP_CT_DIR_REPLY].packets;
+			bytes =3D atomic64_read(&counters[IP_CT_DIR_REPLY].bytes);
+			pkts  =3D atomic64_read(&counters[IP_CT_DIR_REPLY].packets);
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			bytes =3D counters[IP_CT_DIR_ORIGINAL].bytes +
-				counters[IP_CT_DIR_REPLY].bytes;
-			pkts  =3D counters[IP_CT_DIR_ORIGINAL].packets +
-				counters[IP_CT_DIR_REPLY].packets;
+			bytes =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].bytes) +
+				atomic64_read(&counters[IP_CT_DIR_REPLY].bytes);
+			pkts  =3D atomic64_read(&counters[IP_CT_DIR_ORIGINAL].packets) +
+				atomic64_read(&counters[IP_CT_DIR_REPLY].packets);
 			break;
 		}
 		if (pkts !=3D 0)


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
