From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/4] tests: add test entries for conntrack zones
Date: Tue, 28 Feb 2017 01:03:48 +0100
Message-ID: <1488240228-1536-4-git-send-email-pablo@netfilter.org>
References: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdB1CAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 21:00:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C86A4E646
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B19A1DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E92CEDA819
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:03:55 +0100 (CET)
In-Reply-To: <1488240228-1536-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Just a rebase on top of series to store byteorder for set data in
NFTA_SET_USERDATA.

 tests/py/any/ct.t         | 13 +++++++++++++
 tests/py/any/ct.t.payload | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 2cfbfe13ccd2..6f32d29c0c40 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -100,6 +100,19 @@ ct label 127;ok
 ct label set 127;ok
 ct label 128;fail
 
+ct zone 0;ok
+ct zone 23;ok
+ct zone 65536;fail
+ct both zone 1;fail
+ct original zone 1;ok
+ct reply zone 1;ok
+
+ct zone set 1;ok
+ct original zone set 1;ok
+ct reply zone set 1;ok
+ct zone set mark map { 1 : 1,  2 : 2 };ok;ct zone set mark map { 0x00000001 : 1, 0x00000002 : 2}
+ct both zone set 1;fail
+
 ct invalid;fail
 ct invalid original;fail
 ct set invalid original 42;fail
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 3370bcac0594..e4c7f62b69f5 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -402,6 +402,50 @@ ip test-ip4 output
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x80000000 ]
   [ ct set label with reg 1 ]
 
+# ct zone 0
+ip test-ip4 output
+  [ ct load zone => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ct zone 23
+ip test-ip4 output
+  [ ct load zone => reg 1 ]
+  [ cmp eq reg 1 0x00000017 ]
+
+# ct original zone 1
+ip test-ip4 output
+  [ ct load zone => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ct reply zone 1
+ip test-ip4 output
+  [ ct load zone => reg 1 , dir reply ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ct zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 ]
+
+# ct original zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 , dir original ]
+
+# ct reply zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 , dir reply ]
+
+# ct zone set mark map { 1 : 1,  2 : 2 }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 00000001  : 00000001 0 [end]    element 00000002  : 00000002 0 [end]
+ip test-ip4 output
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set zone with reg 1 ]
+
 # notrack
 ip test-ip4 output
   [ notrack ]
-- 
2.1.4

