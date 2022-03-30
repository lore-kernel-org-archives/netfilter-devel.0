Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5951DC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348473AbiC3QBC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347877AbiC3QBB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD38D5
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/prMOZLyFvdUZFub4dQQbNSvk34gfrUfnBnxqHsG+3s=; b=A4+AW8yHAQL5yPpIlidZuP8MAs
        anNVul9x71V45ic4Odus7mjfTTq3Cb9dSRw/PaWjdraowVj19TrTtHCsGySZ19Ou1Ag/c6vftVBSR
        EeqPWyjWeZVAxtyXjRYJqLIoWlH/A/dW6T3HxWNLlM7+CncvjieaRjp5BCJKTJjST2etMTC+es2z0
        a6cmIAHh+BIb7kFZnNclz+xRvbcvn9Z5UeE5DJPiT7zFq+I21h7yPJlD8Nq9AvS48LwMNgBamIn+A
        //nsOWCDbh4KelcyDusSUJf7NjVBI+qeA80W+0NgX4q+zEjURzMKZUd+xByFzVEMeMz/E9crLa21W
        e9XCc98A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZaj4-0004XM-Su; Wed, 30 Mar 2022 17:59:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/9] man: DNAT: Describe shifted port range feature
Date:   Wed, 30 Mar 2022 17:58:43 +0200
Message-Id: <20220330155851.13249-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330155851.13249-1-phil@nwl.cc>
References: <20220330155851.13249-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This wasn't mentioned anywhere.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.man | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index c3daea9a40394..e044c8216fc09 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -10,7 +10,7 @@ should be modified (and all future packets in this connection will
 also be mangled), and rules should cease being examined.  It takes the
 following options:
 .TP
-\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP[\fB/\fIbaseport\fP]]]
 which can specify a single new destination IP address, an inclusive
 range of IP addresses. Optionally a port range,
 if the rule also specifies one of the following protocols:
@@ -18,6 +18,9 @@ if the rule also specifies one of the following protocols:
 If no port range is specified, then the destination port will never be
 modified. If no IP address is specified then only the destination port
 will be modified.
+If \fBbaseport\fP is given, the difference of the original destination port and
+its value is used as offset into the mapping port range. This allows to create
+shifted portmap ranges and is available since kernel version 4.18.
 .TP
 \fB\-\-random\fP
 If option
-- 
2.34.1

