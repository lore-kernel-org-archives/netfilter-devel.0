Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FDDC3F6B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 11:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiG1Lb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiG1Lby (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 07:31:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799814AD7C
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 04:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KYfJwWqnM+fbpc7GkEelK0QkTPh5TXV7bGwVOxp4y4w=; b=Px5Y7+2fk280aK53aaXUnC2G6w
        +EYdBWJddoeao3AOso2TnrCalxVz+En1hRjgWaW8TC/Xz5+HmilR9YKCO8s/hkmoYVb/Nn5Eu+YQ5
        jfEoyxVdFWIPZlcE7Ph4T5hcMBWfV5VvlFgiihG5WBjlYVH/lmoNnULGSN3unSRq6CP4L2nOZzRJH
        6IOkrbv1YJ290RJwN+Abap3i5C86+Zi19CYAHQ5UOJaBWtXfWXNSd2fVK1pUywbq91Liupi198bN0
        QnyMl8s2zJF533zdz63y+ScP/eAkhychAomeEKtwNxz22eTlOckz+unHoyHHQYeLgHAg4eFw5Coy/
        eKz3bkqw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oH1k1-0001rB-Gd; Thu, 28 Jul 2022 13:31:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Erik Skultety <eskultet@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 1/3] tests: shell: Fix testcases for changed ip6tables opts output
Date:   Thu, 28 Jul 2022 13:31:34 +0200
Message-Id: <20220728113136.24376-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust captured output, ip6tables prints '--' instead of spaces since
the commit in Fixes: tag.

Fixes: 6e41c2d8747b2 ("iptables: xshared: Ouptut '--' in the opt field in ipv6's fake mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/ip6tables/0002-verbose-output_0 | 20 +++++++++----------
 .../ipt-restore/0014-verbose-restore_0        |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index 7624cbab655ad..4e754156ba589 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -6,15 +6,15 @@ set -e
 # ensure verbose output is identical between legacy and nft tools
 
 RULE1='-i eth2 -o eth3 -s feed:babe::1 -d feed:babe::2 -j ACCEPT'
-VOUT1='ACCEPT  all opt    in eth2 out eth3  feed:babe::1  -> feed:babe::2'
+VOUT1='ACCEPT  all opt -- in eth2 out eth3  feed:babe::1  -> feed:babe::2'
 RULE2='-i eth2 -o eth3 -s feed:babe::4 -d feed:babe::5 -j ACCEPT'
-VOUT2='ACCEPT  all opt    in eth2 out eth3  feed:babe::4  -> feed:babe::5'
+VOUT2='ACCEPT  all opt -- in eth2 out eth3  feed:babe::4  -> feed:babe::5'
 RULE3='-p icmpv6 -m icmp6 --icmpv6-type no-route'
-VOUT3='  ipv6-icmp opt    in * out *  ::/0  -> ::/0   ipv6-icmptype 1 code 0'
+VOUT3='  ipv6-icmp opt -- in * out *  ::/0  -> ::/0   ipv6-icmptype 1 code 0'
 RULE4='-m dst --dst-len 42 -m rt --rt-type 23'
-VOUT4='  all opt    in * out *  ::/0  -> ::/0   dst length:42  rt type:23'
+VOUT4='  all opt -- in * out *  ::/0  -> ::/0   dst length:42  rt type:23'
 RULE5='-m frag --fragid 1337 -j LOG'
-VOUT5='LOG  all opt    in * out *  ::/0  -> ::/0   frag id:1337 LOG flags 0 level 4'
+VOUT5='LOG  all opt -- in * out *  ::/0  -> ::/0   frag id:1337 LOG flags 0 level 4'
 
 diff -u -Z <(echo -e "$VOUT1") <($XT_MULTI ip6tables -v -A FORWARD $RULE1)
 diff -u -Z <(echo -e "$VOUT2") <($XT_MULTI ip6tables -v -I FORWARD 2 $RULE2)
@@ -33,11 +33,11 @@ EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 
 Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
-    0     0 ACCEPT     all      eth2   eth3    feed:babe::1         feed:babe::2
-    0     0 ACCEPT     all      eth2   eth3    feed:babe::4         feed:babe::5
-    0     0            ipv6-icmp    *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
-    0     0            all      *      *       ::/0                 ::/0                 dst length:42  rt type:23
-    0     0 LOG        all      *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
+    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::1         feed:babe::2
+    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::4         feed:babe::5
+    0     0            ipv6-icmp--  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
+    0     0            all  --  *      *       ::/0                 ::/0                 dst length:42  rt type:23
+    0     0 LOG        all  --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
diff --git a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0 b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
index 5daf7a78a5334..087156b121be0 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
@@ -60,7 +60,7 @@ Flushing chain \`OUTPUT'
 Flushing chain \`secfoo'
 Deleting chain \`secfoo'"
 
-EXPECT6=$(sed -e 's/0\.0\.0\.0/::/g' -e 's/opt --/opt   /' <<< "$EXPECT")
+EXPECT6=$(sed -e 's/0\.0\.0\.0/::/g' <<< "$EXPECT")
 
 diff -u -Z <(echo "$EXPECT") <($XT_MULTI iptables-restore -v <<< "$DUMP")
 diff -u -Z <(echo "$EXPECT6") <($XT_MULTI ip6tables-restore -v <<< "$DUMP")
-- 
2.34.1

