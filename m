Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F13C2D0C6
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912B9206CB
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469469;
	bh=FI2zumC+h06Z1xumFA3Cq4/NFMfxrB4/U/qNtkyGovA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vrIg6AmXElpd5pM4Jr1WqnNzniWaRk7YVRzuG0IE7rUE3s9jjd3tRO2SuErXk6G2I
	 U14vWqde7E16a0dcO/amkHCnN8ikrnIs/eQkMEYS5BWSJVQYtyFOehP0w70GWH/eXJ
	 Th5yZFO+GQBH+DRoBpBJx5GVEfnstRMqSszpEDI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfL0Rll (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfL0Rlj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 209E321D7E;
        Fri, 27 Dec 2019 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468498;
        bh=FI2zumC+h06Z1xumFA3Cq4/NFMfxrB4/U/qNtkyGovA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nke2pLSa4cJ87CA4v4WfYfS73rBldD9czoQEqeq3JdmpKctZb1W6dowhXx3rqooKv
         5ZM8S2Ct9NQ02JfvNr0qobdjhJEf7ih/ZgmXWLGs1ioG4Rp1loBeRkk+Z/WKNxF8Nl
         QHwizTiTNpM+mCmyrwgeKSPrSo/42+wyHlkwmWtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/187] netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets
Date:   Fri, 27 Dec 2019 12:38:21 -0500
Message-Id: <20191227174055.4923-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit db3b665dd77b34e34df00e17d7b299c98fcfb2c5 ]

The existing rbtree implementation might store consecutive elements
where the closing element and the opening element might overlap, eg.

	[ a, a+1) [ a+1, a+2)

This patch removes the optimization for non-anonymous sets in the exact
matching case, where it is assumed to stop searching in case that the
closing element is found. Instead, invalidate candidate interval and
keep looking further in the tree.

The lookup/get operation might return false, while there is an element
in the rbtree. Moreover, the get operation returns true as if a+2 would
be in the tree. This happens with named sets after several set updates.

The existing lookup optimization (that only works for the anonymous
sets) might not reach the opening [ a+1,... element if the closing
...,a+1) is found in first place when walking over the rbtree. Hence,
walking the full tree in that case is needed.

This patch fixes the lookup and get operations.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 57123259452f..a9f804f7a04a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -74,8 +74,13 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
-			if (nft_rbtree_interval_end(rbe))
-				goto out;
+			if (nft_rbtree_interval_end(rbe)) {
+				if (nft_set_is_anonymous(set))
+					return false;
+				parent = rcu_dereference_raw(parent->rb_left);
+				interval = NULL;
+				continue;
+			}
 
 			*ext = &rbe->ext;
 			return true;
@@ -88,7 +93,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 		*ext = &interval->ext;
 		return true;
 	}
-out:
+
 	return false;
 }
 
@@ -139,8 +144,10 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 			if (flags & NFT_SET_ELEM_INTERVAL_END)
 				interval = rbe;
 		} else {
-			if (!nft_set_elem_active(&rbe->ext, genmask))
+			if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = rcu_dereference_raw(parent->rb_left);
+				continue;
+			}
 
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
@@ -148,7 +155,11 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				*elem = rbe;
 				return true;
 			}
-			return false;
+
+			if (nft_rbtree_interval_end(rbe))
+				interval = NULL;
+
+			parent = rcu_dereference_raw(parent->rb_left);
 		}
 	}
 
-- 
2.20.1

