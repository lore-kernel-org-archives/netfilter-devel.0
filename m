Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABEB40DFB7;
	Tue, 14 Apr 2026 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776137498; cv=none; b=BLYLvh3E6ob6salvpZvPpcu4hg10jC1wskleRsLPQAN2wZz4IcJQyd1vJOanTQz8zVE5vbY1s04YhhQntUbDJT8e2l8YJhN1h82IsNPlYGbjQIjxkKu+fvB+i1xFCYVUSEKvLYZM+6UAsom3Fy9lCWBgJk05yAazai2oYu+QrzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776137498; c=relaxed/simple;
	bh=w2HqWKBJG+xmo7xipW/PndQPguK0Fdy9+MwndF5BBi8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DK4kMWlM9TKYTatBW7Hd6jS5m+O4h+3070qNM9VMDvLbPwKaZRX1cPfd34Bd48oxo236tpjCSyc6Z7Hu7A+FO3KRfow4SVGYd/oNKxUmEaDrWKj8NEJ8cuc+7pWiDUZeuTRzLdCm4xSbnXaC+rnNn6QImkYgalzG3gueI8w+FHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=2JObPNQj; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="2JObPNQj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=2JObPNQjsDdIbeFWqE2ZObxopjGdiI5HT/kFUXWqoI2olQ5KXf0kEvTVtrOPS29GWxPlfTm5pyYjN
	 OVns3pk7zm5bjXYnNoxY2v3oNPX+hRZgd2SBd+K723RVnwH+H3DZOKEtApJyfDbnD/M7Jbov5ziBFS
	 ad4C7/zhjvhNcaDE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-01-12079 (RichMail) with SMTP id 2f2f69ddb50be9a-00eab;
	Tue, 14 Apr 2026 11:31:30 +0800 (CST)
X-RM-TRANSID:2f2f69ddb50be9a-00eab
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	fw@strlen.de
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH 6.18.y] netfilter: conntrack: add missing netlink policy validations
Date: Tue, 14 Apr 2026 11:31:29 +0800
Message-Id: <20260414033129.48460-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/netfilter/nf_conntrack_netlink.c    | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 879413b9fa06..2bb9eb2d25fb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3465,7 +3465,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
+	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7c6f7c9f7332..645d2c43ebf7 100644
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
2.34.1


