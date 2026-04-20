Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD743CF68D;
	Mon, 20 Apr 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691781; cv=none; b=ZsIAt3Ldur6qAJKW+umBoM0bCP06Rf3Mf5OP793fdgtelfwrevjZEurGNPuEEf7Lco40VzbVMECIlL/8uezNjGymvmnEZ+2W6pNYGMZde8PsHkiXFmdcqR/u+lRhNW4J0YQVHhaRiCraWchbirY5wU0Lo1vyKHHiR1rCKtHEq1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691781; c=relaxed/simple;
	bh=1jstWT2rpcxsIUBuWdC1TD24bJamUKDjb2CzjzxhRhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP6bt7XtpoCaCyoQnxA9w+kw0NQVo60aLGToeURSmdxK+agQysiB19lW6ZQqRCXTqnIeqkpASTFHn8ZmYxly6ErXLItXdTgWfZSg2SEI1i6jPEgKII5x7Rqf470LbWs0Z0mPrM0yB7qtC5FHYoQ3fYadZo4Oj3Es9y+TVa6lLic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5ZDOasb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5ZDOasb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A73C2BCB7;
	Mon, 20 Apr 2026 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691781;
	bh=1jstWT2rpcxsIUBuWdC1TD24bJamUKDjb2CzjzxhRhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5ZDOasbJx9WchWO22g6UU2z69d6+QFggPfYKjjI6PLlroosVryCGMPPkL6rT8lmN
	 laPBSa4aZefHyXy2Ro9WqSF40jErISG962qhMmc4i8AK2La6KmynQZHNm8vbyXckxB
	 8FBB4FlprK7dG4yZ8ApN9e+uUTQdWiD4cFsWF3z9q2NzSF6mkyrAd/egBxb5V8Bys5
	 g1OAGrThtT/7FgZ74TpwUsdi39S0WK7oERwevV6NsJXtA0Tst1tWEmHmkhBmUtvHqp
	 +UTqa3RUSi6MhZ02cZuIDlKxeU1cgBWsaY7T7jzhmNCctrnJ+ml74c2ZB2+FzR8Znm
	 m6cf84GmLJeEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: conntrack: add missing netlink policy validations
Date: Mon, 20 Apr 2026 09:19:44 -0400
Message-ID: <20260420132314.1023554-190-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f900e1d77ee0ef87bfb5ab3fe60f0b3d8ad5ba05 ]

Hyunwoo Kim reports out-of-bounds access in sctp and ctnetlink.

These attributes are used by the kernel without any validation.
Extend the netlink policies accordingly.

Quoting the reporter:
  nlattr_to_sctp() assigns the user-supplied CTA_PROTOINFO_SCTP_STATE
  value directly to ct->proto.sctp.state without checking that it is
  within the valid range. [..]

  and: ... with exp->dir = 100, the access at
  ct->master->tuplehash[100] reads 5600 bytes past the start of a
  320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
  UBSAN.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Fixes: a258860e01b8 ("netfilter: ctnetlink: add full support for SCTP to ctnetlink")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c    | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index becffc15e7579..fbe9e3f1036f8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3475,7 +3475,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
+	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7c6f7c9f73320..645d2c43ebf7a 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -582,7 +582,8 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 }
 
 static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
-	[CTA_PROTOINFO_SCTP_STATE]	    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_SCTP_STATE]	    = NLA_POLICY_MAX(NLA_U8,
+							 SCTP_CONNTRACK_HEARTBEAT_SENT),
 	[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]  = { .type = NLA_U32 },
 	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
 };
-- 
2.53.0

