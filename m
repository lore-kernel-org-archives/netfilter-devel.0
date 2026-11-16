Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789867;
	b=ZXPbDO+MpBEdGwzXYf1TZ+kUc7jrucdsLDQFVNyIt01Mj9Qdpu0zJjZPKnxXhJetTeAq
	 qmdHWvxFHLlva/7a/k+Y/R4sKVsVBN7xl/5Ox1G4XiG2wbTy/hbSdoNFl3QTnDDmvwdMz
	 hLdbfBiF8dwfQQdaEJBG5K+JKhJkgDO8CC/BP0vujt/eB4jB6TUoighut5a2dcBqzKEZe
	 mWsQrGcrmw9hYNpuSHt/GMRysozJ8ZRiW2X43Poys6PotrVdeYv/vo0+2kSnVH40Cerk2
	 qM+CsgJDjWzZwRJCSxYVAy1tYz1nwZEMDrG+WQFGz07pKLYPl4Ad9fIXKcCnxlUiAFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789867;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=SNaZg93QoJFoyUqJdrg7u3we72+lDKRsNMRyQGErX4U=;
	b=Q2YgOoOzNP0E1T4mKIv3ff4ml0w6+hasjhpH1B5JCQ/4zar3d5hTi+UFP2sMU4wC/D9h
	 zkLthJg4jhSJrUG+muP5269g7xOUWFbX7FRQeomdww1we+MqYrQaUTnVblC/4Ce7f+TQE
	 sCZD72fJM6cQAHBLnqWzqLh3IwVLTFIQyRwEtjk2LTOtjj3QlRTIYW5A3vMcpE9mwRgq4
	 Hsr1luKJfXJJrdGEO8mChdbY12ArzqmGnlFn8+g4fD/MU4EP6WiuM7VPmU6k3Kc1FrleV
	 68Xqn4bz222EM5FYu++DpXIhOVdKesZh/2F49qOBkCtlshcSROYjjREKG166trfGcEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BHA29l5p;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2EF606A884;
	Mon, 16 Nov 2026 00:44:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C2EF606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BHA29l5p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789865;
	bh=SNaZg93QoJFoyUqJdrg7u3we72+lDKRsNMRyQGErX4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHA29l5p1lflhdAEl3uecqc3dgn4W9vvs3/0HgNBWC5Wx92xQe/hD+Cxg9fGnExJ2
	 +pKth2NCZhnEoq6xaR1/sDEyG2m6PcrdHCV7kbRWrDF7WLkmbIVhwJjptcXYbo95zA
	 FHX6L20zpz/H4QKywjnHrnXUFnMuXIiP6HEGsVyWU/6dZiecU6isfZnkV5tQrAYQJQ
	 OstiBKOnox1+Ujm9HJxg/X0zWVWIP09df9wc0BhA1pFfSgAdCFBPocGico+/6QQ6H8
	 xrYAgCe7UQBvelQn45HzrD9AF7jxJ1G8EKqaa/zrUNM72n+SFYZ0DOoUFaT0lPeS9W
	 rHXBwr76ErSOg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 01C766005F;
	Mon, 16 Nov 2026 01:44:24 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 09/11] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
Date: Mon, 16 Nov 2026 01:44:02 +0100
Message-ID: <20261116004404.2821183-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Axel Mierczuk <axel.mierczuk@1password.com>

ip_vs_conn_out_get() does not filter templates. A template with
cport 0 is matched by a packet sent to client port 0 that traverses
the out hook, and handle_response() then runs ip_vs_set_state() and
the timeout update on a connection that must never see packets. A
backup server receives such templates over the unauthenticated sync
protocol. An ordinary connection scheduled for a client that uses
source port 0 has cport 0 as well and is matched the same way.

Apply the rule used by __ip_vs_conn_in_get(): a lookup for client
port 0 matches only connections flagged IP_VS_CONN_F_NO_CPORT, which
still wait for their cport, and a lookup for a nonzero client port
matches only connections without this flag. Test p->vport, which was
already compared with cp->cport, instead of reading cp->cport again.

ip_vs_ftp_out() relies on the first case: it looks up the data
connection with client port 0 to find the IP_VS_CONN_F_NO_CPORT entry
created for an earlier PASV or EPSV reply. That lookup keeps working.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 66fcdc00ef37..83d8a9153a34 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -590,6 +590,8 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 				    ip_vs_addr_equal(p->af, p->vaddr,
 						     &cp->caddr) &&
 				    ip_vs_addr_equal(p->af, p->caddr, saddr) &&
+				    (!p->vport ^
+				     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
 				    p->protocol == cp->protocol) {
 					if (__ip_vs_conn_get(cp))
 						goto out;
-- 
2.47.3

