Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342BDC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJLPTY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJLPTA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:19:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF31D01AB
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HvvbqSi9uEjDCLGLa1yHljBsfCxymTjtyjAxM4Ufadw=; b=etyy3Bb1Hdb5IqK5z+XCjd4mCF
        ctni6mCK+BmCs0Gce8VyuFf5GaibJg1BXkTQIx3paUkP8tttSaSKISWVRwTgDWHkufAcAde0x6prE
        xIDYcJmV8Dt56lz969yaUGBuCAJd+90/F5mUfwY8N3d0CjivQD1XhQI5JiCMfK1cPnj3ODgvrUF+P
        E6PPCWd5EvbpeHwdTp0fB4ftBG+8+2shjT467pDpsq1luSlYtGXEY4HgSFunt36co3jgKx/ErEor9
        TSAU9DvGcIV86EeaOFWcHNpshuErkdGQc4mhzvP9aTJwvlYJL+zyIa7OZvc++PNF4C8GINlzspiJF
        KKPOW2zQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVV-0002pk-W2; Wed, 12 Oct 2022 17:18:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 10/12] tests: libebt_vlan.t: Drop trailing whitespace from rules
Date:   Wed, 12 Oct 2022 17:18:00 +0200
Message-Id: <20221012151802.11339-11-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fast iptables-test.py mode is picky and it has to: Plain redirect target
prints a trailing whitespace, generally stripping the rules in test
cases won't work therefore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_vlan.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libebt_vlan.t b/extensions/libebt_vlan.t
index 81c795854fca0..3ec0559953331 100644
--- a/extensions/libebt_vlan.t
+++ b/extensions/libebt_vlan.t
@@ -4,8 +4,8 @@
 -p 802_1Q --vlan-prio 1;=;OK
 -p 802_1Q --vlan-prio ! 1;=;OK
 -p 802_1Q --vlan-encap ip;-p 802_1Q --vlan-encap 0800 -j CONTINUE;OK
--p 802_1Q --vlan-encap 0800 ;=;OK
--p 802_1Q --vlan-encap ! 0800 ;=;OK
+-p 802_1Q --vlan-encap 0800;=;OK
+-p 802_1Q --vlan-encap ! 0800;=;OK
 -p 802_1Q --vlan-encap IPv6 ! --vlan-id 1;-p 802_1Q --vlan-id ! 1 --vlan-encap 86DD -j CONTINUE;OK
 -p 802_1Q --vlan-id ! 1 --vlan-encap 86DD;=;OK
 --vlan-encap ip;=;FAIL
-- 
2.34.1

