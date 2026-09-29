Received: from mvsmtppost29.nm.naver.com (mvsmtppost29.nm.naver.com [61.247.196.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C1E3C5DA1
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.247.196.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673056; cv=none; b=MyuF68sAFXN+pyUDsyCywZLsgQgEScodV1EUobWdZSTcQ2NKeGwChPvp8sFDOeDuWAI97ZauKyU7rOJ9SKN1FPK0xk5RvScd04z31yX9UIm4ahtlfOV32E05msU/fo0QRLKSakbEl8poExDAZ0gpUtwl/8XcvZ3cwiW6DhCBZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673056; c=relaxed/simple;
	bh=Cr0LgX6m3eBXuxkyrt/yeKn6lh+aU3VMC1DFijxC+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D2DEIKcjJ0eA5e5Z9Mexh71/c4CiTYmHe4QVsaSWda/tZtvc4Vd94RigsKj3P/lWAc6WihLTmdfny5+YX7v6zlQhNXDldC9ufvj9BxOvGpwJ93GTEECwLFNdnFstumUTGhLdOtpUuHS1ctuD6CNJ5/pvAjEqDdpBlUxYLOIsH4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=JuVaCg1d; arc=none smtp.client-ip=61.247.196.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="JuVaCg1d"
Received: from cvsendbo016.nm ([10.112.24.39])
  by mvsmtppost29.nm.naver.com with ESMTP id mju7s91fSyyQhm2UQK9PhQ
  for <netfilter-devel@vger.kernel.org>;
  Tue, 29 Sep 2026 09:00:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1790672435; bh=Cr0LgX6m3eBXuxkyrt/yeKn6lh+aU3VMC1DFijxC+tM=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=JuVaCg1dg8NKhYp87O3Xv20oYpFIT9CrwD6qm3KHN6zhJc4DR5TqmuFRVi9Hz2+ts
	 pusLmURrRQ0w40XPhMnuaZRupDNyXzu45hcNcj1H/PNFwy9IIljD8OB5IaUP8KYTWD
	 ffkdPy6Z/18OBO2w4wFQJuzyvqt6xsaSR8SWOeQGgu5Az6wqafUhg9ABpk85TkK4I7
	 HxbRcMDc3qFGYiCISX+XhTBgS83gPPE95TwMuTr2kjgTQLwWAaVH+6Fe/xo95qY706
	 txGdyY1z7z9XuSBEc5rvxMJz5RDadkR/Qy6RbbnCB0t0vrYY9DRyM2/5LRq+8d86/6
	 op4wPxYebAfIQ==
X-Session-ID: 3Gsz75-GSnmMt8bnybLwCw
X-Works-Send-Opt: OPewpzGdjHmdKHFOMr39Ko3YKBmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: smYdFoglFqJZ+HmdKqgm+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp002.nm.naver.com with ESMTP id 3Gsz75-GSnmMt8bnybLwCw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 29 Sep 2026 09:00:34 -0000
From: tjdqudcks0424@naver.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: nf_conntrack_reasm: avoid truncating header offset
Date: Tue, 29 Sep 2026 18:00:27 +0900
Message-ID: <20260929090027.200041-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: 성병찬 <tjdqudcks0424@naver.com>

find_prev_fhdr() stores the offset of the previous Next Header field in
an 8-bit variable. A valid IPv6 extension header chain can place that
field at offset 256, causing the value to wrap to zero.

The truncated value is later stored in frag_queue.nhoffset and used by
nf_ct_frag6_reasm() as the index at which the Fragment Header's next
header value is written. With an offset of 256, this overwrites byte
zero of the IPv6 header instead of the preceding extension header's
Next Header field. The reassembled packet is then rejected because its
IPv6 version field has been corrupted.

Use int for prev_nhoff, matching the type of start and the prevhoff
output argument.

This was reproduced on Linux v7.2.8 with KASAN enabled. Before the
change, a control packet with the preceding Next Header field at offset
248 was delivered, while the equivalent packet at offset 256 was
dropped and Ip6InHdrErrors increased by one. After the change, both
packets were delivered and Ip6InHdrErrors did not increase. The
before/after result was reproduced twice.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Cc: stable@vger.kernel.org
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49bf0a0a..be72c4346f8b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 {
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 	const int netoff = skb_network_offset(skb);
-	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
+	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
 	int start = netoff + sizeof(struct ipv6hdr);
 	int len = skb->len - start;
 	u8 prevhdr = NEXTHDR_IPV6;

base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.43.0

