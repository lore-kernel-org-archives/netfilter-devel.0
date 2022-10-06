Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CBAC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJFANg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFANf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:13:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0FA3340D
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4KMcOmTGYrw/nb9DYyhThJP8eqPo0btt4e1hYIZmLAM=; b=NxLct6A9Og8c8rTRfq8afmi4bi
        MObEUUwqyz8XYUV/fD6hQJIzxmLPLg3IY8uYaX5OKGqwPQTb613emTqdGs24G3C73c912cvqSTGd6
        uCwjfiUFPdXsKaXiTv9RGvkbqrjBi9oyRbprSFTHkxixT9TS5NGPpUoFNTR6FjtVX9FFQx+uKKQ5D
        CEqlBNUZ/XsNQZ6KmWmaOja8PYm+q9/om2ljAghVyq0+9NuWFknfMbnINXPQILddcD6CAxSMlA3fJ
        VIXQXjX5SPyXVbilPury6+8nK4luQr0pWz8A56LGeLrMe0X/+K6Y2we0x+/1Z2DrQ5XIC904Bcz1N
        LmW2tphA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEW5-0001mq-47
        for netfilter-devel@vger.kernel.org; Thu, 06 Oct 2022 02:13:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] tests: shell: Fix expected ebtables log target output
Date:   Thu,  6 Oct 2022 02:13:19 +0200
Message-Id: <20221006001319.24644-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006001319.24644-1-phil@nwl.cc>
References: <20221006001319.24644-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Forgot to update shell testsuite when removing empty --log-prefix
options.

Fixes: 9cdb52d655608 ("extensions: libebt_log: Avoid empty log-prefix in output")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ebtables/0002-ebtables-save-restore_0     | 4 ++--
 .../shell/testcases/ebtables/0003-ebtables-restore-defaults_0 | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0 b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
index 0537f5677c5d5..1091a4e80bebe 100755
--- a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
+++ b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
@@ -91,13 +91,13 @@ DUMP='*filter
 -A foo -p IPv6 --ip6-dst feed:babe::/64 -j ACCEPT
 -A foo -p IPv6 --ip6-proto tcp -j ACCEPT
 -A foo --limit 100/sec --limit-burst 42 -j ACCEPT
--A foo --log-level notice --log-prefix "" -j CONTINUE
+-A foo --log-level notice -j CONTINUE
 -A foo -j mark --mark-set 0x23 --mark-target ACCEPT
 -A foo --nflog-group 1 -j CONTINUE
 -A foo --pkttype-type multicast -j ACCEPT
 -A foo --stp-type config -j ACCEPT
 -A foo -p Length --802_3-sap 0x23 --limit 100/sec --limit-burst 5 -j ACCEPT
--A foo --pkttype-type multicast --log-level notice --log-prefix "" -j CONTINUE
+-A foo --pkttype-type multicast --log-level notice -j CONTINUE
 -A foo --pkttype-type multicast --limit 100/sec --limit-burst 5 -j ACCEPT
 *nat
 :PREROUTING ACCEPT
diff --git a/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0 b/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
index 63891c1bb731a..7554ef8571511 100755
--- a/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
+++ b/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
@@ -24,7 +24,7 @@ EXPECT='*filter
 -A FORWARD --limit 100/sec --limit-burst 42 -j ACCEPT
 -A FORWARD --limit 1000/sec --limit-burst 5 -j ACCEPT
 -A FORWARD --log-level notice --log-prefix "foobar" -j CONTINUE
--A FORWARD --log-level notice --log-prefix "" -j CONTINUE'
+-A FORWARD --log-level notice -j CONTINUE'
 
 $XT_MULTI ebtables --init-table
 $XT_MULTI ebtables-restore <<<$DUMP
-- 
2.34.1

