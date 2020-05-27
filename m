Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA897C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BBD2088E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X53PQWEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgE0Uvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 16:51:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728571AbgE0Uvm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 16:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590612700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8zH8SFS1b68Pe85NsoesUk0EGtyyf56k1MMHtVM0u0=;
        b=X53PQWEvrrYxjnEtrgklWBaAwW9IxHslItc/EDSKL/N6SxZxqreW/DYQGvsMqJhAEXLVz5
        RTnWjvlccwvt6DOUOFqrzwGr8eiiCl6S/TOWwRMaIXS2veuoi7azuupg8AaqiKrs+SZWlo
        NBSVL6kgTau7tsldBaO+XT+gbV59XSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-cy3WZeUfO7m10x7CmL0qPg-1; Wed, 27 May 2020 16:51:38 -0400
X-MC-Unique: cy3WZeUfO7m10x7CmL0qPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 730651005510;
        Wed, 27 May 2020 20:51:37 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 287C779C4D;
        Wed, 27 May 2020 20:51:35 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2 2/2] tests: py: Enable anonymous set rule with concatenated ranges in inet/sets.t
Date:   Wed, 27 May 2020 22:51:22 +0200
Message-Id: <cc79c6979526343ba093815529434801b5c10fd6.1590612113.git.sbrivio@redhat.com>
In-Reply-To: <cover.1590612113.git.sbrivio@redhat.com>
References: <cover.1590612113.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 64b9aa3803dd ("tests/py: Add tests involving concatenated
ranges") introduced a rule, commented out, adding an anonymous set
including concatenated ranges. Now that they are properly handled,
we can enable it.

Note that this introduces a new warning. In the output below, '\'
marks newlines I introduced to keep lines short:

inet/sets.t: WARNING: line 24: \
'add rule inet test-inet input ip daddr . tcp dport \
{ 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept': \
'ip daddr . tcp dport \
{ 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept' \
mismatches 'meta nfproto ipv4 ip daddr . tcp dport \
{ 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443} accept'

which is similar to the existing warning, also introduced by
commit 64b9aa3803dd:

inet/sets.t: WARNING: line 23: \
'add rule inet test-inet input \
ip saddr . ip daddr . tcp dport @set3 accept': \
'ip saddr . ip daddr . tcp dport @set3 accept' mismatches \
'meta nfproto ipv4 ip saddr . ip daddr . tcp dport @set3 accept'

This is mentioned in the commit message for 64b9aa3803dd itself:

    * Payload dependency killing ignores the concatenated IP header
      expressions on LHS, so rule output is asymmetric.

which means that for family inet, 'meta nfproto ipv4' is added to
the output of the rule, on top of what was passed as input, but not
for families bridge and netdev.

For this reason, it's not possible in this case to specify a single
expected output, differing from the input, and, also,
'meta nfproto ipv4' can only be passed as input for family inet as
it's not relevant for the other families.

As an alternative, we could split the rules from this test into
tests for the corresponding families, as this test case itself
is under the 'inet' directory, but I consider this beyond the scope
of this patchset.

v2: Enable rule in py/inet/sets.t instead of adding a new test in
    shell/sets (Phil Sutter)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/py/inet/sets.t                |  2 +-
 tests/py/inet/sets.t.payload.bridge | 14 ++++++++++++++
 tests/py/inet/sets.t.payload.inet   | 13 +++++++++++++
 tests/py/inet/sets.t.payload.netdev | 13 +++++++++++++
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/tests/py/inet/sets.t b/tests/py/inet/sets.t
index e0b0ee867f9b..1c6f32355acf 100644
--- a/tests/py/inet/sets.t
+++ b/tests/py/inet/sets.t
@@ -21,4 +21,4 @@ ip6 daddr @set1 drop;fail
 ?set3 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535;ok
 
 ip saddr . ip daddr . tcp dport @set3 accept;ok
--ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept;ok
+ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept;ok
diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index 089d9dd7a28d..92f5417c0bee 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -26,3 +26,17 @@ bridge
   [ lookup reg 1 set set3 ]
   [ immediate reg 0 accept ]
 
+# ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
+__set%d test-inet 87
+__set%d test-inet 0
+        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+bridge 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+  [ immediate reg 0 accept ]
+
diff --git a/tests/py/inet/sets.t.payload.inet b/tests/py/inet/sets.t.payload.inet
index c5acd6103a03..bd6e1b0fe19d 100644
--- a/tests/py/inet/sets.t.payload.inet
+++ b/tests/py/inet/sets.t.payload.inet
@@ -26,3 +26,16 @@ inet
   [ lookup reg 1 set set3 ]
   [ immediate reg 0 accept ]
 
+# ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
+__set%d test-inet 87
+__set%d test-inet 0
+        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+inet 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+  [ immediate reg 0 accept ]
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index 82994eabf48b..f3032d8ef4ab 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -26,3 +26,16 @@ inet
   [ lookup reg 1 set set3 ]
   [ immediate reg 0 accept ]
 
+# ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
+__set%d test-netdev 87
+__set%d test-netdev 0
+        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+  [ immediate reg 0 accept ]
-- 
2.26.2

