Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D0BC19F21
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 11:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbiG1LcA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiG1Lb7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 07:31:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A214B4AD71
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 04:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rYAnH2AWUKnHCWa8yLblxlgyi14VUh3b2t6BgFEEkhw=; b=PMzJqHcqZP7WPcQTlnReEF6g7u
        ce6MLf3Hfew1r2RcX0TKjSOqnDtBxVYP8Sd1oogGPjYxcj8E2m0XrDiq7255+Jw6PK65CIxQ4tLBI
        Ks9nUzd0zoiOykkeeSrHrcsaYxlmtWiuNmS7+QZedmF5Jpi3JHdhgPNuWX9+vcmHIDKl2H4ZydnfF
        +TOUEYYk46WvpPMUJMNWFB4XeqgqczssoKvj9aqlcFb9RQFV5T50u+Omdl+N+rhC0s0TrCTylP/1a
        SzNDcloGI97wFTozbcIU+f23rZorrAjWr6JxOcIv9jHsfW8ss7nk8Ouo5DQLywWJWFQ71HifUuNjx
        IxT50rcA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oH1kC-0001rN-8B; Thu, 28 Jul 2022 13:31:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Erik Skultety <eskultet@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 3/3] xshared: Print protocol numbers if --numeric was given
Date:   Thu, 28 Jul 2022 13:31:36 +0200
Message-Id: <20220728113136.24376-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728113136.24376-1-phil@nwl.cc>
References: <20220728113136.24376-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is much trickier than expected: On one hand, proto_to_name() is
used to lookup protocol extensions so must resolve despite FMT_NUMERIC
being set. On the other, --verbose implies --numeric but changing the
output there is probably a bad idea. Luckily the latter situation is
identified by FMT_NOTABLE bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ip6tables/0002-verbose-output_0    | 10 +++++-----
 .../testcases/ipt-restore/0011-noflush-empty-line_0    |  2 +-
 .../shell/testcases/iptables/0002-verbose-output_0     |  4 ++--
 iptables/xshared.c                                     |  6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index dad01a982a915..2a1518d6fb0de 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -33,11 +33,11 @@ EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 
 Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
-    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::1         feed:babe::2
-    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::4         feed:babe::5
-    0     0            ipv6-icmp --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
-    0     0            all  --  *      *       ::/0                 ::/0                 dst length:42  rt type:23
-    0     0 LOG        all  --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
+    0     0 ACCEPT     0    --  eth2   eth3    feed:babe::1         feed:babe::2
+    0     0 ACCEPT     0    --  eth2   eth3    feed:babe::4         feed:babe::5
+    0     0            58   --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
+    0     0            0    --  *      *       ::/0                 ::/0                 dst length:42  rt type:23
+    0     0 LOG        0    --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
diff --git a/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0 b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
index bea1a690bb624..1a3af46fc4756 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
@@ -12,5 +12,5 @@ EOF
 
 EXPECT='Chain FORWARD (policy ACCEPT)
 target     prot opt source               destination         
-ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           '
+ACCEPT     0    --  0.0.0.0/0            0.0.0.0/0           '
 diff -u <(echo "$EXPECT") <($XT_MULTI iptables -n -L FORWARD)
diff --git a/iptables/tests/shell/testcases/iptables/0002-verbose-output_0 b/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
index 5d2af4c8d2ab2..15c72af309186 100755
--- a/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
@@ -21,8 +21,8 @@ EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 
 Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
-    0     0 ACCEPT     all  --  eth2   eth3    10.0.0.1             10.0.0.2
-    0     0 ACCEPT     all  --  eth2   eth3    10.0.0.4             10.0.0.5
+    0     0 ACCEPT     0    --  eth2   eth3    10.0.0.1             10.0.0.2
+    0     0 ACCEPT     0    --  eth2   eth3    10.0.0.4             10.0.0.5
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ccec4ff1bceef..695157896d521 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1092,10 +1092,10 @@ void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 
 	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 
-	if (pname)
-		printf(FMT("%-4s ", "%s "), pname);
-	else
+	if (((format & (FMT_NUMERIC | FMT_NOTABLE)) == FMT_NUMERIC) || !pname)
 		printf(FMT("%-4hu ", "%hu "), proto);
+	else
+		printf(FMT("%-4s ", "%s "), pname);
 }
 
 void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
-- 
2.34.1

