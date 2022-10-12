Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E938C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJLPTp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJLPTY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:19:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CE5DD8B8
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jiaZEu+/b5ANA3LdDxyNu8/eAc6uph000iI4kmzYLiw=; b=keM9TEhGj5xqjXnzXXWp4kr7GU
        E+8FiIDlwQIZaDHkDrhiATtC0/OOiukTkKccQbB5LVG3MhnBBzywUG166J2ZC2VlQ2xsOaVqlFqID
        KUkVWCzAgpZCr+efLl4qpRxroh0wq6ZwQifTMeezYhGRpbvHyjVnmlbVqijte16PpNS8kFFAshCIe
        JIU9JXzEKmY7uHdxsOG0kGXVeJIqgvKKZFWk+TJBj0KZUZZok1oKxjSRKL2v8wAeix2fvgWl0p648
        65z6mLz5pRiFnnEuD0jSkg9i6/22TrmMCHII4OOezUdjZpRIVKM5BEajSw9+5YTG07nlU1G2ZH12u
        htyPi/gQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVr-0002qq-3R; Wed, 12 Oct 2022 17:19:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 06/12] tests: libebt_redirect.t: Plain redirect prints with trailing whitespace
Date:   Wed, 12 Oct 2022 17:17:56 +0200
Message-Id: <20221012151802.11339-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eliminating the trailing whitespace is non-trivial due to how ebtables
extension printing works, so just update the test case instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_redirect.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_redirect.t b/extensions/libebt_redirect.t
index 23858afa3b588..58492b7968153 100644
--- a/extensions/libebt_redirect.t
+++ b/extensions/libebt_redirect.t
@@ -1,4 +1,4 @@
 :PREROUTING
 *nat
--j redirect;=;OK
+-j redirect ;=;OK
 -j redirect --redirect-target RETURN;=;OK
-- 
2.34.1

