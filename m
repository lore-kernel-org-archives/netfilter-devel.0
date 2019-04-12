Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE7CC10F13
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 01:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F6621850
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 01:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555033471;
	bh=9wr/jFhWlWalbaQLZNk/fxfGFnQQXb94Qv0STyxqiFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eDaN5Gp3eR29sVOtI21q3rkoAEey4zDoE1YIYLrosUq28uS+p8vT99Qv/cQgIN3Td
	 A/LC4DeSDVCrgBHoz9cmaDGyjiWWpm3wSTMbaLUq0FwBiJ8OHIhKPUnscN5aVVpNjZ
	 5iEheWYLtAZmP4oxg4cds9KQsj+bLmSeD09rv7MU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfDLBoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 21:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbfDLBoS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 21:44:18 -0400
Received: from sinanubuntu1604.mkjiurmyylmellclgttazegk5f.bx.internal.cloudapp.net (unknown [52.191.113.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C490218A6;
        Fri, 12 Apr 2019 01:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555033458;
        bh=9wr/jFhWlWalbaQLZNk/fxfGFnQQXb94Qv0STyxqiFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omNLPV9jOyW9Y18dRE0id9XM1fQsVSRV4rb4+bPUaAUeIO+s+9dcwI4IqHjIKQaiP
         MdjsfPLSVaWnxk0SOWKG5sHhvssjFEtE6vnpf6R5kJjhvhZxuXvNe6uI5Gt9uInfDM
         vv5Gl+XyOHZaj5qW5V/vj4Cvki5J5nxOpdGhqfQA=
From:   Sinan Kaya <okaya@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     josh@joshtriplett.org, keescook@chromium.org,
        Sinan Kaya <okaya@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH v4 5/5] net: Replace CONFIG_DEBUG_KERNEL with CONFIG_DEBUG_MISC
Date:   Fri, 12 Apr 2019 01:43:55 +0000
Message-Id: <20190412014355.25307-6-okaya@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412014355.25307-1-okaya@kernel.org>
References: <20190412014355.25307-1-okaya@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONFIG_DEBUG_KERNEL should not impact code generation. Use the newly
defined CONFIG_DEBUG_MISC instead to keep the current code.

Signed-off-by: Sinan Kaya <okaya@kernel.org>
---
 net/netfilter/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 93aaec3a54ec..cac3bad47f5e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -162,7 +162,7 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 
 static void hooks_validate(const struct nf_hook_entries *hooks)
 {
-#ifdef CONFIG_DEBUG_KERNEL
+#ifdef CONFIG_DEBUG_MISC
 	struct nf_hook_ops **orig_ops;
 	int prio = INT_MIN;
 	size_t i = 0;
-- 
2.21.0

