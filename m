Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC399C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjKVMyp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8934810C
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5CR0iZqmVnzx6OwryvZsEG1/4wDokFx0FhGgP0EhYGo=; b=Km91QfWIlP6z8ki33ohfcl+aw4
        99nZ+7pKAnU0Y1uI0sF9N7ZHdjVmoKxa0UTF0LWLeDIl85s0fZgjRWP5KhtxM4fJU4lBD38LzYgOX
        E4U173j6+hk5ZtA8mJyFyOzihncJ8WZvK/EBB7+ZXCDcn/kPw+TtFmZfeu63A2bFjpT6aFlO7+xwT
        +VP3Srnl6MWWbWDwUzGo9g5CzxfA/ckhlKBFZUoM2wb3Ij8HMXyeEP3tTc0ITra2lic7x6ckX7Fqe
        NPrLBNQrD7cROS2bG9y/M6x7G/C1gT4kn5JToS+mDKNpXWlYuioU6PAgG7dowhSZVrB9/x3tee2uF
        JLxtwvIQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkT-0005S1-O8
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/12] ebtables: Align line number formatting with legacy
Date:   Wed, 22 Nov 2023 14:02:20 +0100
Message-ID: <20231122130222.29453-11-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy ebtables appends a dot to the number printed in first column if
--Ln flag was given.

Fixes: da871de2a6efb ("nft: bootstrap ebtables-compat")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 772525e1b45a9..1fcdeaf2cad68 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -354,7 +354,7 @@ static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	struct iptables_command_state cs = {};
 
 	if (format & FMT_LINENUMBERS)
-		printf("%d ", num);
+		printf("%d. ", num);
 
 	nft_rule_to_ebtables_command_state(h, r, &cs);
 	__nft_bridge_save_rule(&cs, format);
-- 
2.41.0

