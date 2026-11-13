Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532508;
	b=hD20hfJvzCoa5WeR4QBGFab/5bu1lG0Wn2ge8+3d1TkLPTY3gx2SjkS9AeKx4BpHu98p
	 e23Zp/nNOA12DYpUk9w11BR/qHyO5LWU7NrR8C4h7rnSTix6lQ3FCsahQEgTVnVw5tdwZ
	 ywlPjHXcsZYClMJwrIZrc9RldSbLrIaSSYv3HrD+61rXJ72qCnwWyPR9ALexBmD81nYhK
	 cvY9yNTXxBCwC/NnXyVnE8dkII2qw46GrhOEu44U/Ch3KAXnnwz4Hg7zhMSAYLh6Czrpy
	 h79bP/XLeUNUGcbGsk4cLEaoMUXYcj4pWNykAlS0iyiPT29KJYCOo5Kmgn25ZSF0GYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532508;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=UnLggheEauYmSkvbgHbxqiUNagHbv3QczZGTkA9uNe0=;
	b=JiQnpclZzKqDTrPkdL/xjxLJmMrmfs8UOcBz3UNqe4fWlY2iMccxN2lZ90BRUnMNUApc
	 LsPESmDPbc3cIjbDeboDPA1E5D/DipozjWJGO3eEKFSkd56MTJAFh11T9wQgqsbtGo0Ww
	 uZ0CKfpDiq6dgkEGqeey4nqfdQ8PWTFlmrhiFKCFZa9tk8MmUTkUvT4NW6vJxeqJ8cylv
	 2oSwh3Jo6fRnDvVVUUmPAVzVYeLGMgJ7pYqiHr9R/9vn/g8KaWMefD3zMqj1x3uJ8SnIA
	 dghVLA51avTD4TNSfLeBfj5PKMK82wrE4fxoHI3asAXcuzGr2uDxhOPpudZToqwl4+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ibnPI5pX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0FC606A8A8;
	Fri, 13 Nov 2026 01:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC0FC606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ibnPI5pX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532506;
	bh=UnLggheEauYmSkvbgHbxqiUNagHbv3QczZGTkA9uNe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibnPI5pXIJDQukNGOyvcDZm+385TKu6qIGvn4RPpYZdRFpeTiiTvIwmLJdZqWD9sD
	 gn8HaeeV1mCq9tN95vnIzdesZRp2bwxOBFeVZ8xYZ5UxvN8f6SKqlXSILSPtlZFN5O
	 gGYHheZ5qngzjkmO2K67VchVTKTzcNgC7W5sr7Cgyx+C299N6/0gnCBymtGQaQKb/g
	 jwu2DyDl4/o0koFFyEOAlpNxJBbZ/7u4GPiLdbFAPTerh0SyZtBq67C7gNl3I23EJz
	 OoBhKOfgkJshnrQwHUsuMq5gYOSIkpsNHdOzM0zlxF+LoLktLNmtURNye91yNUCotH
	 vVjaTpt92R8yA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A81D160058;
	Fri, 13 Nov 2026 02:15:05 +0100 (CET)
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
Subject: [PATCH net 07/15] ipvs: ftp: add seqadj extension before linking the expectation
Date: Fri, 13 Nov 2026 02:14:39 +0100
Message-ID: <20261113011447.2357709-8-pablo@netfilter.org>
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

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

ip_vs_ftp_out() links an expectation into the helper extension of the
conntrack, then ip_vs_update_conntrack() adds the seqadj extension. If
the conntrack is still unconfirmed, which happens when the real server's
reply does not match an existing conntrack and creates a new one,
krealloc() can move ct->ext and the expectation list keeps pointing into
the freed area. Deleting the conntrack then writes to it:

  BUG: KASAN: slab-use-after-free in nf_ct_unlink_expect_report+0x490/0x4c0
  Write of size 8 at addr ffff888004dd4e48 by task syz.2.17/649

Reachable with CAP_NET_ADMIN in a user namespace.

Add the seqadj extension before mangling, so it is in place before the
expectation is linked.

Fixes: b25adce16064 ("ipvs: correct usage/allocation of seqadj ext in ipvs")
Cc: stable@vger.kernel.org
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 44de99f4d187..81c3a2fd27b3 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/gfp.h>
@@ -384,19 +385,25 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct && !nf_ct_is_template(ct)) {
-		bool mangled;
+		bool mangled = false;
 
 		/* If mangling fails this function will return 0
 		 * which will cause the packet to be dropped.
 		 * Mangling can only fail under memory pressure,
 		 * hopefully it will succeed on the retransmitted
 		 * packet.
+		 *
+		 * Add the seqadj extension before the expectation is
+		 * linked into the helper extension: adding it later
+		 * reallocates ct->ext under the expectation list.
 		 */
-		mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
-						   ipvsh->len,
-						   start - data,
-						   end - start,
-						   buf, buf_len);
+		if (nf_ct_is_confirmed(ct) || nfct_seqadj(ct) ||
+		    nfct_seqadj_ext_add(ct))
+			mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
+							   ipvsh->len,
+							   start - data,
+							   end - start,
+							   buf, buf_len);
 		if (mangled) {
 			ip_vs_nfct_expect_related(skb, ct, n_cp,
 						  ipvsh->protocol, 0, 0);
-- 
2.47.3

