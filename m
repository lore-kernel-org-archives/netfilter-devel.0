Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2E7C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiLAQkB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiLAQju (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:39:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF79ABBBDB
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dnzFfjoBf2POgh5A53Si8umgfCO+T7GKr3+jVy9cXMo=; b=BkP1YjZ91C+yhzMoV78Rv8XRVY
        PHt69gm4uS2s4tDa2Bp2Bs4O0+BPn1sPq6W5qiER2/zb/CH0sNl9mPYE704jVeFVX++i9u1UiMYVE
        goKE9t2kfSSbmw8ZifXC6r4dF/llXPGguuS8ptl7YD4V7i/unW8ySDYflOJqgGZ4ahz/T+QNi2IEI
        RhZnXvGkdykee7UaT8Y5EmDt893hoNzPGFYXZ4XJsrTcIR6H49TrZgTkStOjpzd1cCKoLn1Gnx7i9
        hFxTkyW1u6lGvZu1UCZ6IqmeZeeP/9/Ev7oETFeYSu8w0kaPDbtb9fbt3byRCPjDb37hvLza9BA3H
        urVjXk8w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0maw-0002Xm-4w; Thu, 01 Dec 2022 17:39:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 3/7] nft: Fix for comparing ifname matches against nft-generated ones
Date:   Thu,  1 Dec 2022 17:39:12 +0100
Message-Id: <20221201163916.30808-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since nft adds the interface name as fixed-size string of 16 bytes,
filling a mask based on the length value will not match the mask nft
set.

Fixes: 652b98e793711 ("xtables-compat: fix wildcard detection")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 63d251986f65b..e812a9bcae466 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -279,7 +279,7 @@ static void parse_ifname(const char *name, unsigned int len, char *dst, unsigned
 	memcpy(dst, name, len);
 	if (name[len - 1] == '\0') {
 		if (mask)
-			memset(mask, 0xff, len);
+			memset(mask, 0xff, strlen(name) + 1);
 		return;
 	}
 
-- 
2.38.0

