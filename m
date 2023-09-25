Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F0ACE7A94
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 12:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjIYM2t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 08:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjIYM2t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 08:28:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7E37C0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 05:28:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrackd: consolidate check for maximum number of channels
Date:   Mon, 25 Sep 2023 14:28:33 +0200
Message-Id: <20230925122833.159126-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a helper function and use it to check for the maximum number of
channels, bail out if it is exceeded.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/read_config_yy.y | 259 ++++++++++++++++++++++---------------------
 1 file changed, 133 insertions(+), 126 deletions(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index d9b02ab37c5a..a116b0b690e4 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -54,7 +54,17 @@ struct ct_conf conf;
 
 static void __kernel_filter_start(void);
 static void __kernel_filter_add_state(int value);
-static void __max_dedicated_links_reached(void);
+
+static struct channel_conf *conf_get_channel(void)
+{
+	if (conf.channel_num >= MULTICHANNEL_MAX) {
+		dlog(LOG_ERR, "too many dedicated links in the configuration "
+		     "file (Maximum: %d)", MULTICHANNEL_MAX);
+		exit(EXIT_FAILURE);
+	}
+
+	return &conf.channel[conf.channel_num];
+}
 
 struct stack symbol_stack;
 
@@ -213,6 +223,8 @@ purge: T_PURGE T_NUMBER
 
 multicast_line : T_MULTICAST '{' multicast_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_MCAST) {
 		dlog(LOG_ERR, "cannot use `Multicast' with other "
@@ -220,13 +232,15 @@ multicast_line : T_MULTICAST '{' multicast_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED;
+	channel_conf->channel_type = CHANNEL_MCAST;
+	channel_conf->channel_flags = CHANNEL_F_BUFFERED;
 	conf.channel_num++;
 };
 
 multicast_line : T_MULTICAST T_DEFAULT '{' multicast_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_MCAST) {
 		dlog(LOG_ERR, "cannot use `Multicast' with other "
@@ -234,9 +248,8 @@ multicast_line : T_MULTICAST T_DEFAULT '{' multicast_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_MCAST;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
-						       CHANNEL_F_BUFFERED;
+	channel_conf->channel_type = CHANNEL_MCAST;
+	channel_conf->channel_flags = CHANNEL_F_DEFAULT | CHANNEL_F_BUFFERED;
 	conf.channel_default = conf.channel_num;
 	conf.channel_num++;
 };
@@ -246,9 +259,7 @@ multicast_options :
 
 multicast_option : T_IPV4_ADDR T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.mcast.in.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -256,7 +267,7 @@ multicast_option : T_IPV4_ADDR T_IP
 		break;
 	}
 
-        if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
+        if (channel_conf->u.mcast.ipproto == AF_INET6) {
 		dlog(LOG_WARNING, "your multicast address is IPv4 but "
 		     "is binded to an IPv6 interface? "
 		     "Surely, this is not what you want");
@@ -264,16 +275,15 @@ multicast_option : T_IPV4_ADDR T_IP
 	}
 
 	free($2);
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	channel_conf->u.mcast.ipproto = AF_INET;
 };
 
 multicast_option : T_IPV6_ADDR T_IP
 {
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 	int err;
 
-	err = inet_pton(AF_INET6, $2,
-			&conf.channel[conf.channel_num].u.mcast.in);
+	err = inet_pton(AF_INET6, $2, &channel_conf->u.mcast.in);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		free($2);
@@ -283,7 +293,7 @@ multicast_option : T_IPV6_ADDR T_IP
 		exit(EXIT_FAILURE);
 	}
 
-	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET) {
+	if (channel_conf->u.mcast.ipproto == AF_INET) {
 		dlog(LOG_WARNING, "your multicast address is IPv6 but "
 		     "is binded to an IPv4 interface? "
 		     "Surely this is not what you want");
@@ -291,10 +301,10 @@ multicast_option : T_IPV6_ADDR T_IP
 		break;
 	}
 
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+	channel_conf->u.mcast.ipproto = AF_INET6;
 
-	if (conf.channel[conf.channel_num].channel_ifname[0] &&
-	    !conf.channel[conf.channel_num].u.mcast.ifa.interface_index6) {
+	if (channel_conf->channel_ifname[0] &&
+	    !channel_conf->u.mcast.ifa.interface_index6) {
 		unsigned int idx;
 
 		idx = if_nametoindex($2);
@@ -304,17 +314,15 @@ multicast_option : T_IPV6_ADDR T_IP
 			break;
 		}
 
-		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
-		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+		channel_conf->u.mcast.ifa.interface_index6 = idx;
+		channel_conf->u.mcast.ipproto = AF_INET6;
 	}
 	free($2);
 };
 
 multicast_option : T_IPV4_IFACE T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.mcast.ifa.interface_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -323,14 +331,14 @@ multicast_option : T_IPV4_IFACE T_IP
 	}
 	free($2);
 
-        if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
+        if (channel_conf->u.mcast.ipproto == AF_INET6) {
 		dlog(LOG_WARNING, "your multicast interface is IPv4 but "
 		     "is binded to an IPv6 interface? "
 		     "Surely, this is not what you want");
 		break;
 	}
 
-	conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET;
+	channel_conf->u.mcast.ipproto = AF_INET;
 };
 
 multicast_option : T_IPV6_IFACE T_IP
@@ -341,11 +349,10 @@ multicast_option : T_IPV6_IFACE T_IP
 
 multicast_option : T_IFACE T_STRING
 {
+	struct channel_conf *channel_conf = conf_get_channel();
 	unsigned int idx;
 
-	__max_dedicated_links_reached();
-
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(channel_conf->channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
@@ -354,9 +361,9 @@ multicast_option : T_IFACE T_STRING
 		break;
 	}
 
-	if (conf.channel[conf.channel_num].u.mcast.ipproto == AF_INET6) {
-		conf.channel[conf.channel_num].u.mcast.ifa.interface_index6 = idx;
-		conf.channel[conf.channel_num].u.mcast.ipproto = AF_INET6;
+	if (channel_conf->u.mcast.ipproto == AF_INET6) {
+		channel_conf->u.mcast.ifa.interface_index6 = idx;
+		channel_conf->u.mcast.ipproto = AF_INET6;
 	}
 
 	free($2);
@@ -364,36 +371,43 @@ multicast_option : T_IFACE T_STRING
 
 multicast_option : T_GROUP T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.port = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.mcast.port = $2;
 };
 
 multicast_option: T_SNDBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.sndbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.mcast.sndbuf = $2;
 };
 
 multicast_option: T_RCVBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.rcvbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.mcast.rcvbuf = $2;
 };
 
-multicast_option: T_CHECKSUM T_ON 
+multicast_option: T_CHECKSUM T_ON
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.checksum = 0;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.mcast.checksum = 0;
 };
 
 multicast_option: T_CHECKSUM T_OFF
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.mcast.checksum = 1;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.mcast.checksum = 1;
 };
 
 udp_line : T_UDP '{' udp_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_UDP) {
 		dlog(LOG_ERR, "cannot use `UDP' with other "
@@ -401,13 +415,15 @@ udp_line : T_UDP '{' udp_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED;
+	channel_conf->channel_type = CHANNEL_UDP;
+	channel_conf->channel_flags = CHANNEL_F_BUFFERED;
 	conf.channel_num++;
 };
 
 udp_line : T_UDP T_DEFAULT '{' udp_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_UDP) {
 		dlog(LOG_ERR, "cannot use `UDP' with other "
@@ -415,9 +431,8 @@ udp_line : T_UDP T_DEFAULT '{' udp_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_UDP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
-						       CHANNEL_F_BUFFERED;
+	channel_conf->channel_type = CHANNEL_UDP;
+	channel_conf->channel_flags = CHANNEL_F_DEFAULT | CHANNEL_F_BUFFERED;
 	conf.channel_default = conf.channel_num;
 	conf.channel_num++;
 };
@@ -427,9 +442,7 @@ udp_options :
 
 udp_option : T_IPV4_ADDR T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.udp.server.ipv4.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -437,16 +450,15 @@ udp_option : T_IPV4_ADDR T_IP
 		break;
 	}
 	free($2);
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
+	channel_conf->u.udp.ipproto = AF_INET;
 };
 
 udp_option : T_IPV6_ADDR T_IP
 {
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 	int err;
 
-	err = inet_pton(AF_INET6, $2,
-			&conf.channel[conf.channel_num].u.udp.server.ipv6);
+	err = inet_pton(AF_INET6, $2, &channel_conf->u.udp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		free($2);
@@ -457,14 +469,12 @@ udp_option : T_IPV6_ADDR T_IP
 	}
 
 	free($2);
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	channel_conf->u.udp.ipproto = AF_INET6;
 };
 
 udp_option : T_IPV4_DEST_ADDR T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.udp.client.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -472,16 +482,15 @@ udp_option : T_IPV4_DEST_ADDR T_IP
 		break;
 	}
 	free($2);
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET;
+	channel_conf->u.udp.ipproto = AF_INET;
 };
 
 udp_option : T_IPV6_DEST_ADDR T_IP
 {
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 	int err;
 
-	err = inet_pton(AF_INET6, $2,
-			&conf.channel[conf.channel_num].u.udp.client);
+	err = inet_pton(AF_INET6, $2, &channel_conf->u.udp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		free($2);
@@ -492,15 +501,15 @@ udp_option : T_IPV6_DEST_ADDR T_IP
 	}
 
 	free($2);
-	conf.channel[conf.channel_num].u.udp.ipproto = AF_INET6;
+	channel_conf->u.udp.ipproto = AF_INET6;
 };
 
 udp_option : T_IFACE T_STRING
 {
+	struct channel_conf *channel_conf = conf_get_channel();
 	int idx;
 
-	__max_dedicated_links_reached();
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(channel_conf->channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
@@ -508,43 +517,50 @@ udp_option : T_IFACE T_STRING
 		free($2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.udp.server.ipv6.scope_id = idx;
+	channel_conf->u.udp.server.ipv6.scope_id = idx;
 
 	free($2);
 };
 
 udp_option : T_PORT T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.port = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.udp.port = $2;
 };
 
 udp_option: T_SNDBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.sndbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.udp.sndbuf = $2;
 };
 
 udp_option: T_RCVBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.rcvbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.udp.rcvbuf = $2;
 };
 
-udp_option: T_CHECKSUM T_ON 
+udp_option: T_CHECKSUM T_ON
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.checksum = 0;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.udp.checksum = 0;
 };
 
 udp_option: T_CHECKSUM T_OFF
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.udp.checksum = 1;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.udp.checksum = 1;
 };
 
 tcp_line : T_TCP '{' tcp_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_TCP) {
 		dlog(LOG_ERR, "cannot use `TCP' with other "
@@ -552,15 +568,17 @@ tcp_line : T_TCP '{' tcp_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED |
-						       CHANNEL_F_STREAM |
-						       CHANNEL_F_ERRORS;
+	channel_conf->channel_type = CHANNEL_TCP;
+	channel_conf->channel_flags = CHANNEL_F_BUFFERED |
+				      CHANNEL_F_STREAM |
+				      CHANNEL_F_ERRORS;
 	conf.channel_num++;
 };
 
 tcp_line : T_TCP T_DEFAULT '{' tcp_options '}'
 {
+	struct channel_conf *channel_conf = conf_get_channel();
+
 	if (conf.channel_type_global != CHANNEL_NONE &&
 	    conf.channel_type_global != CHANNEL_TCP) {
 		dlog(LOG_ERR, "cannot use `TCP' with other "
@@ -568,11 +586,11 @@ tcp_line : T_TCP T_DEFAULT '{' tcp_options '}'
 		exit(EXIT_FAILURE);
 	}
 	conf.channel_type_global = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_type = CHANNEL_TCP;
-	conf.channel[conf.channel_num].channel_flags = CHANNEL_F_DEFAULT |
-						       CHANNEL_F_BUFFERED |
-						       CHANNEL_F_STREAM |
-						       CHANNEL_F_ERRORS;
+	channel_conf->channel_type = CHANNEL_TCP;
+	channel_conf->channel_flags = CHANNEL_F_DEFAULT |
+				      CHANNEL_F_BUFFERED |
+				      CHANNEL_F_STREAM |
+				      CHANNEL_F_ERRORS;
 	conf.channel_default = conf.channel_num;
 	conf.channel_num++;
 };
@@ -582,9 +600,7 @@ tcp_options :
 
 tcp_option : T_IPV4_ADDR T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.tcp.server.ipv4.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -592,16 +608,15 @@ tcp_option : T_IPV4_ADDR T_IP
 		break;
 	}
 	free($2);
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	channel_conf->u.tcp.ipproto = AF_INET;
 };
 
 tcp_option : T_IPV6_ADDR T_IP
 {
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 	int err;
 
-	err = inet_pton(AF_INET6, $2,
-			&conf.channel[conf.channel_num].u.tcp.server.ipv6);
+	err = inet_pton(AF_INET6, $2, &channel_conf->u.tcp.server.ipv6);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		free($2);
@@ -612,14 +627,12 @@ tcp_option : T_IPV6_ADDR T_IP
 	}
 
 	free($2);
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	channel_conf->u.tcp.ipproto = AF_INET6;
 };
 
 tcp_option : T_IPV4_DEST_ADDR T_IP
 {
-	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
-
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 
 	if (!inet_aton($2, &channel_conf->u.tcp.client.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
@@ -627,16 +640,15 @@ tcp_option : T_IPV4_DEST_ADDR T_IP
 		break;
 	}
 	free($2);
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET;
+	channel_conf->u.tcp.ipproto = AF_INET;
 };
 
 tcp_option : T_IPV6_DEST_ADDR T_IP
 {
-	__max_dedicated_links_reached();
+	struct channel_conf *channel_conf = conf_get_channel();
 	int err;
 
-	err = inet_pton(AF_INET6, $2,
-			&conf.channel[conf.channel_num].u.tcp.client);
+	err = inet_pton(AF_INET6, $2, &channel_conf->u.tcp.client);
 	if (err == 0) {
 		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
 		free($2);
@@ -647,15 +659,15 @@ tcp_option : T_IPV6_DEST_ADDR T_IP
 	}
 
 	free($2);
-	conf.channel[conf.channel_num].u.tcp.ipproto = AF_INET6;
+	channel_conf->u.tcp.ipproto = AF_INET6;
 };
 
 tcp_option : T_IFACE T_STRING
 {
+	struct channel_conf *channel_conf = conf_get_channel();
 	int idx;
 
-	__max_dedicated_links_reached();
-	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ);
+	strncpy(channel_conf->channel_ifname, $2, IFNAMSIZ);
 
 	idx = if_nametoindex($2);
 	if (!idx) {
@@ -663,44 +675,48 @@ tcp_option : T_IFACE T_STRING
 		free($2);
 		break;
 	}
-	conf.channel[conf.channel_num].u.tcp.server.ipv6.scope_id = idx;
+	channel_conf->u.tcp.server.ipv6.scope_id = idx;
 
 	free($2);
 };
 
 tcp_option : T_PORT T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.port = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.tcp.port = $2;
 };
 
 tcp_option: T_SNDBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.sndbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.tcp.sndbuf = $2;
 };
 
 tcp_option: T_RCVBUFF T_NUMBER
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.rcvbuf = $2;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.tcp.rcvbuf = $2;
 };
 
-tcp_option: T_CHECKSUM T_ON 
+tcp_option: T_CHECKSUM T_ON
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.checksum = 0;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.tcp.checksum = 0;
 };
 
 tcp_option: T_CHECKSUM T_OFF
 {
-	__max_dedicated_links_reached();
-	conf.channel[conf.channel_num].u.tcp.checksum = 1;
+	struct channel_conf *channel_conf = conf_get_channel();
+
+	channel_conf->u.tcp.checksum = 1;
 };
 
 tcp_option: T_ERROR_QUEUE_LENGTH T_NUMBER
 {
-	__max_dedicated_links_reached();
 	CONFIG(channelc).error_queue_length = $2;
 };
 
@@ -1724,15 +1740,6 @@ static void __kernel_filter_add_state(int value)
 			     &filter_proto);
 }
 
-static void __max_dedicated_links_reached(void)
-{
-	if (conf.channel_num >= MULTICHANNEL_MAX) {
-		dlog(LOG_ERR, "too many dedicated links in the configuration "
-		     "file (Maximum: %d)", MULTICHANNEL_MAX);
-		exit(EXIT_FAILURE);
-	}
-}
-
 int
 init_config(char *filename)
 {
-- 
2.30.2

