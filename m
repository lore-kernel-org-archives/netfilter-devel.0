Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69971C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E5320874
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="O+5p5g39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370388AbgJVToj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:44:39 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44202 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370386AbgJVToi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 15:44:38 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4CHHr569DSzFtMr;
        Thu, 22 Oct 2020 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1603395877; bh=3/BwDmdYGliI1w1Nr06LUUsIKeJ2c7Etdj57Haz61RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+5p5g39m71GkJ2ktwgE36CnYc0xDKZrAavLGJlWC32QVd0JQHSyRptSsJrGJ68gz
         60YXlj6AJ+Tqu7cES1nF1eIoKBtSYnvWyOsRwCtnd0mTey1dHlgTWQeuBAk5cFGwiw
         U9ut6wItdKMTiM75KmpGA8tefG4djZt0WN3jaj1k=
X-Riseup-User-ID: 78E6A00FBB006FA7D9E143F81EB8EB6C860438519EB0E8307354B14D7696E230
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4CHHr50HY5z8sX6;
        Thu, 22 Oct 2020 12:44:36 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 5/5] tests: py: add netdev folder and reject.t icmp cases
Date:   Thu, 22 Oct 2020 21:43:55 +0200
Message-Id: <20201022194355.1816-6-guigom@riseup.net>
In-Reply-To: <20201022194355.1816-1-guigom@riseup.net>
References: <20201022194355.1816-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add unit tests for the use of reject with icmp inside netdev family.

reject.t from inet family couldn't be reused because it was using
meta nfproto which is not supported inside netdev.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 tests/py/netdev/reject.t         | 20 +++++++++++
 tests/py/netdev/reject.t.payload | 60 ++++++++++++++++++++++++++++++++
 tests/py/nft-test.py             |  2 +-
 3 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 tests/py/netdev/reject.t
 create mode 100644 tests/py/netdev/reject.t.payload

diff --git a/tests/py/netdev/reject.t b/tests/py/netdev/reject.t
new file mode 100644
index 00000000..a4434b6c
--- /dev/null
+++ b/tests/py/netdev/reject.t
@@ -0,0 +1,20 @@
+:ingress;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;ingress
+
+reject with icmp type host-unreachable;ok;reject
+reject with icmp type net-unreachable;ok;reject
+reject with icmp type prot-unreachable;ok;reject
+reject with icmp type port-unreachable;ok;reject
+reject with icmp type net-prohibited;ok;reject
+reject with icmp type host-prohibited;ok;reject
+reject with icmp type admin-prohibited;ok;reject
+
+reject with icmpv6 type no-route;ok;reject
+reject with icmpv6 type admin-prohibited;ok;reject
+reject with icmpv6 type addr-unreachable;ok;reject
+reject with icmpv6 type port-unreachable;ok;reject
+reject with icmpv6 type policy-fail;ok;reject
+reject with icmpv6 type reject-route;ok;reject
+
+reject;ok
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
new file mode 100644
index 00000000..71a66f9d
--- /dev/null
+++ b/tests/py/netdev/reject.t.payload
@@ -0,0 +1,60 @@
+# reject with icmp type host-unreachable
+netdev 
+  [ reject type 0 code 1 ]
+
+# reject
+netdev 
+  [ reject type 2 code 1 ]
+
+# reject
+netdev 
+  [ reject type 2 code 1 ]
+
+# reject with icmp type admin-prohibited
+netdev 
+  [ reject type 0 code 13 ]
+
+# reject with icmp type net-unreachable
+netdev 
+  [ reject type 0 code 0 ]
+
+# reject with icmp type prot-unreachable
+netdev 
+  [ reject type 0 code 2 ]
+
+# reject with icmp type port-unreachable
+netdev 
+  [ reject type 0 code 3 ]
+
+# reject with icmp type net-prohibited
+netdev 
+  [ reject type 0 code 9 ]
+
+# reject with icmp type host-prohibited
+netdev 
+  [ reject type 0 code 10 ]
+
+# reject with icmpv6 type no-route
+netdev 
+  [ reject type 0 code 0 ]
+
+# reject with icmpv6 type admin-prohibited
+netdev 
+  [ reject type 0 code 1 ]
+
+# reject with icmpv6 type addr-unreachable
+netdev 
+  [ reject type 0 code 3 ]
+
+# reject with icmpv6 type port-unreachable
+netdev 
+  [ reject type 0 code 4 ]
+
+# reject with icmpv6 type policy-fail
+netdev 
+  [ reject type 0 code 5 ]
+
+# reject with icmpv6 type reject-route
+netdev 
+  [ reject type 0 code 6 ]
+
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index e7b5e01e..7ca5a22a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -28,7 +28,7 @@ os.environ['TZ'] = 'UTC-2'
 
 from nftables import Nftables
 
-TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
+TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6", "netdev"]
 LOGFILE = "/tmp/nftables-test.log"
 log_file = None
 table_list = []
-- 
2.28.0

