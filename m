Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF6A225788
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754561125; cv=none; b=gcIsbR/8YaYKhocy+dmugMHWQjaaXmZl3npSOTpbSS0tar70hy3kMccpfKDg/mPRS+NTYHtppHNm6zAWHmV+ufQryw2Xs3rFJjfa31d26H3hPerVZoZ7cs0/Kgra1zIG8eQOFLbj/WnRD7MaNUOTqLDqbW2RgB6fBolJKhVosPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754561125; c=relaxed/simple;
	bh=33oTo/ZO9FLMPR3TDYaMJNrbKrSsY05ZOhI21TZhS/Y=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=gLfGxGK6Ycaflu6Xg2VpjbMV4HTiHZPe3gqEnZeX4S5ZUYheiIaj8Hi9JHdXsTqCQbVmtYeoR1ew+wY4XxFBNBu1yYvpiqUwFUtZPEqSZXUlbftwLQvWr3m7+owp2TY2mDxqE1G92mzEvCpP0Y3LvZMjQenU5wORLU1dNNyDjTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gYwYEGFI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gYwYEGFI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gYwYEGFI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gYwYEGFI"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 77E5760687; Thu,  7 Aug 2025 12:05:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754561120;
	bh=kTl/4jasdPAIbR3Z8Hi7W2PGrcqhut7sBLJmTtwdp5s=;
	h=From:To:Subject:Date:From;
	b=gYwYEGFImL90Dsdrfd0Qrzity+zZhrbgBzjdxzddkfB7aNP0kjBUFnqWE0VL6t7Gd
	 Ln9xsVVd0ju1kGXeNDAOFnddNHTlNNOY8CdcQtk9yULMXFLqVcXyaAEDj5SqmRlXDc
	 2KipYK93HfaP/I8QViV2bCGQ8ZS7zXC6XPnORW7TxH0jPvdPzpHZ5drhunq0xaQ1+y
	 DmCa4k2/8D9e9VtBu6jrSKVzo9l3opN6OC266NSR2X6+U/CjnBbRa2UzRNwYHYDIOt
	 It6G1SObme5rKOPI04dR92S4o3kAMgezq1xxrd5l/73r0LTfRs67uiGRYDzfppzNYl
	 3NC66ycJjUQCg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 156F060663
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 12:05:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754561120;
	bh=kTl/4jasdPAIbR3Z8Hi7W2PGrcqhut7sBLJmTtwdp5s=;
	h=From:To:Subject:Date:From;
	b=gYwYEGFImL90Dsdrfd0Qrzity+zZhrbgBzjdxzddkfB7aNP0kjBUFnqWE0VL6t7Gd
	 Ln9xsVVd0ju1kGXeNDAOFnddNHTlNNOY8CdcQtk9yULMXFLqVcXyaAEDj5SqmRlXDc
	 2KipYK93HfaP/I8QViV2bCGQ8ZS7zXC6XPnORW7TxH0jPvdPzpHZ5drhunq0xaQ1+y
	 DmCa4k2/8D9e9VtBu6jrSKVzo9l3opN6OC266NSR2X6+U/CjnBbRa2UzRNwYHYDIOt
	 It6G1SObme5rKOPI04dR92S4o3kAMgezq1xxrd5l/73r0LTfRs67uiGRYDzfppzNYl
	 3NC66ycJjUQCg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_socket: remove WARN_ON_ONCE with giant cgroup tree
Date: Thu,  7 Aug 2025 12:05:16 +0200
Message-Id: <20250807100516.1380006-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot managed to reach this WARN_ON_ONCE with a giant cgroup tree,
remove it.

  WARNING: CPU: 0 PID: 5853 at net/netfilter/nft_socket.c:220 nft_socket_init+0x2f4/0x3d0 net/netfilter/nft_socket.c:220

Reported-by: syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 35d0409b0095..36affbb697c2 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -217,7 +217,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 
 		level += err;
 		/* Implies a giant cgroup tree */
-		if (WARN_ON_ONCE(level > 255))
+		if (level > 255)
 			return -EOPNOTSUPP;
 
 		priv->level = level;
-- 
2.30.2

