Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784AAC32750
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46EB3205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565749890;
	bh=qm6rrJmrotYL5exLF43f2RMGib1S8clCSmkKGZ4zQns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=w5Yf0/rjw+l794pNg0vwzTKQAzouNHaePUZMFvLw7DMyxLLnvCoLcjGMgyeIWoQ7j
	 hvRXyrbxxvVkif5YIKSPhNRF//ZTJLQgGItTqekwnpdK7mztyJudWDWTS+Mt/1lLrN
	 5mAVkuq2l/8faoO1Ra3tg/SaxFJTr7LkDvb8qXxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfHNCQl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 22:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbfHNCQk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A932084D;
        Wed, 14 Aug 2019 02:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748999;
        bh=qm6rrJmrotYL5exLF43f2RMGib1S8clCSmkKGZ4zQns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBbM3wtA51zoM2AFexKsnS1+osDsCVnDJniGM8s8BsZ/gK1PztfFTx73MC9vXOX4p
         YT+Qk3zzbbbNrk2cCBswDJCknF52cngGihJo1oeirLVVNpFLqB5QFfTbeJ1jsCSGLT
         dx6T/of2CrVFpuv/2FbPGpIGSwy7aX1W8iITGA5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Shijie Luo <luoshijie1@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/68] netfilter: ipset: Fix rename concurrency with listing
Date:   Tue, 13 Aug 2019 22:15:05 -0400
Message-Id: <20190814021548.16001-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 6c1f7e2c1b96ab9b09ac97c4df2bd9dc327206f6 ]

Shijie Luo reported that when stress-testing ipset with multiple concurrent
create, rename, flush, list, destroy commands, it can result

ipset <version>: Broken LIST kernel message: missing DATA part!

error messages and broken list results. The problem was the rename operation
was not properly handled with respect of listing. The patch fixes the issue.

Reported-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1577f2f76060d..e2538c5786714 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1157,7 +1157,7 @@ static int ip_set_rename(struct net *net, struct sock *ctnl,
 		return -ENOENT;
 
 	write_lock_bh(&ip_set_ref_lock);
-	if (set->ref != 0) {
+	if (set->ref != 0 || set->ref_netlink != 0) {
 		ret = -IPSET_ERR_REFERENCED;
 		goto out;
 	}
-- 
2.20.1

