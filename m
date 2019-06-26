Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90223C48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 20:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6409B208E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 20:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFZUoV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 16:44:21 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.68]:38191 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfFZUoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 16:44:20 -0400
Received: from localhost.localdomain (unknown [47.62.206.189])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id D183581A8;
        Wed, 26 Jun 2019 22:44:16 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH v2 7/7] nftables: tests/py: More tests for day and hour
Date:   Wed, 26 Jun 2019 22:44:02 +0200
Message-Id: <20190626204402.5257-7-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626204402.5257-1-a@juaristi.eus>
References: <20190626204402.5257-1-a@juaristi.eus>
Reply-To: a@juaristi.eus
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I still have some problems to test the 'time' key.

It always prints one hour earlier than the introduced time,
even though it works perfectly when I introduce the same rules manually,
and there is code that specifically checks for that issue by checking TZ to UTC
and substracting the GMT offset accordingly. Maybe there is some issue with
env variables or localtime() in the Python test environment?

Need to investigate further.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 tests/py/ip/meta.t         |  2 ++
 tests/py/ip/meta.t.payload | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 02ba11d..dbcff48 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -5,6 +5,8 @@
 icmp type echo-request;ok
 meta day "Saturday" drop;ok;meta day "Saturday" drop
 meta hour "17:00" drop;ok;meta hour "17:00" drop
+meta hour "00:00" drop;ok
+meta hour "00:01" drop;ok
 meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
 meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index ad00a1a..be162cf 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -10,6 +10,18 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0000d2f0 0x00000000 ]
   [ immediate reg 0 drop ]
 
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

