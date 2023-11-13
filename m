Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8FEC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjKMKc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjKMKcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:25 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836EF10C9
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id DCB2C58725FD6; Mon, 13 Nov 2023 11:32:16 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id D050D58725FD8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:14 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/7] man: repeal manual hyphenation
Date:   Mon, 13 Nov 2023 11:30:08 +0100
Message-ID: <20231113103156.57745-4-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/arptables-nft.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 659a2542..84775a86 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -303,8 +303,8 @@ Mangles Destination MAC Address to given value.
 Target of ARP mangle operation
 .BR "" ( DROP ", " CONTINUE " or " ACCEPT " -- default is " ACCEPT ).
 .SS CLASSIFY
-This  module  allows you to set the skb->priority value (and thus clas-
-sify the packet into a specific CBQ class).
+This module allows you to set the skb->priority value (and thus
+classify the packet into a specific CBQ class).
 
 .TP
 .BR "--set-class major:minor"
-- 
2.42.1

