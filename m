Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532515;
	b=d2A0TmtN20hSxpg5N8Bl1Vbd78eO37M2VdLSFBcKjbEipZp73Segw5uPnBtTEL+CLW4G
	 FfNivPsPs5dZdBoJ7ws4/Dhc6CUc7UYs2PnG6ArsgxHiR+5sokTW9nIZtseu+UsbKDEwj
	 6FD5WTLvksnGc5Xv3oxNRP5N98DkmOvSo8hQjWZuabYeFibhE5kAUmJc8zHHX+JwaL5/N
	 rIdHl/mRZsrP1K5SeFC6KvIM7hasdY4BDKuroqUDZ1+JQ/4cfIE+p35zKdklgP5f+A16Z
	 kq2W7sV5xtkDdS+5Ubfsn75kOcdrO9+YS76X8vSRJZLM5AAttsNYmbTpHmTjKOrHpDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532515;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=SNaZg93QoJFoyUqJdrg7u3we72+lDKRsNMRyQGErX4U=;
	b=tGmvOBaveJs9Z1y6qbAeqeLIMm1qMd6WRcuqdgtv+a1U2266PUvFgwZvHZJV36J6YGcI
	 uUomSO1lJcp8ouuuVy9I9TSwKeBDqx/puAReB18u6q54Nc5IhjDqdEcaCXP1R80WcatXi
	 oVjMMQTwsusxkFcapoqpXxg0u93ygLn4mNmNAy22WNVBvB0ja/acG2v/H5BvJ749R2ltS
	 3GU4oMeCprQUoWIZsP62hRVOJp4M5V9mA9s3ro/kE2ShaBPhYlQixwIvrGlfRbmYbCQxK
	 Yl0X68XdlqBS5Fd6w4j2FJ+qyrnulv/VLNzuJwon9+0w088ZEj7h4go74Ifblmft3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tQcpmk78;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C60606A890;
	Fri, 13 Nov 2026 01:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35C60606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tQcpmk78
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532513;
	bh=SNaZg93QoJFoyUqJdrg7u3we72+lDKRsNMRyQGErX4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQcpmk78yVs8brKGAq20FzBejxsiFoGdtFntzUwvBUcHBCgzd8P216BDjdhnfnUn5
	 7ENeFYpTUqUCmfR7YQ21rky4HKVN/3131uHPTbuLX5a4oZceZvJwaUAi8z/CM3IZaW
	 gBJ3qIpIHuXOOU/06wIGYndtUX1oKGWMjakYCmT0CsJ7TKD8zXoDA9z6rL97+veKGn
	 8gQOLzBlpJDuqNEzqS6GMpwerdOQaKPBrNxOCJG/JC/jBIgGNnX9iVtqxx5GOzoKz2
	 yatfjfqfhp7kuAE0orZ2gahM7qT06zTo3HT2+nNcrJy5Xamrt1pATzweEmNoNLVMDj
	 D0M8bvBYf9sNw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D15396005C;
	Fri, 13 Nov 2026 02:15:12 +0100 (CET)
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
Subject: [PATCH net 12/15] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
Date: Fri, 13 Nov 2026 02:14:44 +0100
Message-ID: <20261113011447.2357709-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

