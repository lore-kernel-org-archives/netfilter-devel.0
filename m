Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAFEC61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbjKVMyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343879AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D24D54
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pvWG3A4Yf5LYOoZptYJ1sMC2DLCEeDAmyKx2bE23xzU=; b=Qj736xNABUC/fDB86WGxEhbLbK
        KtY+f0v1VNLB/FJnW7AiEDnqg5VrtEz11WcYGTVftjbVfN6A7B9dLtZ/xF9RBjcSmcD+JB+gqfKr9
        4U5UpT4NwrqZ9CG1Iar6mLmiITK9APRtdKd3YdS07G3AMmuLq4hWqcSotzamivEFRv9P1Ao6gcpdz
        G2Lz27E/bkfAkWSdPxPpwzbCkpGu6fq94JmaXVSBWGrmdPO+UaU7M86R8G6+JHsTysu1rXskEeLVx
        wSM3AG+MfKN0sS/5OsF9ZW+glz/BCboqQH5Q20pE1GMFIkwE+9/a86eBvNvmtPZhwOWJd0PHy456d
        m8IWgXSA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkU-0005S5-2p
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/12] ebtables: Make ebt_load_match_extensions() static
Date:   Wed, 22 Nov 2023 14:02:19 +0100
Message-ID: <20231122130222.29453-10-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is not used outside of xtables-eb.c.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.h | 1 -
 iptables/xtables-eb.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index eb1b3928b6543..0e6a29650acca 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -115,7 +115,6 @@ static inline const char *ebt_target_name(unsigned int verdict)
 })								\
 
 void ebt_cs_clean(struct iptables_command_state *cs);
-void ebt_load_match_extensions(void);
 void ebt_add_match(struct xtables_match *m,
 			  struct iptables_command_state *cs);
 void ebt_add_watcher(struct xtables_target *watcher,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3fa5c179ba4b1..cd45e0495ebcb 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -504,7 +504,7 @@ static void ebt_load_watcher(const char *name)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
 
-void ebt_load_match_extensions(void)
+static void ebt_load_match_extensions(void)
 {
 	opts = ebt_original_options;
 	ebt_load_match("802_3");
-- 
2.41.0

