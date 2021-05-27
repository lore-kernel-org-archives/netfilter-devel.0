Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BBCC47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 21:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAC9613E5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 21:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhE0VeC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 17:34:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41156 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhE0VeB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 17:34:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E38D064501
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 23:31:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrackd] cthelper: Set up userspace helpers when daemon starts
Date:   Thu, 27 May 2021 23:32:14 +0200
Message-Id: <20210527213214.27727-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new setting to allow conntrackd to autoconfigure the userspace
helpers at startup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/helper/conntrackd.conf |  9 +++++--
 include/conntrackd.h       |  1 +
 src/cthelper.c             | 55 ++++++++++++++++++++++++++++++++++++++
 src/read_config_lex.l      |  1 +
 src/read_config_yy.y       | 13 ++++++++-
 5 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 6ffe00863c88..0255c2c42a95 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -3,11 +3,16 @@
 #
 
 Helper {
-	# Before this, you have to make sure you have registered the `ftp'
-	# user-space helper stub via:
+	#
+	# Set up the userspace helpers when the daemon is started. If unset,
+	# you have manually set up the user-space helper stub, e.g.
 	#
 	# nfct add helper ftp inet tcp
 	#
+	# Default: no (for backward compatibility reasons)
+	#
+	Setup yes
+
 	Type ftp inet tcp {
 		#
 		# Set NFQUEUE number you want to use to receive traffic from
diff --git a/include/conntrackd.h b/include/conntrackd.h
index fe9ec1854a7d..3e0d09585b26 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -138,6 +138,7 @@ struct ct_conf {
 	} stats;
 	struct {
 		struct list_head list;
+		bool setup;
 	} cthelper;
 };
 
diff --git a/src/cthelper.c b/src/cthelper.c
index f01c509abaa4..870c0026b758 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -49,8 +49,59 @@
 #include <linux/netfilter.h>
 #include <libnetfilter_queue/pktbuff.h>
 
+static int cthelper_destroy(struct ctd_helper_instance *cur)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nfct_helper *h;
+	struct nlmsghdr *nlh;
+	uint32_t seq;
+	int ret;
+
+	h = nfct_helper_alloc();
+	if (!h)
+		return -1;
+
+	nfct_helper_attr_set(h, NFCTH_ATTR_NAME, cur->helper->name);
+	nfct_helper_attr_set_u16(h, NFCTH_ATTR_PROTO_L3NUM, cur->l3proto);
+	nfct_helper_attr_set_u8(h, NFCTH_ATTR_PROTO_L4NUM, cur->l4proto);
+
+	seq = time(NULL);
+	nlh = nfct_helper_nlmsg_build_hdr(buf, NFNL_MSG_CTHELPER_DEL,
+					  NLM_F_ACK, seq);
+	nfct_helper_nlmsg_build_payload(nlh, h);
+
+	if (mnl_socket_sendto(STATE_CTH(nl), nlh, nlh->nlmsg_len) < 0) {
+		dlog(LOG_ERR, "destroying cthelper configuration");
+		goto err_out;
+	}
+
+	ret = mnl_socket_recvfrom(STATE_CTH(nl), buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, STATE_CTH(portid), NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(STATE_CTH(nl), buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		dlog(LOG_ERR, "trying to destroy cthelper `%s': %s",
+			cur->helper->name, strerror(errno));
+		goto err_out;
+	}
+
+	return 0;
+err_out:
+	nfct_helper_free(h);
+	return -1;
+}
+
 void cthelper_kill(void)
 {
+	struct ctd_helper_instance *cur;
+
+	if (CONFIG(cthelper).setup) {
+		list_for_each_entry(cur, &CONFIG(cthelper).list, head)
+			cthelper_destroy(cur);
+	}
 	mnl_socket_close(STATE_CTH(nl));
 	free(state.cthelper);
 }
@@ -386,6 +437,10 @@ static int cthelper_setup(struct ctd_helper_instance *cur)
 	nfct_helper_attr_set_u32(t, NFCTH_ATTR_QUEUE_NUM, cur->queue_num);
 	nfct_helper_attr_set_u16(t, NFCTH_ATTR_PROTO_L3NUM, cur->l3proto);
 	nfct_helper_attr_set_u8(t, NFCTH_ATTR_PROTO_L4NUM, cur->l4proto);
+	if (CONFIG(cthelper).setup) {
+		nfct_helper_attr_set_u32(t, NFCTH_ATTR_PRIV_DATA_LEN,
+					 cur->helper->priv_data_len);
+	}
 	nfct_helper_attr_set_u32(t, NFCTH_ATTR_STATUS,
 					NFCT_HELPER_STATUS_ENABLED);
 
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index f1f4fe3f5b5d..7dc400a3a9b5 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -141,6 +141,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "ExpectTimeout"			{ return T_HELPER_EXPECT_TIMEOUT; }
 "Systemd"			{ return T_SYSTEMD; }
 "StartupResync"			{ return T_STARTUP_RESYNC; }
+"Setup"				{ return T_SETUP; }
 
 {is_true}		{ return T_ON; }
 {is_false}		{ return T_OFF; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index b215a729b716..95845a19e768 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -63,7 +63,7 @@ enum {
 
 %token T_IPV4_ADDR T_IPV4_IFACE T_PORT T_HASHSIZE T_HASHLIMIT T_MULTICAST
 %token T_PATH T_UNIX T_REFRESH T_IPV6_ADDR T_IPV6_IFACE
-%token T_BACKLOG T_GROUP T_IGNORE
+%token T_BACKLOG T_GROUP T_IGNORE T_SETUP
 %token T_LOG T_UDP T_ICMP T_IGMP T_VRRP T_TCP
 %token T_LOCK T_BUFFER_SIZE_MAX_GROWN T_EXPIRE T_TIMEOUT
 %token T_GENERAL T_SYNC T_STATS T_BUFFER_SIZE
@@ -1454,6 +1454,7 @@ helper_list:
 	    ;
 
 helper_line: helper_type
+	    | helper_setup
 	    ;
 
 helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
@@ -1562,6 +1563,16 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	list_add(&helper_inst->head, &CONFIG(cthelper).list);
 };
 
+helper_setup : T_SETUP T_ON
+{
+	CONFIG(cthelper).setup = true;
+};
+
+helper_setup : T_SETUP T_OFF
+{
+	CONFIG(cthelper).setup = false;
+};
+
 helper_type_list:
 		| helper_type_list helper_type_line
 		;
-- 
2.30.2

