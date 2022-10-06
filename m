Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67990C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJFANb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFANb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:13:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A4E326CB
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=918kYpXc/ikhha8B5G3bP/vHQaEY7C6JRaECEfQe3xg=; b=KqCrntINYJbBj+QJZHedDTuf+N
        tPyAWn4rq5OSoGF21NUXYWvJF6c151gGHnmfyQGcxtwrWJk9mL6LLFYXUUh8jY+tL8F9A/ci6xPpW
        c5wIiT01e5T8aM9DQR/XCChwb39xWVbS8G3Dr/cv+n+NdjTuViMZAojeM4gzbEhhChnDkQtIZk8fX
        BeO+bV/+sbTLX+yxsrIA8pp+KrD0/3lrMzFv4th5Q+tAZNrinCN3oVaVP9U3P5kHLeJwol/gQfXGz
        TA/iY/Q6XbA1JmLtt0kPGxxRS3ElsEUuFmZx9cjtCYs78gOg/utisD77UHZ6vahMfS0SiMgGjpaKQ
        StiJOE+Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEVz-0001mh-Qg
        for netfilter-devel@vger.kernel.org; Thu, 06 Oct 2022 02:13:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] tests: shell: Fix expected output for ip6tables dst match
Date:   Thu,  6 Oct 2022 02:13:18 +0200
Message-Id: <20221006001319.24644-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Forgot to update the shell testsuites when fixing for duplicate
whitespace in output.

Fixes: 11e06cbb3a877 ("extensions: libip6t_dst: Fix output for empty options")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/ip6tables/0002-verbose-output_0     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index 2a1518d6fb0de..cc18a94b96986 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -12,7 +12,7 @@ VOUT2='ACCEPT  all opt -- in eth2 out eth3  feed:babe::4  -> feed:babe::5'
 RULE3='-p icmpv6 -m icmp6 --icmpv6-type no-route'
 VOUT3='  ipv6-icmp opt -- in * out *  ::/0  -> ::/0   ipv6-icmptype 1 code 0'
 RULE4='-m dst --dst-len 42 -m rt --rt-type 23'
-VOUT4='  all opt -- in * out *  ::/0  -> ::/0   dst length:42  rt type:23'
+VOUT4='  all opt -- in * out *  ::/0  -> ::/0   dst length:42 rt type:23'
 RULE5='-m frag --fragid 1337 -j LOG'
 VOUT5='LOG  all opt -- in * out *  ::/0  -> ::/0   frag id:1337 LOG flags 0 level 4'
 
@@ -36,7 +36,7 @@ Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
     0     0 ACCEPT     0    --  eth2   eth3    feed:babe::1         feed:babe::2
     0     0 ACCEPT     0    --  eth2   eth3    feed:babe::4         feed:babe::5
     0     0            58   --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
-    0     0            0    --  *      *       ::/0                 ::/0                 dst length:42  rt type:23
+    0     0            0    --  *      *       ::/0                 ::/0                 dst length:42 rt type:23
     0     0 LOG        0    --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
-- 
2.34.1

