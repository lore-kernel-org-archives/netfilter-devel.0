Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E004256C61;
	Thu, 26 Mar 2026 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529524; cv=none; b=W7WLyziDEEHsdco7ZeQGFIHGW1ZwjkeXlKjhA8H1amTWGcs1NYHBR5Qx5rVcE/JWNMdSa7XkccQeeQEeA1Hi8P7IpRLo7GerBXXE+Inv1RD2m8maigGOzRCrWO10bjZGBOHMyvGS6KAwvgEUqe9SM4ASKbi55J0npcYV25fCZ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529524; c=relaxed/simple;
	bh=K7RSrdEFZy6Z+RlJPtEraPlErH2kH671nvcT1Ug4334=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz8kOW0aeL6ibpCSqceHa0MzBQbQGbaSK2CaB+jX7xhQWoGDgV45XmjJPRrWKmsk+Dh0QEVdTGnUFzKFGEFuYCn6a4QFUstAkZzQOGXM9uhxZgUXwnWz2TsCNfCXAQhtwHw0L9mlqVhajWUZj6E9/NU+qWOP35ZVgPo8jUzvr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LSvCT8AR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LSvCT8AR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0709D6026D;
	Thu, 26 Mar 2026 13:52:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529521;
	bh=PIh+oFx3ncJBBFZxKgZDh/cS8gnROLybKH/NG8EuEkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSvCT8ARHlTgOPN8iOjchAkpapDdUP+zMSysoHauixmpFgfWNDNujXdRHIjg9pn8z
	 W3MEA1qMciJRFojm+GkOOJ1gBSbwE8J3EfMCFC1B0iW81P36+5UOKn0TGm6lyzGlbl
	 vzRj3SNysA8QMxAkEqwT9kdP0wmPmH3aEE0VsEGWw0neeZJsxTozzFYqICTgdHl30x
	 QcO90ORFBECeY1AMEsCBoML56tPiKXN5j2eE1EnDiFbw2q+7rHqRuPc+LpZaJMCHr8
	 ++ogzn/ZvF6eUrqtdNsrWWFLZr2ipJ4B0Bo0nRp7NR27IAVIrO9ZY/VnyBR7fIzNSn
	 p2maHa5FHpArg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/12] netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD
Date: Thu, 26 Mar 2026 13:51:44 +0100
Message-ID: <20260326125153.685915-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

__build_packet_message() manually constructs the NFULA_PAYLOAD netlink
attribute using skb_put() and skb_copy_bits(), bypassing the standard
nla_reserve()/nla_put() helpers. While nla_total_size(data_len) bytes
are allocated (including NLA alignment padding), only data_len bytes
of actual packet data are copied. The trailing nla_padlen(data_len)
bytes (1-3 when data_len is not 4-byte aligned) are never initialized,
leaking stale heap contents to userspace via the NFLOG netlink socket.

Replace the manual attribute construction with nla_reserve(), which
handles the tailroom check, header setup, and padding zeroing via
__nla_reserve(). The subsequent skb_copy_bits() fills in the payload
data on top of the properly initialized attribute.

Fixes: df6fb868d611 ("[NETFILTER]: nfnetlink: convert to generic netlink attribute functions")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b35a90955e2e..fcbe54940b2e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -647,15 +647,11 @@ __build_packet_message(struct nfnl_log_net *log,
 
 	if (data_len) {
 		struct nlattr *nla;
-		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(inst->skb) < nla_total_size(data_len))
+		nla = nla_reserve(inst->skb, NFULA_PAYLOAD, data_len);
+		if (!nla)
 			goto nla_put_failure;
 
-		nla = skb_put(inst->skb, nla_total_size(data_len));
-		nla->nla_type = NFULA_PAYLOAD;
-		nla->nla_len = size;
-
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			BUG();
 	}
-- 
2.47.3

