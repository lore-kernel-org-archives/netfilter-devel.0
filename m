From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/6] Suppress spaces at end of line.
Date: Thu, 19 Jun 2008 14:23:02 +0200
Message-ID: <1213878187-909-2-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60866 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbYFSMXd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:33 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch suppress useless spaces at end of lines.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c   |   38 +++++++++++++-------------
 input/packet/ulogd_inppkt_NFLOG.c |   52 ++++++++++++++++++------------------
 input/packet/ulogd_inppkt_ULOG.c  |   46 ++++++++++++++++----------------
 3 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index f28e3fa..58bb0e2 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -156,7 +156,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "orig.ip.saddr",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceIPv4Address,
 		},
@@ -174,7 +174,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT8,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "orig.ip.protocol",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_protocolIdentifier,
 		},
@@ -201,7 +201,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "orig.raw.pktlen",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
 			/* FIXME: this could also be octetDeltaCount */
@@ -211,7 +211,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "orig.raw.pktcount",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
 			/* FIXME: this could also be packetDeltaCount */
@@ -221,7 +221,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "reply.ip.saddr",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceIPv4Address,
 		},
@@ -239,7 +239,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT8,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.ip.protocol",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_protocolIdentifier,
 		},
@@ -266,7 +266,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktlen",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
 			/* FIXME: this could also be octetDeltaCount */
@@ -276,7 +276,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "reply.raw.pktcount",
-		.ipfix	= { 
+		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
 			/* FIXME: this could also be packetDeltaCount */
@@ -442,7 +442,7 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
-	
+
 	ret[NFCT_CT_EVENT].u.value.ui32 = type;
 	ret[NFCT_CT_EVENT].flags |= ULOGD_RETF_VALID;
 
@@ -569,7 +569,7 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 
 	if (ts) {
 		if (ts->time[START].tv_sec) {
-			ret[NFCT_FLOW_START_SEC].u.value.ui32 = 
+			ret[NFCT_FLOW_START_SEC].u.value.ui32 =
 				ts->time[START].tv_sec;
 			ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
 
@@ -618,7 +618,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 			 void *data)
 {
 	struct ulogd_pluginstance *upi = data;
-	struct nfct_pluginstance *cpi = 
+	struct nfct_pluginstance *cpi =
 				(struct nfct_pluginstance *) upi->private;
 	struct ct_timestamp *ts = NULL;
 	struct ct_timestamp tmp = {
@@ -732,7 +732,7 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 					  "`netlink_socket_buffer_size' and "
 					  "`netlink_socket_buffer_maxsize'\n");
 			}
-			
+
 			/* internal hash can deal with refresh */
 			if (usehash_ce(upi->config_kset).u.value != 0) {
 				nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
@@ -816,7 +816,7 @@ static int read_cb_ovh(int fd, unsigned int what, void *param)
 static int get_ctr_zero(struct ulogd_pluginstance *upi)
 {
 	int family = 0; /* any */
-	struct nfct_pluginstance *cpi = 
+	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 
 	return nfct_query(cpi->cth, NFCT_Q_DUMP_RESET, &family);
@@ -825,7 +825,7 @@ static int get_ctr_zero(struct ulogd_pluginstance *upi)
 static void getctr_timer_cb(struct ulogd_timer *t, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
-	struct nfct_pluginstance *cpi = 
+	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 
 	get_ctr_zero(upi);
@@ -835,10 +835,10 @@ static void getctr_timer_cb(struct ulogd_timer *t, void *data)
 static int configure_nfct(struct ulogd_pluginstance *upi,
 			  struct ulogd_pluginstance_stack *stack)
 {
-	struct nfct_pluginstance *cpi = 
+	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 	int ret;
-	
+
 	ret = config_parse_file(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;
@@ -865,7 +865,7 @@ static void overrun_timeout(struct ulogd_timer *a, void *data)
 
 static int constructor_nfct(struct ulogd_pluginstance *upi)
 {
-	struct nfct_pluginstance *cpi = 
+	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 
 	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK,
@@ -931,7 +931,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 			return -1;
 		}
 	}
-	
+
 	return 0;
 }
 
@@ -939,7 +939,7 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 {
 	struct nfct_pluginstance *cpi = (void *) pi;
 	int rc;
-	
+
 	hashtable_destroy(cpi->ct_active);
 
 	rc = nfct_close(cpi->cth);
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 8c2aab6..95a2956 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -136,10 +136,10 @@ enum nflog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	{ 
-		.type = ULOGD_RET_RAW, 
+	{
+		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
-		.name = "raw.mac", 
+		.name = "raw.mac",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
@@ -158,7 +158,7 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktlen",
-		.ipfix = { 
+		.ipfix = {
 			.vendor = IPFIX_VENDOR_NETFILTER,
 			.field_id = IPFIX_NF_rawpacket_length,
 		},
@@ -167,32 +167,32 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktcount",
-		.ipfix = { 
+		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_packetDeltaCount,
 		},
 	},
 	{
 		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_NONE, 
-		.name = "oob.prefix", 
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.prefix",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_NETFILTER,
-			.field_id = IPFIX_NF_prefix,  
+			.field_id = IPFIX_NF_prefix,
 		},
 	},
-	{ 	.type = ULOGD_RET_UINT32, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "oob.time.sec", 
-		.ipfix = { 
-			.vendor = IPFIX_VENDOR_IETF, 
-			.field_id = IPFIX_flowStartSeconds, 
+	{ 	.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.sec",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_flowStartSeconds,
 		},
 	},
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.time.usec", 
+		.name = "oob.time.usec",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_flowStartMicroSeconds,
@@ -201,7 +201,7 @@ static struct ulogd_key output_keys[] = {
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.mark", 
+		.name = "oob.mark",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_NETFILTER,
 			.field_id = IPFIX_NF_mark,
@@ -210,7 +210,7 @@ static struct ulogd_key output_keys[] = {
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.ifindex_in", 
+		.name = "oob.ifindex_in",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_ingressInterface,
@@ -219,7 +219,7 @@ static struct ulogd_key output_keys[] = {
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.ifindex_out", 
+		.name = "oob.ifindex_out",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_egressInterface,
@@ -234,10 +234,10 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_hook,
 		},
 	},
-	{ 
-		.type = ULOGD_RET_UINT16, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "raw.mac_len", 
+	{
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac_len",
 	},
 	{
 		.type = ULOGD_RET_UINT32,
@@ -285,7 +285,7 @@ static struct ulogd_key output_keys[] = {
 
 };
 
-static inline int 
+static inline int
 interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 {
 	struct ulogd_key *ret = upi->output.keys;
@@ -489,9 +489,9 @@ static int start(struct ulogd_pluginstance *upi)
 
 	if (unbind_ce(upi->config_kset).u.value > 0) {
 		ulogd_log(ULOGD_NOTICE, "forcing unbind of existing log "
-			  "handler for protocol %d\n", 
+			  "handler for protocol %d\n",
 			  af_ce(upi->config_kset).u.value);
-		if (nflog_unbind_pf(ui->nful_h, 
+		if (nflog_unbind_pf(ui->nful_h,
 				    af_ce(upi->config_kset).u.value) < 0) {
 			ulogd_log(ULOGD_ERROR, "unable to force-unbind "
 				  "existing log handler for protocol %d\n",
@@ -537,7 +537,7 @@ static int start(struct ulogd_pluginstance *upi)
 			ulogd_log(ULOGD_ERROR, "unable to set flags 0x%x\n",
 				  flags);
 	}
-	
+
 	nflog_callback_register(ui->nful_gh, &msg_cb, upi);
 
 	ui->nful_fd.fd = nflog_fd(ui->nful_h);
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 0b58393..2f65813 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -83,10 +83,10 @@ enum ulog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	{ 
-		.type = ULOGD_RET_RAW, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "raw.mac", 
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
@@ -105,7 +105,7 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktlen",
-		.ipfix = { 
+		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = 1
 		},
@@ -114,43 +114,43 @@ static struct ulogd_key output_keys[] = {
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.pktcount",
-		.ipfix = { 
+		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = 2
 		},
 	},
 	{
 		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_NONE, 
-		.name = "oob.prefix", 
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.prefix",
 	},
-	{ 	.type = ULOGD_RET_UINT32, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "oob.time.sec", 
-		.ipfix = { 
-			.vendor = IPFIX_VENDOR_IETF, 
-			.field_id = 22 
+	{ 	.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.time.sec",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = 22
 		},
 	},
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.time.usec", 
+		.name = "oob.time.usec",
 	},
 	{
 		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.mark", 
+		.name = "oob.mark",
 	},
 	{
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.in", 
+		.name = "oob.in",
 	},
 	{
 		.type = ULOGD_RET_STRING,
 		.flags = ULOGD_RETF_NONE,
-		.name = "oob.out", 
+		.name = "oob.out",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
@@ -161,10 +161,10 @@ static struct ulogd_key output_keys[] = {
 			.field_id = IPFIX_NF_hook,
 		},
 	},
-	{ 
-		.type = ULOGD_RET_UINT16, 
-		.flags = ULOGD_RETF_NONE, 
-		.name = "raw.mac_len", 
+	{
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac_len",
 	},
 	{
 		.type = ULOGD_RET_UINT8,
-- 
1.5.5.3

