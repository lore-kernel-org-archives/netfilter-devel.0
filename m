Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0D377AAC;
	Thu, 23 Jul 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824790; cv=none; b=aCyrGjHZz/IuOsUsD1ANuHIdTKkum7H5LMfs2pXNi1uGv+90NukAkrjq+SwBIOfxGDh1XzJ6g1FWol6L80GkvNeMImrNr//H/7T5InMnP22HZS2/PHpcjdAVyalOofzsRFCOnzVjbMkaYpwtsKd5aV3uStfK6tR8LJfVU9HLeLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824790; c=relaxed/simple;
	bh=YhclAeWYDLdey4TkDZxyd6FSP3IzcQeKqKHe99VavRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5sj1tLluplWppEGD6bKppce6KAWgchYjDabw4uN/H68WOSxEbBORAQUda8DpqsW9RtK/Gud9Y2r+9LB8bNdJIwR6idXnJ0ZBTCBLiesjA7griK8v0pDSy4G6EarlicLSN8A9SQULZ+vckw7GGDm3k2SfZffyIs4wPlVnM7DYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lDUHnnYG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lDUHnnYG"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E51EB601BE;
	Thu, 23 Jul 2026 18:39:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824774;
	bh=dBqtcj8toY/8767FJ/TrtJvXBZw6WmK2Z1Wwedwv9g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDUHnnYGo28Xn1xV9oOzmP3e3AxmKaJThhgVBHKFn95lBBF4v48q7YTeXuSCecA5E
	 fX2TdqyE4T8bsOcumtJfR/XiBu0rU/HpwYnhAvEm5UqZOUWVapDBuRWfcnelr3kxgI
	 /4Xa+zjBMVHkwOgWbw/EQUgfBLzvKd2Gm1x9tlRjIxM1ph1yQUpPTq6nRl+0EhdE8P
	 /keRROl5OkUfOqXUNxMihPt7HuC/aoBO+5IEw/Z6hKmdFMBXBmI6dCraASYJ0C0xLR
	 QpgqgLPEdAX+AG5YQs7RrloK9PYVDozKu1rpjd4QRLNRgv00oRiB6leHOKoIF+5zme
	 a5ZZvi4mDfaRQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/13] ipvs: do not propagate one-packet flag to synced conns
Date: Thu, 23 Jul 2026 18:39:02 +0200
Message-ID: <20260723163910.274695-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <roxy520tt@gmail.com>

Synced connections can be created before their destination exists. When
the destination is later added, ip_vs_bind_dest() copies connection flags
from the destination into cp->flags.

IP_VS_CONN_F_ONE_PACKET connections are not synced. If a synced
connection inherits IP_VS_CONN_F_ONE_PACKET while it is already hashed,
expiry can treat it as a one-packet connection and skip unlinking the
existing conn_tab node, leaving stale hash nodes pointing at a freed
struct ip_vs_conn.

Drop IP_VS_CONN_F_ONE_PACKET from destination flags when binding synced
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6ed2622363f0..0682cec5f0a7 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1014,6 +1014,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	flags = cp->flags;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
+		/* Synced conns are hashed, so they can not get this flag */
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
+
 		/* if the connection is not template and is created
 		 * by sync, preserve the activity flag.
 		 */
-- 
2.47.3

