Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B71C28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCFF274D7
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559396276;
	bh=8wPyq/bRunq62drSXXF46S3ny3rqGcFrVdccoxLpWbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xl0c3O2gUnO3nozJnP0qXXQMQE92OoG6nMDVnZ3znTMTRbFhxXXmsvfSE39aGyHU8
	 KRAHegF+FJu+LaYw5sPlAyFdisuRvYY6pNJHNHGwMXfiikTxbnYjnhNvTizrua0IpP
	 iz5eOJ1yDMfDzeyP8WtHSqOm245CQFjSx+NJsU4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfFANht (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbfFANVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B858C27308;
        Sat,  1 Jun 2019 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395301;
        bh=8wPyq/bRunq62drSXXF46S3ny3rqGcFrVdccoxLpWbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXf4QxeXMvReOhnO9CpyLhRFHSExFK0rhBTt3ND/clT+HAcwJK/1Bzlqj+XlAL/T/
         d/H7XkjPYYxRWAj4WznB9GMaZu/IP2oX535HHhKb6Cojd5+E0sObPPMQL7uaSmG45K
         TDaYWYw2qZ0ONpgf//RqkBIMWbUKCghIyaWejrw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 061/173] netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression
Date:   Sat,  1 Jun 2019 09:17:33 -0400
Message-Id: <20190601131934.25053-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

[ Upstream commit f8e608982022fad035160870f5b06086d3cba54d ]

Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
on flush") introduced a user-space regression when flushing connection
track entries. Before this commit, the nfgen_family field was not used
by the kernel and all entries were removed. Since this commit,
nfgen_family is used to filter out entries that should not be removed.
One example a broken tool is conntrack. conntrack always sets
nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
removed with the -F parameter.

Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
regression, and this commit implements his suggestion. nfgenmsg->version
is so far set to zero, so it is well-suited to be used as a flag for
selecting old or new flush behavior. If version is 0, nfgen_family is
ignored and all entries are used. If user-space sets the version to one
(or any other value than 0), then the new behavior is used. As version
only can have two valid values, I chose not to add a new
NFNETLINK_VERSION-constant.

Fixes: 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter on flush")
Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 36619ad8ab8c2..8233dfafb339d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1254,7 +1254,7 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 
-- 
2.20.1

