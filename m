Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16EBC83F18
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Aug 2023 16:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjHZQcy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Aug 2023 12:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjHZQcu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2023 12:32:50 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A0171A
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2023 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kZ7RQ9HpOgaOAAvpxFzYq/VP4NfeZzhiZEGshOzY/YA=; b=K17lOxygXAbXC+AlmO8MtoXOv2
        uo3JUN7cRrapuLoFMehRQ/GUmhxVXmI4rFeV5jHIh6c6VQB5rUMQhu68LP9ae0+NBYqvQgaYH5Vkc
        R3qaqNVfY3ArFXxgkdeLUhvLNg3y61ZJWfMGs+dfVJNn3DV2ELFf5ZWnWzszMPMsaQ9/p9CGSjabD
        Rduv3xB7yPBNAA7l127Tz46iL3G4krqYfrSpYUdRI7gRM5XO4qy/6DlY91kdmUmUNcFCy7vWJ0oJM
        KxEvlI1CAGZMTEmGSTN4JsyalPvghqOP78aE3Z2rgSbuAoHZfW4miKhRX2TKLinFQxQkzupZi0YmQ
        A5Elc33Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qZwDJ-00DpTC-18
        for netfilter-devel@vger.kernel.org;
        Sat, 26 Aug 2023 17:32:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH conntrack-tools 4/4] read_config_yy: correct arguments passed to `inet_aton`
Date:   Sat, 26 Aug 2023 17:32:26 +0100
Message-Id: <20230826163226.1104220-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230826163226.1104220-1-jeremy@azazel.net>
References: <20230826163226.1104220-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`inet_aton` expects a `struct in_addr *`.  In a number of calls, we pass
pointers to structs or unions which contain a `struct in_addr` member.  Pass
pointers to the members instead.  In another call, we pass a pointer to a
uint32_t.  Cast it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/read_config_yy.y | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index be927c049056..d9b02ab37c5a 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -246,9 +246,11 @@ multicast_options :
 
 multicast_option : T_IPV4_ADDR T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
+	if (!inet_aton($2, &channel_conf->u.mcast.in.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -310,9 +312,11 @@ multicast_option : T_IPV6_ADDR T_IP
 
 multicast_option : T_IPV4_IFACE T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.ifa)) {
+	if (!inet_aton($2, &channel_conf->u.mcast.ifa.interface_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -423,9 +427,11 @@ udp_options :
 
 udp_option : T_IPV4_ADDR T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.server.ipv4)) {
+	if (!inet_aton($2, &channel_conf->u.udp.server.ipv4.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -456,9 +462,11 @@ udp_option : T_IPV6_ADDR T_IP
 
 udp_option : T_IPV4_DEST_ADDR T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.udp.client)) {
+	if (!inet_aton($2, &channel_conf->u.udp.client.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -574,9 +582,11 @@ tcp_options :
 
 tcp_option : T_IPV4_ADDR T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.server.ipv4)) {
+	if (!inet_aton($2, &channel_conf->u.tcp.server.ipv4.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -607,9 +617,11 @@ tcp_option : T_IPV6_ADDR T_IP
 
 tcp_option : T_IPV4_DEST_ADDR T_IP
 {
+	struct channel_conf *channel_conf = &conf.channel[conf.channel_num];
+
 	__max_dedicated_links_reached();
 
-	if (!inet_aton($2, &conf.channel[conf.channel_num].u.tcp.client)) {
+	if (!inet_aton($2, &channel_conf->u.tcp.client.inet_addr)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4 address", $2);
 		free($2);
 		break;
@@ -1239,7 +1251,7 @@ filter_address_item : T_IPV4_ADDR T_IP
 		}
 	}
 
-	if (!inet_aton($2, &ip.ipv4)) {
+	if (!inet_aton($2, (struct in_addr *) &ip.ipv4)) {
 		dlog(LOG_WARNING, "%s is not a valid IPv4, ignoring", $2);
 		free($2);
 		break;
-- 
2.40.1

