Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F647C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 13:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCGN6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCGN6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 08:58:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3130D2
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 05:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hLaP8JqMLuFPtaAwPpU1IdFHuRE8l4ORmbU48OaQFws=; b=RvHB7wvVyI+PxGTl4m34hdlgWm
        hv8WN6GZwC+H1XRq/awhxVjK1QRgNhNglDXA96eK6eiMkLXxfBWMDDU5lIzAPIy5XRsC8ZOE5EAQV
        NLAoiju/SYVhixiNbD1Anbtzxp/WLjaqmJZVYkgleOrqvojQeEGs6WqC5AGS4lTYpoFY7NucSR9KE
        zkQ6KXoUco4JEhdjBNsMI3wIWAt50JnZHiJsV1I36fnQ1XbB6A4Zt3QLWvGKRId9uPGTVKsswk4jz
        WMg58ZQ942yyFkTCJhuYa036WWNOKsnAiLtdz2MYYltmmEpD865k7AuLuOu6kaLPr35b0/VP5izNC
        rjRV4Tng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pZXpx-00059v-UW; Tue, 07 Mar 2023 14:58:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH 2/4] tests: xlate: Make test input valid
Date:   Tue,  7 Mar 2023 14:58:10 +0100
Message-Id: <20230307135812.25993-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307135812.25993-1-phil@nwl.cc>
References: <20230307135812.25993-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make sure ipset at least accepts the test input by running it against
plain ipset once for sanity. This exposed two issues:

* Set 'hip5' doesn't have comment support, so add the commented elements
  to 'hip6' instead (likely a typo).
* Set 'bip1' range 2.0.0.1-2.1.0.1 exceeds the max allowed for bitmap
  sets. Reduce it accordingly.

Fixes: 7587d1c4b5465 ("tests: add tests ipset to nftables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/xlate/runtest.sh  | 10 ++++++++++
 tests/xlate/xlate.t     |  6 +++---
 tests/xlate/xlate.t.nft |  4 ++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tests/xlate/runtest.sh b/tests/xlate/runtest.sh
index 6a2f80c0d9e61..8b42f0b414d72 100755
--- a/tests/xlate/runtest.sh
+++ b/tests/xlate/runtest.sh
@@ -6,8 +6,18 @@ if [ ! -x "$DIFF" ] ; then
 	exit 1
 fi
 
+ipset=${IPSET_BIN:-../../src/ipset}
 ipset_xlate=${IPSET_XLATE_BIN:-$(dirname $0)/ipset-translate}
 
+$ipset restore < xlate.t
+rc=$?
+$ipset destroy
+if [ $rc -ne 0 ]
+then
+	echo -e "[\033[0;31mERROR\033[0m] invalid test input"
+	exit 1
+fi
+
 TMP=$(mktemp)
 $ipset_xlate restore < xlate.t &> $TMP
 if [ $? -ne 0 ]
diff --git a/tests/xlate/xlate.t b/tests/xlate/xlate.t
index f09cb202bb6c0..38cbc787bb854 100644
--- a/tests/xlate/xlate.t
+++ b/tests/xlate/xlate.t
@@ -11,8 +11,8 @@ add hip4 192.168.10.0
 create hip5 hash:ip maxelem 24
 add hip5 192.168.10.0
 create hip6 hash:ip comment
-add hip5 192.168.10.1
-add hip5 192.168.10.2 comment "this is a comment"
+add hip6 192.168.10.1
+add hip6 192.168.10.2 comment "this is a comment"
 create ipp1 hash:ip,port
 add ipp1 192.168.10.1,0
 add ipp1 192.168.10.2,5
@@ -23,7 +23,7 @@ create ipp3 hash:ip,port counters
 add ipp3 192.168.10.3,20 packets 5 bytes 3456
 create ipp4 hash:ip,port timeout 4 counters
 add ipp4 192.168.10.3,20 packets 5 bytes 3456
-create bip1 bitmap:ip range 2.0.0.1-2.1.0.1 timeout 5
+create bip1 bitmap:ip range 2.0.0.1-2.0.1.1 timeout 5
 create bip2 bitmap:ip range 10.0.0.0/8 netmask 24 timeout 5
 add bip2 10.10.10.0
 add bip2 10.10.20.0 timeout 12
diff --git a/tests/xlate/xlate.t.nft b/tests/xlate/xlate.t.nft
index 0152a30811258..8fb2a29b9c79f 100644
--- a/tests/xlate/xlate.t.nft
+++ b/tests/xlate/xlate.t.nft
@@ -12,8 +12,8 @@ add element inet global hip4 { 192.168.10.0/24 }
 add set inet global hip5 { type ipv4_addr; size 24; }
 add element inet global hip5 { 192.168.10.0 }
 add set inet global hip6 { type ipv4_addr; }
-add element inet global hip5 { 192.168.10.1 }
-add element inet global hip5 { 192.168.10.2 comment "this is a comment" }
+add element inet global hip6 { 192.168.10.1 }
+add element inet global hip6 { 192.168.10.2 comment "this is a comment" }
 add set inet global ipp1 { type ipv4_addr . inet_proto . inet_service; }
 add element inet global ipp1 { 192.168.10.1 . tcp . 0 }
 add element inet global ipp1 { 192.168.10.2 . tcp . 5 }
-- 
2.38.0

