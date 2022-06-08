Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E9DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbiFHQ1q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245461AbiFHQ1q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D221FBF60
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=feC1HDBXfH5kMjQKSMfQv04Kv5hP1mPZIY7x0pQcupY=; b=g/uVY6HS/3PLl5uUh2hW5ucrjM
        bH03iZv/eQSuII1F8TX70EuqaU7iUH9eey/tDrOEaKoMUBNDuseMmPmMs4Zv34JcfSr9HS+5eqD3a
        0aFZjIOrC2QMyVVqj1ySGhSYC3oVdYoHrbE9+exIU8k2zqEtzexvbPINgpyLO93eIY1tQ+yrenqeF
        I19JzDeB7teTzL5LXk9fGNqdB9EgMWGTlK0urZ8WU/RCwrswuJpCl3qtKfExugZAdxrcHII054Wcg
        MoYKYQ5ut3pi9r9hAm1oMeL24uo/uAxbMjyktYTU/2S/vdbHFWz1IjiFAgb1np14VayJ2lFZtTGUB
        dr2zsPKQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyX0-000859-UU
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/9] tests: shell: Add some more rules to 0002-verbose-output_0
Date:   Wed,  8 Jun 2022 18:27:05 +0200
Message-Id: <20220608162712.31202-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This increases coverage of function print_match() from 0 to 86.6%.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/ip6tables/0002-verbose-output_0     | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index 7b0e64686c6b6..7624cbab655ad 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -9,12 +9,24 @@ RULE1='-i eth2 -o eth3 -s feed:babe::1 -d feed:babe::2 -j ACCEPT'
 VOUT1='ACCEPT  all opt    in eth2 out eth3  feed:babe::1  -> feed:babe::2'
 RULE2='-i eth2 -o eth3 -s feed:babe::4 -d feed:babe::5 -j ACCEPT'
 VOUT2='ACCEPT  all opt    in eth2 out eth3  feed:babe::4  -> feed:babe::5'
+RULE3='-p icmpv6 -m icmp6 --icmpv6-type no-route'
+VOUT3='  ipv6-icmp opt    in * out *  ::/0  -> ::/0   ipv6-icmptype 1 code 0'
+RULE4='-m dst --dst-len 42 -m rt --rt-type 23'
+VOUT4='  all opt    in * out *  ::/0  -> ::/0   dst length:42  rt type:23'
+RULE5='-m frag --fragid 1337 -j LOG'
+VOUT5='LOG  all opt    in * out *  ::/0  -> ::/0   frag id:1337 LOG flags 0 level 4'
 
 diff -u -Z <(echo -e "$VOUT1") <($XT_MULTI ip6tables -v -A FORWARD $RULE1)
 diff -u -Z <(echo -e "$VOUT2") <($XT_MULTI ip6tables -v -I FORWARD 2 $RULE2)
+diff -u -Z <(echo -e "$VOUT3") <($XT_MULTI ip6tables -v -A FORWARD $RULE3)
+diff -u -Z <(echo -e "$VOUT4") <($XT_MULTI ip6tables -v -A FORWARD $RULE4)
+diff -u -Z <(echo -e "$VOUT5") <($XT_MULTI ip6tables -v -A FORWARD $RULE5)
 
 diff -u -Z <(echo -e "$VOUT1") <($XT_MULTI ip6tables -v -C FORWARD $RULE1)
 diff -u -Z <(echo -e "$VOUT2") <($XT_MULTI ip6tables -v -C FORWARD $RULE2)
+diff -u -Z <(echo -e "$VOUT3") <($XT_MULTI ip6tables -v -C FORWARD $RULE3)
+diff -u -Z <(echo -e "$VOUT4") <($XT_MULTI ip6tables -v -C FORWARD $RULE4)
+diff -u -Z <(echo -e "$VOUT5") <($XT_MULTI ip6tables -v -C FORWARD $RULE5)
 
 EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
@@ -23,6 +35,9 @@ Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
     0     0 ACCEPT     all      eth2   eth3    feed:babe::1         feed:babe::2
     0     0 ACCEPT     all      eth2   eth3    feed:babe::4         feed:babe::5
+    0     0            ipv6-icmp    *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
+    0     0            all      *      *       ::/0                 ::/0                 dst length:42  rt type:23
+    0     0 LOG        all      *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
-- 
2.34.1

