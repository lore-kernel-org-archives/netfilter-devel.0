From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 3/3] new status flag SEEN_RELATED
Date: Thu, 22 May 2008 10:13:29 +0100
Message-ID: <1211447609.6878.39.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761298AbYEVJNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 05:13:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=EF=BB=BFIf a connection attempt fails with an ICMP unreachable message=
, I have=20
to know that it has seen related packets. ICMP errors don't get their=20
own conntrack and setting SEEN_REPLY would be bad, as it is used for=20
other purposes.

This patch introduces a new status flag SEEN_RELATED. It is set for the=
=20
master conntrack if an ICMP error or another related packet is seen.

--- linux-2.6.25.4.orig/include/linux/netfilter/nf_conntrack_common.h	2=
008-05-20 21:05:41.000000000 +0100
+++ linux-2.6.25.4/include/linux/netfilter/nf_conntrack_common.h	2008-0=
5-21 14:01:59.000000000 +0100
@@ -73,6 +73,10 @@
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT =3D 10,
 	IPS_FIXED_TIMEOUT =3D (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Master connection has seen a related packet */
+	IPS_SEEN_RELATED_BIT =3D 11,
+	IPS_SEEN_RELATED =3D (1 << IPS_SEEN_RELATED_BIT),
 };
=20
 /* Connection tracking event bits */
--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_core.c	2008-05-20 21=
:05:06.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_core.c	2008-05-21 14:12:4=
2.000000000 +0100
@@ -619,6 +619,7 @@
 		  struct nf_conntrack_l3proto *l3proto,
 		  struct nf_conntrack_l4proto *l4proto,
 		  int *set_reply,
+		  int *set_related,
 		  enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conntrack_tuple tuple;
@@ -657,6 +658,8 @@
 			pr_debug("nf_conntrack_in: related packet for %p\n",
 				 ct);
 			*ctinfo =3D IP_CT_RELATED;
+			/* Please set related bit of master if this packet OK */
+			*set_related =3D 1;
 		} else {
 			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
 			*ctinfo =3D IP_CT_NEW;
@@ -678,6 +681,7 @@
 	unsigned int dataoff;
 	u_int8_t protonum;
 	int set_reply =3D 0;
+	int set_related =3D 0;
 	int ret;
=20
 	/* Previously seen (loopback or untracked)?  Ignore. */
@@ -710,7 +714,7 @@
 	}
=20
 	ct =3D resolve_normal_ct(skb, dataoff, pf, protonum, l3proto, l4proto=
,
-			       &set_reply, &ctinfo);
+			       &set_reply, &set_related, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
 		NF_CT_STAT_INC_ATOMIC(invalid);
@@ -736,7 +740,9 @@
 		return -ret;
 	}
=20
-	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
+	if ((set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
+				|| (set_related	&& !test_and_set_bit(
+						IPS_SEEN_RELATED_BIT, &ct->master->status)))
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
=20
 	return ret;
--- linux-2.6.25.4.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	20=
08-05-21 17:16:46.000000000 +0100
+++ linux-2.6.25.4/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2008-05=
-21 17:12:03.000000000 +0100
@@ -132,6 +132,7 @@
 	struct nf_conntrack_tuple innertuple, origtuple;
 	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
=20
 	NF_CT_ASSERT(skb->nfct =3D=3D NULL);
=20
@@ -163,6 +164,9 @@
 		return -NF_ACCEPT;
 	}
=20
+	ct =3D nf_ct_tuplehash_to_ctrack(h);
+	set_bit(IPS_SEEN_RELATED_BIT, &ct->status);
+
 	if (NF_CT_DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
 		*ctinfo +=3D IP_CT_IS_REPLY;
=20


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
