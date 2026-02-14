Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456DC3C2D;
	Sat, 14 Feb 2026 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104330; cv=none; b=WBT2yh/kb1va6Ub5XtFLMzsr5tAlWtFy9+UK7YF0I+nrFIUAOgUp0Qd5nqPVeFKkB6d02ns75xjQ4pMwHGhWTckcOgLgAMhpZO8BwnL9xwJ+wra+thepOWHtfbSffFUJSdCZvIZ/jiissKzvSdUCJA9SKt0b7dgkAAW2VN9V04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104330; c=relaxed/simple;
	bh=CuDAsQBLaxRj0NpJh3r6TcTRCeVIe+mENyvZpUOzPU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2IO8F3T+rn70zxZoT5rn7c2nZ1j5erRnhv8YcFb10+7Rf+fa0BSdhAmb8WZe9Cis5JQV6/63tZKWWA8cD35a609lnk14sdIo4ZjouniwehQptnTHeK5gDEzZQEIUjic56szeqTBqjuKn2xkmC0MwGtVkkxl3Wxshf8Oy5LAzRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M44nbc/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M44nbc/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DBEC19422;
	Sat, 14 Feb 2026 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104329;
	bh=CuDAsQBLaxRj0NpJh3r6TcTRCeVIe+mENyvZpUOzPU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M44nbc/sU+zhFpdQKopJHXoQYEASaMnBujK7J6bj6h2We5YA957IFJ7smT16JIQKJ
	 85cSp4qPpllhwqA4afy5pK2ijOHyNYHYEgXYSk2AdqABECKj6BynhPcN+GMxIxGsFR
	 wJDIfomptADluhnmiWIQRKAb1iciONkkzfwrp95MGQxTd5EAuUVONw8EFPQ6DhuTtT
	 s2dQqgMrteghdvZ2kbjvQ4lEHlFDE3dQsawrvPWYaZNhL4C08byK0u8V0CiHItowob
	 ktL5SOPqfXXMD3le0gpPIyfwvcX8OkqMRacQYHhRtbp2y78yYt/h61R3nCMUE/HnJW
	 vFesTTNa8sJUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.19-5.10] netfilter: nf_conntrack: Add allow_clash to generic protocol handler
Date: Sat, 14 Feb 2026 16:22:46 -0500
Message-ID: <20260214212452.782265-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>

[ Upstream commit 8a49fc8d8a3e83dc51ec05bcd4007bdea3c56eec ]

The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
 ("netfilter: conntrack: introduce clash resolution on insertion race"),
sets allow_clash=true in the UDP/UDPLITE protocol handler
but does not set it in the generic protocol handler.

As a result, packets composed of connectionless protocols at each layer,
such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.

To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.

Signed-off-by: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The current file does **not** yet have `allow_clash = true` — this
confirms the patch hasn't been applied yet and is needed.

### 7. STABILITY AND TRUST INDICATORS

- **Signed-off by Florian Westphal** — the netfilter maintainer,
  indicating proper review
- The fix is trivially verifiable: it mirrors what was already done for
  UDP/UDPLITE/GRE
- The author (Yuto Hamaguchi from Mitsubishi Electric) clearly
  encountered this in a real-world deployment scenario

### Summary

| Criterion | Assessment |
|-----------|-----------|
| **Fixes a real bug** | YES — packets dropped for connectionless
protocol stacks |
| **Obviously correct** | YES — mirrors existing pattern for
UDP/UDPLITE/GRE |
| **Small and contained** | YES — single line addition |
| **No new features** | Correct — just extends existing clash resolution
to generic handler |
| **Risk of regression** | Very low — same mechanism already proven for
UDP |
| **User impact** | Moderate-high — affects any setup with
connectionless tunnels + conntrack |
| **Dependencies** | Requires 71d8c47fc653 which is already in mainline
|

This is a textbook stable backport candidate: a one-line fix that
addresses a real user-visible bug (packet drops) with essentially zero
regression risk, fixing an oversight in an earlier commit that only
partially applied clash resolution to all relevant protocol handlers.

**YES**

 net/netfilter/nf_conntrack_proto_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e831637bc8ca8..cb260eb3d012c 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -67,6 +67,7 @@ void nf_conntrack_generic_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
+	.allow_clash            = true,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
-- 
2.51.0

