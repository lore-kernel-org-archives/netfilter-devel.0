Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E921AC33CB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 18:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD81D214AF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198062;
	bh=DpDwZjT5JL55OrFqatMzY1JDV7bYkHQBMDOrDiPxQqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vou9jxi8fQnOp9yYX+MKRXB9c6mSBHmMV+PdPXjW9TunSTn+rLeAmIG8KMYK+0XSW
	 xlkj3Q4PbEPyRtrTdbUa0yLQCgVqn3ugok86omyLdKPlmQD9y0AiMJJgS6Ivs1YSSv
	 UnAvXdh1433lIFZN+yGGCeq9qFKDPNmJMh/nKKa8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393390AbgAPRjB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393405AbgAPRjA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988D2246D7;
        Thu, 16 Jan 2020 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196340;
        bh=DpDwZjT5JL55OrFqatMzY1JDV7bYkHQBMDOrDiPxQqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMCFlnoH6TobdxhxmbUA+/AZAs0CiDnM4sHLEHdmqnapDVdDtI3rhh6I3s7Hybix9
         I5xIUfW4QLJSOz8pyrN5ghhz2BFFQ9DH5SgC+3HYSbe6PpLLrjhNHcjcTZqHR6xmnZ
         JKO29sVnRI6tUq6TbTsyt/co/6PUJSR7CpPuUQfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 137/251] netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule
Date:   Thu, 16 Jan 2020 12:34:46 -0500
Message-Id: <20200116173641.22137-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 680f6af5337c98d116e4f127cea7845339dba8da ]

If userspace provides a rule blob with trailing data after last target,
we trigger a splat, then convert ruleset to 64bit format (with trailing
data), then pass that to do_replace_finish() which then returns -EINVAL.

Erroring out right away avoids the splat plus unneeded translation and
error unwind.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 56b7197f0373..1d850edecd72 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2182,7 +2182,9 @@ static int compat_copy_entries(unsigned char *data, unsigned int size_user,
 	if (ret < 0)
 		return ret;
 
-	WARN_ON(size_remaining);
+	if (size_remaining)
+		return -EINVAL;
+
 	return state->buf_kern_offset;
 }
 
-- 
2.20.1

