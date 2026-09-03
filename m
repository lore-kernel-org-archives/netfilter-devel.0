Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E52931F5;
	Thu,  3 Sep 2026 00:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396121; cv=none; b=eppZb64310QkFGL/7sFjiXrw0ngc2kLvgnNjs7uBTVH6a3C4sF93kuSMwT+jmH8hA2l07mTdhgbljMe72dKuELSbVmDXlkzv27vOSWU92Fv2v3n0tB6Lg/0m4mXDvzszPXCJ5gUHCPGbI/2QssEn+TIPDS7yy0IKwBXLAFwFZlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396121; c=relaxed/simple;
	bh=ogxmNEYh8SWXfPRe313HfZDaNF1W8nAeDl81/4R28GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKhFWnmxujLiI8lkJmBXiOKKyq1c+hbVknmKELVepqvYGJzpI8os+ERWqhvth35a58z/5QwJPV2HvA6L+dkfoFfKG85L7QkvR58yQfXOxkvDwu9jnTTv5Fom0zWgaE2YuCLkoxodEzaCSTziwUVIPkcfGbRcDlBjUqRLCsiTQGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d56Z7kOq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d56Z7kOq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396117;
	bh=1yXqIV58sXy9JBDXSxnDUpCcuIJfw+yd+mIzGJkNuA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d56Z7kOqKnsUlwUwo+J9sAVT7tPKXC7nedrskolNOc6U/YN+UZQxg3azMBlImrlr9
	 2W6A7UyTvPEAaZdSCBqhdI/MpD754uuRfy7xecpsKvY74Qm5iEmEzExmNk1gW6iKEl
	 27CaFTz2au75VXmGgJ3KeNUGq1G+U9DcfY/6SKDvNw/Wo69TqGCFdJ3+9XAZ/SBI1E
	 7Ze/JLOCTxsKtZ5IRnAQp8QF+sh1b8zMa6p52ylM6+mkN0x8pL1qLaaBal/T9PjkRw
	 wENPQVRytFyTP2W2AWSkfS5pnX1bEFOZ+ZVg6tcGwYxfGstjHGB8v77rHPM0KW6aHh
	 TOPhBWMIDEgfw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 374F1607AD;
	Thu,  3 Sep 2026 02:41:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 02/12] ipvs: fix reversed sequence option serialization
Date: Thu,  3 Sep 2026 02:41:39 +0200
Message-ID: <20260903004149.1037028-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

hton_seq() expects the host-order source first and the unaligned
network-order destination second. The version 1 sync sender passes these
arguments in reverse for both sequence blocks. This leaves 24 bytes of the
kmalloc-backed message unwritten. It may disclose stale heap data and
replace the live connection sequence state with values read from the
buffer.

Pass the connection sequence state as the source and the message payload as
the destination for both blocks.

Fixes: 986a07579533 ("IPVS: Backup, Change sending to Version 1 format")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 1deb063cd72c..5383aeafb0ae 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -747,9 +747,9 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
-		hton_seq((struct ip_vs_seq *)p, &cp->in_seq);
+		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
-		hton_seq((struct ip_vs_seq *)p, &cp->out_seq);
+		hton_seq(&cp->out_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
 	}
 	/* Handle pe data */
-- 
2.47.3

