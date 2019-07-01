Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66196C06510
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 20:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42AF5206A3
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 20:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfGAUQz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 16:16:55 -0400
Received: from fnsib-smtp06.srv.cat ([46.16.61.61]:60833 "EHLO
        fnsib-smtp06.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfGAUQz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 16:16:55 -0400
Received: from localhost.localdomain (unknown [47.62.206.189])
        by fnsib-smtp06.srv.cat (Postfix) with ESMTPSA id 16CACD9C58
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 22:16:52 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 3/4] tests/py: Add tests for 'time', 'day' and 'hour'
Date:   Mon,  1 Jul 2019 22:16:45 +0200
Message-Id: <20190701201646.7040-3-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190701201646.7040-1-a@juaristi.eus>
References: <20190701201646.7040-1-a@juaristi.eus>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 tests/py/ip/meta.t         |  9 +++++++
 tests/py/ip/meta.t.payload | 54 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 4db8835..b4c3ce9 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -3,6 +3,15 @@
 *ip;test-ip4;input
 
 icmp type echo-request;ok
+meta time "1970-05-23 21:07:14" drop;ok
+meta time "2019-06-21 17:00:00" drop;ok
+meta time "2019-07-01 00:00:00" drop;ok
+meta time "2019-07-01 00:01:00" drop;ok
+meta time "2019-07-01 00:00:01" drop;ok
+meta day "Saturday" drop;ok;meta day "Saturday" drop
+meta hour "17:00" drop;ok;meta hour "17:00" drop
+meta hour "00:00" drop;ok
+meta hour "00:01" drop;ok
 meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
 meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 322c087..fdf81d2 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -1,3 +1,57 @@
+# meta time "1970-05-23 21:07:14" drop
+ip meta-test
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x00bc4ff2 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-06-21 17:00:00" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x5d0cff00 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:00:00" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x5d193ef0 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:01:00" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x5d193f2c 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:00:01" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x5d193ef1 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta day "Saturday" drop
+ip test-ip4 input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "17:00" drop
+ip test-ip4 input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x0000d2f0 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "00:00" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x00013560 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "00:01" drop
+ip meta-test input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x0001359c 0x00000000 ]
+  [ immediate reg 0 drop ]
+
 # icmp type echo-request
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-- 
2.17.1

