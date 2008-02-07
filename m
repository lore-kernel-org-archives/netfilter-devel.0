From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/3] Do not set oob.family in config as it can be found in packet.
Date: Thu,  7 Feb 2008 09:22:19 +0100
Message-ID: <1202372541106-git-send-email-eric@inl.fr>
References: <12023725412-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43541 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754432AbYBGIWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:22:23 -0500
In-Reply-To: <12023725412-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

WHen using NFLOG or ULOG, obb.family (protocol IPv4 or IPv6) has
to be setup manually in ulogd.conf configuration file. This was
used to have the BASE filter parse accordingly the packet. This
patch suppress oob.family as output keys of NFLOG and ULOG and let
the BASE filter determine the family of the packet by itself (by
parsing the raw header).

A good side effect is to be able to log in IPv6 and IPv4 in the
same group. Before that, two loggers have to be setup separatly.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 48f2993... 62a9a87... M	filter/raw2packet/ulogd_raw2packet_BASE.c
:100644 100644 be46fa2... a85ff44... M	input/packet/ulogd_inppkt_NFLOG.c
:100644 100644 cf44474... 77087a4... M	input/packet/ulogd_inppkt_ULOG.c
 filter/raw2packet/ulogd_raw2packet_BASE.c |   32 ++++++++++++++++++++--------
 input/packet/ulogd_inppkt_NFLOG.c         |   15 -------------
 input/packet/ulogd_inppkt_ULOG.c          |    9 --------
 3 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 48f2993..62a9a87 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -44,6 +44,7 @@
 #include <ulogd/ipfix_protocol.h>
 
 enum output_keys {
+	KEY_OOB_FAMILY,
 	KEY_IP_SADDR,
 	KEY_IP_DADDR,
 	KEY_IP_PROTOCOL,
@@ -98,6 +99,11 @@ enum output_keys {
 };
 
 static struct ulogd_key iphdr_rets[] = {
+	[KEY_OOB_FAMILY] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE, 
+		.name = "oob.family",
+	},
 	[KEY_IP_SADDR] = { 
 		.type = ULOGD_RET_IPADDR,
 		.flags = ULOGD_RETF_NONE, 
@@ -819,15 +825,27 @@ out:
 
 static int _interp_pkt(struct ulogd_pluginstance *pi)
 {
+	struct ulogd_key *ret = pi->output.keys;
+	struct iphdr *iph = pi->input.keys[0].u.source->u.value.ptr;
 	u_int32_t len = pi->input.keys[1].u.source->u.value.ui32;
 	u_int8_t family = pi->input.keys[2].u.source->u.value.ui8;
 
-	switch (family) {
-	case AF_INET:
-		return _interp_iphdr(pi, len);
-	case AF_INET6:
-		return _interp_ipv6hdr(pi, len);
+	switch (iph->version) {
+		case 4:
+			ret[KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
+			ret[KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
+
+			return _interp_iphdr(pi, len);
+		case 6:
+			ret[KEY_OOB_FAMILY].u.value.ui8 = AF_INET6;
+			ret[KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
+
+			return _interp_ipv6hdr(pi, len);
+		default:
+			/* unknown protocol */
+			return 0;
 	}
+
 	return 0;
 }
 
@@ -847,10 +865,6 @@ static struct ulogd_key base_inp[] = {
 			.vendor = IPFIX_VENDOR_NETFILTER, 
 			.field_id = IPFIX_NF_rawpacket_length,
 		},
-	},
-	{
-		.type = ULOGD_RET_UINT8,
-		.name = "oob.family",
 	}
 };
 
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index be46fa2..a85ff44 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -55,12 +55,6 @@ static struct config_keyset libulog_kset = {
 			.u.value = NFLOG_RMEM_DEFAULT,
 		},
 		{
-			.key 	 = "addressfamily",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = AF_INET,
-		},
-		{
 			.key	 = "unbind",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
@@ -104,7 +98,6 @@ enum nflog_keys {
 	NFLOG_KEY_RAW_MAC_LEN,
 	NFLOG_KEY_OOB_SEQ_LOCAL,
 	NFLOG_KEY_OOB_SEQ_GLOBAL,
-	NFLOG_KEY_OOB_FAMILY,
 	NFLOG_KEY_OOB_PROTOCOL,
 };
 
@@ -231,11 +224,6 @@ static struct ulogd_key output_keys[] = {
 		},
 	},
 	{
-		.type = ULOGD_RET_UINT8,
-		.flags = ULOGD_RETF_NONE,
-		.name = "oob.family",
-	},
-	{
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
@@ -258,9 +246,6 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	u_int32_t outdev = nflog_get_outdev(ldata);
 	u_int32_t seq;
 
-	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
-	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-
 	if (ph) {
 		/* FIXME */
 		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index cf44474..77087a4 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -68,7 +68,6 @@ enum ulog_keys {
 	ULOG_KEY_OOB_IN,
 	ULOG_KEY_OOB_OUT,
 	ULOG_KEY_RAW_MAC_LEN,
-	ULOG_KEY_OOB_FAMILY,
 	ULOG_KEY_OOB_PROTOCOL,
 };
 
@@ -148,11 +147,6 @@ static struct ulogd_key output_keys[] = {
 		.name = "raw.mac_len", 
 	},
 	{
-		.type = ULOGD_RET_UINT8,
-		.flags = ULOGD_RETF_NONE,
-		.name = "oob.family",
-	},
-	{
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.protocol",
@@ -201,9 +195,6 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	ret[ULOG_KEY_OOB_OUT].u.value.ptr = pkt->outdev_name;
 	ret[ULOG_KEY_OOB_OUT].flags |= ULOGD_RETF_VALID;
 
-	/* ULOG is IPv4 only */
-	ret[ULOG_KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
-	ret[ULOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
 	/* Undef in ULOG but necessary */
 	ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
 	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
-- 
1.5.2.5

