Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A627EC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 17:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCJRts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 12:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjCJRtp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 12:49:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2A3130C18
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 09:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=560TdoqOY7FwGW43ikOb6lbnnRFF/3SSTSpeYsHKP0k=; b=mGlj/g2M1E1J8VU9BFodw3zfu1
        SvTf5FjWUFjEoGw/YoutD02eUxc2avXDak9b/mAjuEo/dotrsGz14Iev2bS9aGWM8qv1Vi9kwCJhz
        WufB19F0pdsj/PK/vWXtl7UHBrW1uyU9SF6rQ8knjEYS41Lap8tFYbP73O78KK5OqzFNQJDZgTEma
        Zxwl9b5Ecf8ogWLZoO6kEuOhj6wexVZXspTi+m0WJYgW/UW/Kp80lF0qcZ6xkiw9KhC7QwoHednyF
        7F255ixWm+r8gcVKwwC43jv591ywMwcHFnNbpDzXp2U7hEnF9PVLipxJIU3CQ85gDjVtw6aqRtKj4
        hWKaLcFw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pagrg-00060r-8c; Fri, 10 Mar 2023 18:49:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH] tests: hash:ip,port.t: Replace VRRP by GRE protocol
Date:   Fri, 10 Mar 2023 18:49:03 +0100
Message-Id: <20230310174903.5089-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some systems may not have "vrrp" as alias to "carp" yet, so use a
protocol which is less likely to cause problems for testing purposes.

Fixes: a67aa712ed912 ("tests: hash:ip,port.t: 'vrrp' is printed as 'carp'")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/hash:ip,port.t       | 8 ++++----
 tests/hash:ip,port.t.list2 | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/hash:ip,port.t b/tests/hash:ip,port.t
index addbe3be1f787..f65fb59116824 100644
--- a/tests/hash:ip,port.t
+++ b/tests/hash:ip,port.t
@@ -62,10 +62,10 @@
 0 ipset test test 2.0.0.1,tcp:80
 # Test element with UDP protocol
 0 ipset test test 2.0.0.1,udp:80
-# Add element with vrrp
-0 ipset add test 2.0.0.1,vrrp:0
-# Test element with vrrp
-0 ipset test test 2.0.0.1,vrrp:0
+# Add element with GRE
+0 ipset add test 2.0.0.1,gre:0
+# Test element with GRE
+0 ipset test test 2.0.0.1,gre:0
 # Add element with sctp
 0 ipset add test 2.0.0.1,sctp:80
 # Test element with sctp
diff --git a/tests/hash:ip,port.t.list2 b/tests/hash:ip,port.t.list2
index 0c5d3a15ef369..25504227d4fd7 100644
--- a/tests/hash:ip,port.t.list2
+++ b/tests/hash:ip,port.t.list2
@@ -6,6 +6,6 @@ Size in memory: 480
 References: 0
 Number of entries: 3
 Members:
-2.0.0.1,carp:0
+2.0.0.1,gre:0
 2.0.0.1,tcp:80
 2.0.0.1,udp:80
-- 
2.38.0

