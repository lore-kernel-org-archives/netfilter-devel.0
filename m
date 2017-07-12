From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [nft PATCH] monitor: add debug messages
Date: Wed, 12 Jul 2017 13:29:49 +0200
Message-ID: <149985898964.3446.4650892786570168840.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59519 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756272AbdGLL36 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 07:29:58 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 7AEDF51F4CC
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 11:29:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pmqMDIq0rr2R for <netfilter-devel@vger.kernel.org>;
        Wed, 12 Jul 2017 13:29:50 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id DB8E051F453
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 13:29:50 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some debug messages in the monitor/trace code paths to ease development
and debugging in case of errors.

After this patch, running 'nft monitor --debug=mnl,netlink' is more verbose.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/mnl.c     |    7 +++++++
 src/netlink.c |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index da7c090..cf060a4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1139,6 +1139,13 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
 			break;
 		}
+
+#ifdef DEBUG
+		if (debug_level & DEBUG_MNL) {
+			mnl_nlmsg_fprintf(stdout, buf, sizeof(buf),
+					  sizeof(struct nfgenmsg));
+		}
+#endif /* DEBUG */
 		ret = mnl_cb_run(buf, ret, 0, 0, cb, cb_data);
 		if (ret <= 0)
 			break;
diff --git a/src/netlink.c b/src/netlink.c
index 880502c..50ed25f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2877,12 +2877,51 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	return MNL_CB_OK;
 }
 
+#ifdef DEBUG
+/* only those which could be useful listening to events */
+static const char *const nftnl_msg_types[NFT_MSG_MAX] = {
+	[NFT_MSG_NEWTABLE]	= "NFT_MSG_NEWTABLE",
+	[NFT_MSG_DELTABLE]	= "NFT_MSG_DELTABLE",
+	[NFT_MSG_NEWCHAIN]	= "NFT_MSG_NEWCHAIN",
+	[NFT_MSG_DELCHAIN]	= "NFT_MSG_DELCHAIN",
+	[NFT_MSG_NEWSET]	= "NFT_MSG_NEWSET",
+	[NFT_MSG_DELSET]	= "NFT_MSG_DELSET",
+	[NFT_MSG_NEWSETELEM]	= "NFT_MSG_NEWSETELEM",
+	[NFT_MSG_DELSETELEM]	= "NFT_MSG_DELSETELEM",
+	[NFT_MSG_NEWRULE]	= "NFT_MSG_NEWRULE",
+	[NFT_MSG_DELRULE]	= "NFT_MSG_DELRULE",
+	[NFT_MSG_TRACE]		= "NFT_MSG_TRACE",
+	[NFT_MSG_NEWGEN]	= "NFT_MSG_NEWGEN",
+	[NFT_MSG_NEWOBJ]	= "NFT_MSG_NEWOBJ",
+	[NFT_MSG_DELOBJ]	= "NFT_MSG_DELOBJ",
+};
+
+static const char *nftnl_msgtype2str(uint16_t type)
+{
+	if (type >= NFT_MSG_MAX || !nftnl_msg_types[type])
+		return "unknown";
+
+	return nftnl_msg_types[type];
+}
+#endif /* DEBUG */
+
+static void netlink_events_debug(uint16_t type)
+{
+#ifdef DEBUG
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
+
+	printf("netlink event: %s\n", nftnl_msgtype2str(type));
+#endif /* DEBUG */
+}
+
 static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
 	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
 	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
 
+	netlink_events_debug(type);
 	netlink_events_cache_update(monh, nlh, type);
 
 	if (!(monh->monitor_flags & (1 << type)))

