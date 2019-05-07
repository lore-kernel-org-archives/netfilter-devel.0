Return-Path: <SRS0=SeaY=TH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EB5C004C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 05:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B940205ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557208569;
	bh=Mr/2++AK0yHkr642himO4kwv2kPh2SKci7S98rv3zsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=T1S3as0+rsPGIY8oF75efGKUIo8KKHip5fJWU0C3sMBJf4V6GQBWgmd+6AFAozi6d
	 z8ZUv0cu1TjCpzT5GBq5K+JoHD7ciDkLCzIL6aV1RhP90NwG6ZEoF0w+wlWK9XPpjs
	 Ax/EzgT/9WQxdOxJyRyk4oDN6BlampwCKtOFuICs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfEGF4C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 May 2019 01:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbfEGFiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 May 2019 01:38:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB8621655;
        Tue,  7 May 2019 05:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207487;
        bh=Mr/2++AK0yHkr642himO4kwv2kPh2SKci7S98rv3zsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Op8iNN4HXtfi6AOoeQKEoc/HHIHb2C4C/Hz2TW7psf/BXUG9TOgqZuQ5V8jfUHoX9
         psknTrDTeVtd78S5eQgk4/YWNmuEl89s9Y66xszipxdy/LK72WDbGP77W5arO6tGoW
         11mcmQDZ4Skmsh/x0IXn3Vn+GBXbp3XI4sL3M1P4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 71/81] netfilter: nf_tables: add missing ->release_ops() in error path of newrule()
Date:   Tue,  7 May 2019 01:35:42 -0400
Message-Id: <20190507053554.30848-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit b25a31bf0ca091aa8bdb9ab329b0226257568bbe ]

->release_ops() callback releases resources and this is used in error path.
If nf_tables_newrule() fails after ->select_ops(), it should release
resources. but it can not call ->destroy() because that should be called
after ->init().
At this point, ->release_ops() should be used for releasing resources.

Test commands:
   modprobe -rv xt_tcpudp
   iptables-nft -I INPUT -m tcp   <-- error command
   lsmod

Result:
   Module                  Size  Used by
   xt_tcpudp              20480  2      <-- it should be 0

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7ff13a7b99..ebfcfe1dcbdb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2719,8 +2719,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
-		if (info[i].ops != NULL)
+		if (info[i].ops) {
 			module_put(info[i].ops->type->owner);
+			if (info[i].ops->type->release_ops)
+				info[i].ops->type->release_ops(info[i].ops);
+		}
 	}
 	kvfree(info);
 	return err;
-- 
2.20.1

