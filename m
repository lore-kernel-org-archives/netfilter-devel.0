Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9D4C04A68
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 11:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiG1Lb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiG1Lby (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 07:31:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A548E8D
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 04:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I/4u7zWtc7g5k4HgYNLZ9kwIi/eQFq8mb9upAPEgHK8=; b=nmtmd8U2Wq0A6QO4lfhCP+XMZl
        YVMAWOlnjDG7dziRaB+y9WuR/KTopJDRujX6a9zQXipbTa56EQVMR1ouZbaQR7ovnMl1Kd2A+yDLX
        Bwhe3B9VEYFaEw39jZF1197JJTtUUwbfGmLyaUXdAi3FnHMt3DYFJa/ApFnH7CuElK/5BfXzC34vN
        +g+cWiS2MEgXKk1c//gnmWE9Njyi+16SS6L1Yrg7lMGKTftIW0W8KSTZg3af0wHoIW/U1o7FGDDCM
        iRwmX8ojVEpc0ppUb5EPd97SI1bcNPZlG68f3O3CtSmLac+KPqCrWOH7XvlFHYl44AvWVirQN/k+x
        sXsM1mvg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oH1k6-0001rG-SN; Thu, 28 Jul 2022 13:31:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Erik Skultety <eskultet@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 2/3] xshared: Fix for missing space after 'prot' column
Date:   Thu, 28 Jul 2022 13:31:35 +0200
Message-Id: <20220728113136.24376-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728113136.24376-1-phil@nwl.cc>
References: <20220728113136.24376-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Format string ensured a minimum field width of five characters, but
allowed for longer strings to eat the column delimiting white space.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/ip6tables/0002-verbose-output_0     | 2 +-
 iptables/xshared.c                                            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index 4e754156ba589..dad01a982a915 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -35,7 +35,7 @@ Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
     0     0 ACCEPT     all  --  eth2   eth3    feed:babe::1         feed:babe::2
     0     0 ACCEPT     all  --  eth2   eth3    feed:babe::4         feed:babe::5
-    0     0            ipv6-icmp--  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
+    0     0            ipv6-icmp --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
     0     0            all  --  *      *       ::/0                 ::/0                 dst length:42  rt type:23
     0     0 LOG        all  --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index b1088c8234426..ccec4ff1bceef 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1093,9 +1093,9 @@ void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 
 	if (pname)
-		printf(FMT("%-5s", "%s "), pname);
+		printf(FMT("%-4s ", "%s "), pname);
 	else
-		printf(FMT("%-5hu", "%hu "), proto);
+		printf(FMT("%-4hu ", "%hu "), proto);
 }
 
 void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
-- 
2.34.1

