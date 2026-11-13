Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532500;
	b=12EYGe0oqqAWMLRuArEjQFUn1Tst67f9VK8DSBFSB8V+oEl4iFk6+eNaaE0WRNk1N5ar
	 2OeRWWnCXLttWDNT/HbbozCK5XQSdrj4jba2yeeDJlIQ2IS3Ooycp+Y0WIBvGNsFamrJ2
	 FoOlFEeaoRPa5wweHuYTTB2leH+vPhUAxxwuSwAKQE2SxndI6pvZiz7NsPkl4eJXHr5Bz
	 cX/CNpB6YqwbwYTBIk83LsFrs8QflE9gb/LNNSa8lvp47/jCUpTjuB4expTEy9/tFt9n2
	 A5nNHdjGZEZjNWetfWCa97Ho06jv9VRdbUr1Cw8YDmtDhkS0XM+C+A8voxorhsPpohg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532500;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=zzEsJnJnM1bQXthU4+437vS4Xm/cQAtHw6bJmg1IONE=;
	b=tVugAzNV5g17WplV4aGHrlafGKb2QlUERxj96Jw3dsUBEzDTZ3qZ6FtfgymQVoV+cJKi
	 dP0hqrp8b9lcqRh5GbT2+COwJ7+lXtkh4GbgsZGt1NOtjGTEo1uYlmlSxPjV/XrAcZqFd
	 FM0UpNnIhdpvNgxePUs3n9JMr+hRLPUFDM3J/EAFHzfMioZyhYQhNMaHh6Zr5jyiPgcWr
	 0XpQr5jQyKQLLFaIoBN5mIqSkPsrzzS8Be8V+8lqhRGJj2qs5I+PJ7SZ3zhSY/Y8LFIGm
	 Air/Ex3OoK6ve+nwFRulPUeHg1a4D0JXc5gjbdyXD/8opfQTcQpKBrTWbWSjVYg3mfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S3duZu2R;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61104606A333;
	Fri, 13 Nov 2026 01:15:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61104606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S3duZu2R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532498;
	bh=zzEsJnJnM1bQXthU4+437vS4Xm/cQAtHw6bJmg1IONE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3duZu2RNJMgqFlSR5qyfemWOVEJk7CLxGNhx3v4Oeu+x5/yDE0DhjWu+lQakoK1i
	 IkxE28ZVxd4vBY7xVxkGSKDC/6KdjrvS08XA/vrQMJBkXQzklu4CIe3TI87BlOI3vQ
	 JgBPoH1z4an41Usg5FjMXFTG2ggIQHH4NImEdvOQUhmdi2CvP2DMGzJDrWuF8o6OT7
	 n9ZravCuPxf7lgpNV6UlR/aQJhT5a+8hJY2gNfrnzGMUJH8SPpiIMGm83EB7cui4aP
	 vePNQ4U7tc9kpbqeQVsDUIgXJA9WptdBVOnt5R8YSLYahRgAy1NcTYsMeiwTVskJBn
	 3SbiwcnmhMkNQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3C5AA6005C;
	Fri, 13 Nov 2026 02:14:58 +0100 (CET)
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
Subject: [PATCH net 02/15] ipv6: update *offset for non-first fragments in ipv6_find_hdr()
Date: Fri, 13 Nov 2026 02:14:34 +0100
Message-ID: <20261113011447.2357709-3-pablo@netfilter.org>
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

The non-first fragment early return is the only successful exit of
ipv6_find_hdr() that leaves *offset untouched. IPVS used the initial
offset as if it had been updated.

For non-first fragments with target < 0, set *offset immediately
after the Fragment header, at the start of the fragment payload.
Callers must still account for the nonzero fragment offset. A
NEXTHDR_FRAGMENT search continues to return the Fragment header's
offset. Other target < 0 callers check the returned fragment offset
or ignore *offset here.

Fixes: b777e0ce7437 ("[NETFILTER]: make ipv6_find_hdr() find transport protocol header")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/exthdrs_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 4a9748338cf4..e27f5b8cc154 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -179,7 +179,10 @@ EXPORT_SYMBOL_GPL(ipv6_find_tlv);
  *
  * Note that non-1st fragment is special case that "the protocol number
  * of last header" is "next header" field in Fragment header. In this case,
- * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
+ * for target < 0, *offset points immediately after the Fragment header,
+ * at the start of the fragment payload. Callers must still account for
+ * the nonzero fragment offset before interpreting the payload. The
+ * fragment offset is stored in *fragoff if fragoff
  * isn't NULL.
  *
  * if flags is not NULL and it's a fragment, then the frag flag
@@ -261,6 +264,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 				     hp->nexthdr == NEXTHDR_NONE)) {
 					if (fragoff)
 						*fragoff = _frag_off;
+					*offset = start + sizeof(struct frag_hdr);
 					return hp->nexthdr;
 				}
 				if (!found)
-- 
2.47.3

