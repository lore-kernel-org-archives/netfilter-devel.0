From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Re: [ULOGD RFC 08/30] NFCT: rework
Date: Sat, 2 Feb 2008 17:20:37 +0100
Message-ID: <20080202162037.GA16826@localhost>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.400747893@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:42693 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYBBQUp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:20:45 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=localhost)
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JLL6h-0007Hr-Hc
	for netfilter-devel@vger.kernel.org; Sat, 02 Feb 2008 17:20:44 +0100
Content-Disposition: inline
In-Reply-To: <20080130190127.400747893@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

You changelog is not complete as it did not mention important
modification of the output keys.

On Wednesday, 2008 January 30 at 19:58:55 +0100, heitzenberger@astaro.com w=
rote:
 =20
> -static struct ulogd_key nfct_okeys[] =3D {
> +enum {
> +	O_IP_SADDR =3D 0,
> +	O_IP_DADDR,
> +	O_IP_PROTO,
> +	O_L4_SPORT,
> +	O_L4_DPORT,
> +	O_RAW_IN_PKTLEN,
> +	O_RAW_IN_PKTCOUNT,
> +	O_RAW_OUT_PKTLEN,
> +	O_RAW_OUT_PKTCOUNT,

Accounting is done here for both side of connection ...

> -	rc =3D propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ctstamp);
> -	if (rc < 0)
> -		return rc;
> +		gettimeofday(&ts->time[STOP], NULL);
> +	=09
> +		propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ts);
> +	} while (0);
> =20
> -	return propagate_ct_flow(upi, ct, flags, NFCT_DIR_REPLY, ctstamp);

and you are now just sending one message per connection (suppression of
call to propagate_ct_flow in NFCT_DIR_REPLY way).

I'm totally agree with last part: Sending two messages per connection
(one per tuple) is IMO not correct but Harald may have some good explanatio=
n to
provide about this.

But your patch loose really important information as it keep only one
side of the connection. I understand that NFCT_DIR_ORIGINAL is the human
way of seing a connection but loosing information contained in NFCT_DIR_REP=
LY=20
is IMO an error.

I attached to this mail a patch to the NFCT plugin which do not loose
these informations.

I think you could get to your actual set of keys by using a filter in the s=
tack
which could suppress NFCT_DIR_REPLY information but IMO it can not be
considered as the general case.

Anyway, Holger thanks for this patchset.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/

--PEIAKu/WMn1b1Hv9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-Do-not-propagate-one-conntrack-event-via-2-messages.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 3ffd8ab5f0f2b50764e591d4edef95d9a8a88c84 Mon Sep 17 00:00:00 2001
=46rom: Eric leblond <eric@inl.fr>
Date: Fri, 11 Jan 2008 23:39:46 +0100
Subject: [PATCH] Do not propagate one conntrack event via 2 messages:
 * ulogd2 was propagating through a stack 2 message for one single
 conntrack event
 * Fall back to on message per event
 * Use an enum to improve code readability instead of direct access to
 array via numerical index

Signed-off-by: Eric leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |  236 ++++++++++++++++++++++++++++-------=
----
 1 files changed, 168 insertions(+), 68 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFC=
T.c
index d3cd20c..bf6587d 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -106,11 +106,101 @@ static struct config_keyset nfct_kset =3D {
 #define buckets_ce(x)	(x->ces[3])
 #define maxentries_ce(x) (x->ces[4])
=20
+enum nfct_keys {
+	NFCT_ORIG_IP_SADDR =3D 0,
+	NFCT_ORIG_IP_DADDR,
+	NFCT_ORIG_IP_PROTOCOL,
+	NFCT_ORIG_L4_SPORT,
+	NFCT_ORIG_L4_DPORT,
+	NFCT_ORIG_RAW_PKTLEN,
+	NFCT_ORIG_RAW_PKTCOUNT,
+	NFCT_REPLY_IP_SADDR,
+	NFCT_REPLY_IP_DADDR,
+	NFCT_REPLY_IP_PROTOCOL,
+	NFCT_REPLY_L4_SPORT,
+	NFCT_REPLY_L4_DPORT,
+	NFCT_REPLY_RAW_PKTLEN,
+	NFCT_REPLY_RAW_PKTCOUNT,
+	NFCT_ICMP_CODE,
+	NFCT_ICMP_TYPE,
+	NFCT_CT_MARK,
+	NFCT_CT_ID,
+	NFCT_FLOW_START_SEC,
+	NFCT_FLOW_START_USEC,
+	NFCT_FLOW_END_SEC,
+	NFCT_FLOW_END_USEC,
+};
+
 static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type 	=3D ULOGD_RET_IPADDR,
 		.flags 	=3D ULOGD_RETF_NONE,
-		.name	=3D "ip.saddr",
+		.name	=3D "orig.ip.saddr",
+		.ipfix	=3D {=20
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_sourceIPv4Address,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_IPADDR,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.ip.daddr",
+		.ipfix	=3D {
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_destinationIPv4Address,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT8,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.ip.protocol",
+		.ipfix	=3D {=20
+			.vendor =3D IPFIX_VENDOR_IETF,
+			.field_id =3D IPFIX_protocolIdentifier,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT16,
+		.flags 	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.l4.sport",
+		.ipfix	=3D {
+			.vendor 	=3D IPFIX_VENDOR_IETF,
+			.field_id 	=3D IPFIX_sourceTransportPort,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT16,
+		.flags 	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.l4.dport",
+		.ipfix	=3D {
+			.vendor 	=3D IPFIX_VENDOR_IETF,
+			.field_id 	=3D IPFIX_destinationTransportPort,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT32,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.raw.pktlen",
+		.ipfix	=3D {=20
+			.vendor 	=3D IPFIX_VENDOR_IETF,
+			.field_id 	=3D IPFIX_octetTotalCount,
+			/* FIXME: this could also be octetDeltaCount */
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT32,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "orig.raw.pktcount",
+		.ipfix	=3D {=20
+			.vendor 	=3D IPFIX_VENDOR_IETF,
+			.field_id 	=3D IPFIX_packetTotalCount,
+			/* FIXME: this could also be packetDeltaCount */
+		},
+	},
+	{
+		.type 	=3D ULOGD_RET_IPADDR,
+		.flags 	=3D ULOGD_RETF_NONE,
+		.name	=3D "reply.ip.saddr",
 		.ipfix	=3D {=20
 			.vendor =3D IPFIX_VENDOR_IETF,
 			.field_id =3D IPFIX_sourceIPv4Address,
@@ -119,7 +209,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_IPADDR,
 		.flags	=3D ULOGD_RETF_NONE,
-		.name	=3D "ip.daddr",
+		.name	=3D "reply.ip.daddr",
 		.ipfix	=3D {
 			.vendor =3D IPFIX_VENDOR_IETF,
 			.field_id =3D IPFIX_destinationIPv4Address,
@@ -128,7 +218,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_UINT8,
 		.flags	=3D ULOGD_RETF_NONE,
-		.name	=3D "ip.protocol",
+		.name	=3D "reply.ip.protocol",
 		.ipfix	=3D {=20
 			.vendor =3D IPFIX_VENDOR_IETF,
 			.field_id =3D IPFIX_protocolIdentifier,
@@ -137,7 +227,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_UINT16,
 		.flags 	=3D ULOGD_RETF_NONE,
-		.name	=3D "l4.sport",
+		.name	=3D "reply.l4.sport",
 		.ipfix	=3D {
 			.vendor 	=3D IPFIX_VENDOR_IETF,
 			.field_id 	=3D IPFIX_sourceTransportPort,
@@ -146,7 +236,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_UINT16,
 		.flags 	=3D ULOGD_RETF_NONE,
-		.name	=3D "l4.dport",
+		.name	=3D "reply.l4.dport",
 		.ipfix	=3D {
 			.vendor 	=3D IPFIX_VENDOR_IETF,
 			.field_id 	=3D IPFIX_destinationTransportPort,
@@ -155,7 +245,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_UINT32,
 		.flags	=3D ULOGD_RETF_NONE,
-		.name	=3D "raw.pktlen",
+		.name	=3D "reply.raw.pktlen",
 		.ipfix	=3D {=20
 			.vendor 	=3D IPFIX_VENDOR_IETF,
 			.field_id 	=3D IPFIX_octetTotalCount,
@@ -165,7 +255,7 @@ static struct ulogd_key nfct_okeys[] =3D {
 	{
 		.type	=3D ULOGD_RET_UINT32,
 		.flags	=3D ULOGD_RETF_NONE,
-		.name	=3D "raw.pktcount",
+		.name	=3D "reply.raw.pktcount",
 		.ipfix	=3D {=20
 			.vendor 	=3D IPFIX_VENDOR_IETF,
 			.field_id 	=3D IPFIX_packetTotalCount,
@@ -244,11 +334,6 @@ static struct ulogd_key nfct_okeys[] =3D {
 			.field_id	=3D IPFIX_flowEndSeconds,
 		},
 	},
-	{
-		.type =3D ULOGD_RET_BOOL,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "dir",
-	},
 };
=20
 static struct ct_htable *htable_alloc(int htable_size, int prealloc)
@@ -364,93 +449,108 @@ static struct ct_timestamp *ct_hash_get(struct ct_ht=
able *htable, uint32_t id)
 	return ct;
 }
=20
-static int propagate_ct_flow(struct ulogd_pluginstance *upi,=20
-		             struct nfct_conntrack *ct,
-			     unsigned int flags,
-			     int dir,
-			     struct ct_timestamp *ts)
+static int propagate_ct(struct ulogd_pluginstance *upi,
+			struct nfct_conntrack *ct,
+			unsigned int flags,
+			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret =3D upi->output.keys;
+	int dir;
+=09
+	dir =3D NFCT_DIR_ORIGINAL;
+	ret[NFCT_ORIG_IP_SADDR].u.value.ui32 =3D htonl(ct->tuple[dir].src.v4);
+	ret[NFCT_ORIG_IP_SADDR].flags |=3D ULOGD_RETF_VALID;
=20
-	ret[0].u.value.ui32 =3D htonl(ct->tuple[dir].src.v4);
-	ret[0].flags |=3D ULOGD_RETF_VALID;
-
-	ret[1].u.value.ui32 =3D htonl(ct->tuple[dir].dst.v4);
-	ret[1].flags |=3D ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_IP_DADDR].u.value.ui32 =3D htonl(ct->tuple[dir].dst.v4);
+	ret[NFCT_ORIG_IP_DADDR].flags |=3D ULOGD_RETF_VALID;
=20
-	ret[2].u.value.ui8 =3D ct->tuple[dir].protonum;
-	ret[2].flags |=3D ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 =3D ct->tuple[dir].protonum;
+	ret[NFCT_ORIG_IP_PROTOCOL].flags |=3D ULOGD_RETF_VALID;
=20
-	switch (ct->tuple[1].protonum) {
+	switch (ct->tuple[dir].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[3].u.value.ui16 =3D htons(ct->tuple[dir].l4src.tcp.port);
-		ret[3].flags |=3D ULOGD_RETF_VALID;
-		ret[4].u.value.ui16 =3D htons(ct->tuple[dir].l4dst.tcp.port);
-		ret[4].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 =3D htons(ct->tuple[dir].l4src.tcp.=
port);
+		ret[NFCT_ORIG_L4_SPORT].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 =3D htons(ct->tuple[dir].l4dst.tcp.=
port);
+		ret[NFCT_ORIG_L4_DPORT].flags |=3D ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[7].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.code;
-		ret[7].flags |=3D ULOGD_RETF_VALID;
-		ret[8].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.type;
-		ret[8].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_CODE].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.code;
+		ret[NFCT_ICMP_CODE].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_TYPE].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.type;
+		ret[NFCT_ICMP_TYPE].flags |=3D ULOGD_RETF_VALID;
 		break;
 	}
=20
-	if ((dir =3D=3D NFCT_DIR_ORIGINAL && flags & NFCT_COUNTERS_ORIG) ||
-	    (dir =3D=3D NFCT_DIR_REPLY && flags & NFCT_COUNTERS_RPLY)) {
-		ret[5].u.value.ui64 =3D ct->counters[dir].bytes;
-		ret[5].flags |=3D ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui64 =3D ct->counters[dir].bytes;
+	ret[NFCT_ORIG_RAW_PKTLEN].flags |=3D ULOGD_RETF_VALID;
+
+	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui64 =3D ct->counters[dir].packets;
+	ret[NFCT_ORIG_RAW_PKTCOUNT].flags |=3D ULOGD_RETF_VALID;
+
+	dir =3D NFCT_DIR_REPLY;
+	ret[NFCT_REPLY_IP_SADDR].u.value.ui32 =3D htonl(ct->tuple[dir].src.v4);
+	ret[NFCT_REPLY_IP_SADDR].flags |=3D ULOGD_RETF_VALID;
=20
-		ret[6].u.value.ui64 =3D ct->counters[dir].packets;
-		ret[6].flags |=3D ULOGD_RETF_VALID;
+	ret[NFCT_REPLY_IP_DADDR].u.value.ui32 =3D htonl(ct->tuple[dir].dst.v4);
+	ret[NFCT_REPLY_IP_DADDR].flags |=3D ULOGD_RETF_VALID;
+
+	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 =3D ct->tuple[dir].protonum;
+	ret[NFCT_REPLY_IP_PROTOCOL].flags |=3D ULOGD_RETF_VALID;
+
+	switch (ct->tuple[dir].protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		/* FIXME: DCCP */
+		ret[NFCT_REPLY_L4_SPORT].u.value.ui16 =3D htons(ct->tuple[dir].l4src.tcp=
=2Eport);
+		ret[NFCT_REPLY_L4_SPORT].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_REPLY_L4_DPORT].u.value.ui16 =3D htons(ct->tuple[dir].l4dst.tcp=
=2Eport);
+		ret[NFCT_REPLY_L4_DPORT].flags |=3D ULOGD_RETF_VALID;
+		break;
+	case IPPROTO_ICMP:
+		ret[NFCT_ICMP_CODE].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.code;
+		ret[NFCT_ICMP_CODE].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_TYPE].u.value.ui8 =3D ct->tuple[dir].l4src.icmp.type;
+		ret[NFCT_ICMP_TYPE].flags |=3D ULOGD_RETF_VALID;
+		break;
 	}
=20
+	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui64 =3D ct->counters[dir].bytes;
+	ret[NFCT_REPLY_RAW_PKTLEN].flags |=3D ULOGD_RETF_VALID;
+
+	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui64 =3D ct->counters[dir].packets;
+	ret[NFCT_REPLY_RAW_PKTCOUNT].flags |=3D ULOGD_RETF_VALID;
+
 	if (flags & NFCT_MARK) {
-		ret[9].u.value.ui32 =3D ct->mark;
-		ret[9].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_CT_MARK].u.value.ui32 =3D ct->mark;
+		ret[NFCT_CT_MARK].flags |=3D ULOGD_RETF_VALID;
 	}
=20
 	if (flags & NFCT_ID) {
-		ret[10].u.value.ui32 =3D ct->id;
-		ret[10].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_CT_ID].u.value.ui32 =3D ct->id;
+		ret[NFCT_CT_ID].flags |=3D ULOGD_RETF_VALID;
 	}
=20
 	if (ts) {
-		ret[11].u.value.ui32 =3D ts->time[START].tv_sec;
-		ret[11].flags |=3D ULOGD_RETF_VALID;
-		ret[12].u.value.ui32 =3D ts->time[START].tv_usec;
-		ret[12].flags |=3D ULOGD_RETF_VALID;
-		ret[13].u.value.ui32 =3D ts->time[STOP].tv_sec;
-		ret[13].flags |=3D ULOGD_RETF_VALID;
-		ret[14].u.value.ui32 =3D ts->time[STOP].tv_usec;
-		ret[14].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_START_SEC].u.value.ui32 =3D ts->time[START].tv_sec;
+		ret[NFCT_FLOW_START_SEC].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_START_USEC].u.value.ui32 =3D ts->time[START].tv_usec;
+		ret[NFCT_FLOW_START_USEC].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_END_SEC].u.value.ui32 =3D ts->time[STOP].tv_sec;
+		ret[NFCT_FLOW_END_SEC].flags |=3D ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_END_USEC].u.value.ui32 =3D ts->time[STOP].tv_usec;
+		ret[NFCT_FLOW_END_USEC].flags |=3D ULOGD_RETF_VALID;
 	}
=20
-	ret[15].u.value.b =3D (dir =3D=3D NFCT_DIR_ORIGINAL) ? 0 : 1;
-	ret[15].flags |=3D ULOGD_RETF_VALID;
-
 	ulogd_propagate_results(upi);
=20
 	return 0;
 }
=20
-static int propagate_ct(struct ulogd_pluginstance *upi,
-			struct nfct_conntrack *ct,
-			unsigned int flags,
-			struct ct_timestamp *ctstamp)
-{
-	int rc;
-
-	rc =3D propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ctstamp);
-	if (rc < 0)
-		return rc;
-
-	return propagate_ct_flow(upi, ct, flags, NFCT_DIR_REPLY, ctstamp);
-}
-
 static int event_handler(void *arg, unsigned int flags, int type,
 			 void *data)
 {
--=20
1.5.2.5


--PEIAKu/WMn1b1Hv9--

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHpJhVnxA7CdMWjzIRAqODAJ9mX1hLZf/oaMejVJDTwBEOTy0/vACfY1OT
j3kF990nuBqCqEeOKSkFuXw=
=LUTD
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
