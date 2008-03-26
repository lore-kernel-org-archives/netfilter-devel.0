From: Eric Leblond <eric@inl.fr>
Subject: [Resend ULOGD PATCH] Add event output and make event mask configurable in NFCT.
Date: Wed, 26 Mar 2008 01:56:40 +0100
Message-ID: <12064930002868-git-send-email-eric@inl.fr>
References: <47E99B88.9090200@netfilter.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33683 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752319AbYCZA4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:56:43 -0400
In-Reply-To: <47E99B88.9090200@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Here's the modification following your recommandation. That's better like that :)

BR,

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   53 ++++++++++++++++++++++++++++-----------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 1843acb..7ca545f 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -66,9 +66,10 @@ struct nfct_pluginstance {
 
 #define HTABLE_SIZE	(8192)
 #define MAX_ENTRIES	(4 * HTABLE_SIZE)
+#define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 5,
+	.num_ces = 6,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -100,6 +101,13 @@ static struct config_keyset nfct_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = MAX_ENTRIES,
 		},
+		{
+			.key	 = "event_mask",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = EVENT_MASK,
+		},
+
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -107,6 +115,7 @@ static struct config_keyset nfct_kset = {
 #define prealloc_ce(x)	(x->ces[2])
 #define buckets_ce(x)	(x->ces[3])
 #define maxentries_ce(x) (x->ces[4])
+#define eventmask_ce(x) (x->ces[5])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -127,6 +136,7 @@ enum nfct_keys {
 	NFCT_ICMP_TYPE,
 	NFCT_CT_MARK,
 	NFCT_CT_ID,
+	NFCT_CT_EVENT,
 	NFCT_FLOW_START_SEC,
 	NFCT_FLOW_START_USEC,
 	NFCT_FLOW_END_SEC,
@@ -301,6 +311,12 @@ static struct ulogd_key nfct_okeys[] = {
 		},
 	},
 	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "ct.event",
+	},
+
+	{
 		.type 	= ULOGD_RET_UINT32,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "flow.start.sec",
@@ -454,11 +470,16 @@ static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
 static int propagate_ct(struct ulogd_pluginstance *upi,
 			struct nfct_conntrack *ct,
 			unsigned int flags,
+			int type,
 			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
 	int dir;
 	
+
+	ret[NFCT_CT_EVENT].u.value.ui32 = type;
+	ret[NFCT_CT_EVENT].flags |= ULOGD_RETF_VALID;
+
 	dir = NFCT_DIR_ORIGINAL;
 	ret[NFCT_ORIG_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
 	ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
@@ -559,28 +580,31 @@ static int event_handler(void *arg, unsigned int flags, int type,
 {
 	struct nfct_conntrack *ct = arg;
 	struct ulogd_pluginstance *upi = data;
-	struct ulogd_pluginstance *npi = NULL;
+	struct ulogd_key *kret = upi->output.keys;
 	struct nfct_pluginstance *cpi = 
 				(struct nfct_pluginstance *) upi->private;
+	struct ct_timestamp *ts = NULL;
+	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
 
+
 	if (type == NFCT_MSG_NEW) {
-		if (usehash_ce(upi->config_kset).u.value != 0)
+		if (usehash_ce(upi->config_kset).u.value != 0) {
 			ct_hash_add(cpi->ct_active, ct->id);
+			return 0;
+		}
 	} else if (type == NFCT_MSG_DESTROY) {
-		struct ct_timestamp *ts = NULL;
-
 		if (usehash_ce(upi->config_kset).u.value != 0)
 			ts = ct_hash_get(cpi->ct_active, ct->id);
+	}
 
-		llist_for_each_entry(npi, &upi->plist, plist) {
-			ret = propagate_ct(npi, ct, flags, ts);
-			if (ret != 0)
-				return ret;
-		}
-		return propagate_ct(upi, ct, flags, ts);
+	llist_for_each_entry(npi, &upi->plist, plist) {
+		ret = propagate_ct(npi, ct, flags, type, ts);
+		if (ret != 0)
+			return ret;
 	}
-	return 0;
+
+	return propagate_ct(upi, ct, flags, type, ts);
 }
 
 static int read_cb_nfct(int fd, unsigned int what, void *param)
@@ -638,9 +662,8 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 			(struct nfct_pluginstance *)upi->private;
 	int prealloc;
 
-	/* FIXME: make eventmask configurable */
-	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, NF_NETLINK_CONNTRACK_NEW|
-			     NF_NETLINK_CONNTRACK_DESTROY);
+	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK,
+			     eventmask_ce(upi->config_kset).u.value);
 	if (!cpi->cth) {
 		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
 		return -1;
-- 
1.5.2.5

