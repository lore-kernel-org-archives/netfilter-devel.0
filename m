From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 1/4] Make NFLOG export raw header and source raw
 address.
Date: Thu, 24 Jul 2008 09:25:24 +0200
Message-ID: <48882E64.4010009@netfilter.org>
References: <> <1216848048-13516-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060505000902080907000206"
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42676 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbYGXHZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:25:40 -0400
In-Reply-To: <1216848048-13516-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505000902080907000206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric Leblond wrote:
> diff --git a/configure.in b/configure.in
> index 8e0f6a3..c25bbdb 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -41,8 +41,10 @@ PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_
>  
>  PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
>  
> -PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
> +PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_NOTICE(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
>  
> +AC_CHECK_LIB([netfilter_log],[nflog_get_msg_packet_hwhdrlen],
> +                        AC_DEFINE_UNQUOTED([HAVE_NFLOG_RAWHEADER],[1],[NFLOG userspace has raw header support]),,[-lnfnetlink])

You know my policy on this. I'm not willing to pollute the source code
with #ifdef's, I prefer bumping the libnetfilter_log version dependency
checking. At least during the development stage, later we can discuss
this issue again.

>  CT_CHECK_POSTGRES_DB()
>  AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
> diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
> index cb58661..c2de88c 100644
> --- a/input/packet/ulogd_inppkt_NFLOG.c
> +++ b/input/packet/ulogd_inppkt_NFLOG.c
> @@ -9,6 +9,8 @@
>  #include <errno.h>
>  
>  #include <ulogd/ulogd.h>
> +#include <config.h>

Where's config.h?

I have enqueued the following patch until I can apply 2, 3 and 4. Also,
I have a attached a minor cleanup to break lines at 80 chars.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060505000902080907000206
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Add support for NFLOG's hardware header fields

This patch modifies the key structure of NFLOG. It solves the conflict 
between ULOG and NFLOG by ensuring that keys have the same meaning:

* raw.mac is the full hardware header
* raw.mac.saddr is the source hardware address

Following Patrick suggestion, it adds a new key "raw.type" which is used
to store the type of hardware.

The configure.in file has been modified to autodetect the existence of the
required NFLOG functions.

This patch also bump the required libnetfilter_log version to 0.0.15.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
diff --git a/configure.in b/configure.in
index 8e0f6a3..96cc2d0 100644
--- a/configure.in
+++ b/configure.in
@@ -35,7 +35,7 @@ CFLAGS="$CFLAGS -Wall -Wextra"
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
-LIBNETFILTER_LOG_REQUIRED=0.0.14
+LIBNETFILTER_LOG_REQUIRED=0.0.15
 
 PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
 
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index cb58661..4853c77 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -133,6 +133,9 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_UID,
 	NFLOG_KEY_OOB_GID,
 	NFLOG_KEY_RAW_LABEL,
+	NFLOG_KEY_RAW_TYPE,
+	NFLOG_KEY_RAW_MAC_SADDR,
+	NFLOG_KEY_RAW_MAC_ADDRLEN,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -140,6 +143,11 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac",
+	},
+	[NFLOG_KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.saddr",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
@@ -240,6 +248,12 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.mac_len",
 	},
+	[NFLOG_KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.addrlen",
+	},
+
 	[NFLOG_KEY_OOB_SEQ_LOCAL] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
@@ -283,6 +297,11 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.label",
 	},
+	[NFLOG_KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
 
 };
 
@@ -318,11 +337,22 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 	}
 
-	if (hw) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = hw->hw_addr;
+	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
+		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = nflog_get_msg_packet_hwhdr(ldata);
 		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
+			nflog_get_msg_packet_hwhdrlen(ldata);
 		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
+		ret[NFLOG_KEY_RAW_TYPE].u.value.ui16 =
+			nflog_get_hwtype(ldata);
+		ret[NFLOG_KEY_RAW_TYPE].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (hw) {
+		ret[NFLOG_KEY_RAW_MAC_SADDR].u.value.ptr = hw->hw_addr;
+		ret[NFLOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (payload_len >= 0) {

--------------060505000902080907000206
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

cleanup: break lines at 80 chars per column

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Index: ulogd2/input/packet/ulogd_inppkt_NFLOG.c
===================================================================
--- ulogd2.orig/input/packet/ulogd_inppkt_NFLOG.c	2008-07-24 09:15:00.000000000 +0200
+++ ulogd2/input/packet/ulogd_inppkt_NFLOG.c	2008-07-24 09:18:16.000000000 +0200
@@ -326,19 +326,22 @@ interp_packet(struct ulogd_pluginstance 
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
 
-	ret[NFLOG_KEY_RAW_LABEL].u.value.ui8 = label_ce(upi->config_kset).u.value;
+	ret[NFLOG_KEY_RAW_LABEL].u.value.ui8 =
+			label_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
 
 	if (ph) {
 		/* FIXME */
 		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
 		ret[NFLOG_KEY_OOB_HOOK].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_OOB_PROTOCOL].u.value.ui16 = ntohs(ph->hw_protocol);
+		ret[NFLOG_KEY_OOB_PROTOCOL].u.value.ui16 =
+					ntohs(ph->hw_protocol);
 		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = nflog_get_msg_packet_hwhdr(ldata);
+		ret[NFLOG_KEY_RAW_MAC].u.value.ptr =
+			nflog_get_msg_packet_hwhdr(ldata);
 		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
 		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
 			nflog_get_msg_packet_hwhdrlen(ldata);
@@ -351,7 +354,8 @@ interp_packet(struct ulogd_pluginstance 
 	if (hw) {
 		ret[NFLOG_KEY_RAW_MAC_SADDR].u.value.ptr = hw->hw_addr;
 		ret[NFLOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].u.value.ui16 = ntohs(hw->hw_addrlen);
+		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].u.value.ui16 =
+						ntohs(hw->hw_addrlen);
 		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].flags |= ULOGD_RETF_VALID;
 	}
 
@@ -606,13 +610,13 @@ static int stop(struct ulogd_pluginstanc
 struct ulogd_plugin libulog_plugin = {
 	.name = "NFLOG",
 	.input = {
-			.type = ULOGD_DTYPE_SOURCE,
-		},
+		.type = ULOGD_DTYPE_SOURCE,
+	},
 	.output = {
-			.type = ULOGD_DTYPE_RAW,
-			.keys = output_keys,
-			.num_keys = sizeof(output_keys)/sizeof(struct ulogd_key),
-		},
+		.type = ULOGD_DTYPE_RAW,
+		.keys = output_keys,
+		.num_keys = sizeof(output_keys)/sizeof(struct ulogd_key),
+	},
 	.priv_size 	= sizeof(struct nflog_input),
 	.configure 	= &configure,
 	.start 		= &start,

--------------060505000902080907000206--
