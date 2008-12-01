From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 03/18] Get rid of addressfamily variable in NFLOG input plugin
Date: Mon,  1 Dec 2008 22:36:01 +0100
Message-ID: <1228167376-22101-4-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39292 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The addressfamily configuration variable for NFLOG is used as param
for nflog_bind_pf. This function is used to claim the fetching of
kernel message sent via nf_log_packet() function.

As all kernel messages are sent to the group 0, it is useless to
call nflog_bind_pf when nflog group of the input plugin is not 0.
Furthermore, as only one plugin can be bound to nflog group 0, it
is mandatory to call nflog_bind_pf for all pf family when the group
is 0.

To sum up, this patch suppress the adressfamily parameter (which
simplify the configuration file) and call nflog_bind_pf for all
pf family when the nflog group of the instance is 0.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   59 ++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 647b61c..e27355d 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -46,12 +46,6 @@ static struct config_keyset libulog_kset = {
 			.u.value = NFLOG_GROUP_DEFAULT,
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
@@ -92,13 +86,12 @@ static struct config_keyset libulog_kset = {
 
 #define bufsiz_ce(x)	(x->ces[0])
 #define group_ce(x)	(x->ces[1])
-#define af_ce(x)	(x->ces[2])
-#define unbind_ce(x)	(x->ces[3])
-#define seq_ce(x)	(x->ces[4])
-#define seq_global_ce(x)	(x->ces[5])
-#define label_ce(x)	(x->ces[6])
-#define nlsockbufsize_ce(x) (x->ces[7])
-#define nlsockbufmaxsize_ce(x) (x->ces[8])
+#define unbind_ce(x)	(x->ces[2])
+#define seq_ce(x)	(x->ces[3])
+#define seq_global_ce(x)	(x->ces[4])
+#define label_ce(x)	(x->ces[5])
+#define nlsockbufsize_ce(x) (x->ces[6])
+#define nlsockbufmaxsize_ce(x) (x->ces[7])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
@@ -293,7 +286,8 @@ static struct ulogd_key output_keys[] = {
 };
 
 static inline int
-interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
+interp_packet(struct ulogd_pluginstance *upi, u_int8_t pf_family,
+	      struct nflog_data *ldata)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -311,7 +305,7 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	u_int32_t gid;
 
 	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], 
-		    af_ce(upi->config_kset).u.value);
+		    pf_family);
 	okey_set_u8(&ret[NFLOG_KEY_RAW_LABEL],
 		    label_ce(upi->config_kset).u.value);
 
@@ -446,11 +440,11 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 	/* since we support the re-use of one instance in several 
 	 * different stacks, we duplicate the message to let them know */
 	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = interp_packet(npi, nfa);
+		ret = interp_packet(npi, nfmsg->nfgen_family, nfa);
 		if (ret != 0)
 			return ret;
 	}
-	return interp_packet(upi, nfa);
+	return interp_packet(upi, nfmsg->nfgen_family, nfa);
 }
 
 static int configure(struct ulogd_pluginstance *upi,
@@ -463,28 +457,26 @@ static int configure(struct ulogd_pluginstance *upi,
 	return 0;
 }
 
-static int become_system_logging(struct ulogd_pluginstance *upi)
+static int become_system_logging(struct ulogd_pluginstance *upi, u_int8_t pf)
 {
 	struct nflog_input *ui = (struct nflog_input *) upi->private;
 
 	if (unbind_ce(upi->config_kset).u.value > 0) {
 		ulogd_log(ULOGD_NOTICE, "forcing unbind of existing log "
 				"handler for protocol %d\n",
-				af_ce(upi->config_kset).u.value);
-		if (nflog_unbind_pf(ui->nful_h,
-					af_ce(upi->config_kset).u.value) < 0) {
+				pf);
+		if (nflog_unbind_pf(ui->nful_h, pf) < 0) {
 			ulogd_log(ULOGD_ERROR, "unable to force-unbind "
 					"existing log handler for protocol %d\n",
-					af_ce(upi->config_kset).u.value);
+					pf);
 			return -1;
 		}
 	}
 
-	ulogd_log(ULOGD_DEBUG, "binding to protocol family %d\n",
-			af_ce(upi->config_kset).u.value);
-	if (nflog_bind_pf(ui->nful_h, af_ce(upi->config_kset).u.value) < 0) {
-		ulogd_log(ULOGD_ERROR, "unable to bind to protocol family %d\n",
-				af_ce(upi->config_kset).u.value);
+	ulogd_log(ULOGD_DEBUG, "binding to protocol family %d\n", pf);
+	if (nflog_bind_pf(ui->nful_h, pf) < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to bind to"
+				" protocol family %d\n", pf);
 		return -1;
 	}
 	return 0;
@@ -506,7 +498,11 @@ static int start(struct ulogd_pluginstance *upi)
 
 	/* This is the system logging (conntrack, ...) facility */
 	if (group_ce(upi->config_kset).u.value == 0) {
-		if (become_system_logging(upi) == -1)
+		if (become_system_logging(upi, AF_INET) == -1)
+			goto out_handle;
+		if (become_system_logging(upi, AF_INET6) == -1)
+			goto out_handle;
+		if (become_system_logging(upi, AF_BRIDGE) == -1)
 			goto out_handle;
 	}
 
@@ -554,8 +550,11 @@ static int start(struct ulogd_pluginstance *upi)
 
 out_bind:
 	nflog_close(ui->nful_h);
-	if (group_ce(upi->config_kset).u.value == 0)
-		nflog_unbind_pf(ui->nful_h, af_ce(upi->config_kset).u.value);
+	if (group_ce(upi->config_kset).u.value == 0) {
+		nflog_unbind_pf(ui->nful_h, AF_INET);
+		nflog_unbind_pf(ui->nful_h, AF_INET6);
+		nflog_unbind_pf(ui->nful_h, AF_BRIDGE);
+	}
 out_handle:
 	free(ui->nfulog_buf);
 out_buf:
-- 
1.5.6.3

