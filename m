Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACD8C4708E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 11:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4CD613DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 11:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhE1Lpc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 07:45:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52232 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhE1Lpc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 07:45:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3801D644F9
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 13:42:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrackd,v2 1/2] cthelper: Set up userspace helpers when daemon starts
Date:   Fri, 28 May 2021 13:43:49 +0200
Message-Id: <20210528114350.48066-1-pablo@netfilter.org>
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
v2: do not destroy helper, it hits EBUSY if it is used from the ruleset.

 doc/helper/conntrackd.conf | 14 ++++++++++++--
 include/conntrackd.h       |  1 +
 src/cthelper.c             |  5 +++++
 src/read_config_lex.l      |  1 +
 src/read_config_yy.y       | 13 ++++++++++++-
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 6ffe00863c88..cbcb284aa92d 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -3,11 +3,21 @@
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
+	# This new setting simplifies new deployment, so it is recommended to
+	# turn it on. On existing deployments, make sure to remove the nfct
+	# command invocation since it is not required anymore.
+	#
+	# Default: no (for backward compatibility reasons)
+	# Recommended: yes
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
index f01c509abaa4..07b781f73c80 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -49,6 +49,7 @@
 #include <linux/netfilter.h>
 #include <libnetfilter_queue/pktbuff.h>
 
+
 void cthelper_kill(void)
 {
 	mnl_socket_close(STATE_CTH(nl));
@@ -386,6 +387,10 @@ static int cthelper_setup(struct ctd_helper_instance *cur)
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

