Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416516;
	b=WG8u9t0UjEpb+fH1rTLz7b2FBywZfz3RCKQbgiAZP4R0fARa98A3oMhOgJeyDaRrNPyr
	 ua+bVo48N4iv73ycRZHePhXH2QYF5lV5fqHDQAJPqv+bpRdHCXyrliU4I/f8FHHTnfm/g
	 hADdFfs7YFxomkIzrRddR+bW1rAFm03jPZsVYPrPnh2QDyDdMItpo+CtKkr9MEgKvvZ/I
	 D98OXqTfBawfQoax4Sn5viwS6x/z+8a84oxVuBihMT/csJfM25M4gx93pDozh+xSs4JwD
	 rAkgZWRGy4TQ0/2Li6/fAO5K9rklD5R4Mjr942ySf32WMkr/MHp/4aQeah7S9AFiSGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416516;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LGe3Ky4cqkNRa6pHqFN2PvHwNaDOFf35av2DuVOd6oI=;
	b=0+Co015sD9bc4hQRHGEsEOGCgvpfLfMsls+SiVdnrTMyG8aYOne4qThR/A7LK44zJkZU
	 mKFZVKE4NQyU/ZC/0J+dLFIon8D7tiZ084b1pXbUf7eJgi6QCS015Ku+1paqLIjThohPB
	 /qM5T6HjhTGhYO49ijc6UOjtlOVo0bOEtlHcfPUsDKPgTJUk2w/IL0l8KZnExltg70UJ0
	 iJT+Qbx3Zr4oHIxeGF+mrkhRShEjny00iV4s82lYG+kQgKil+hTuUPiVgOa0uY0+0hfzi
	 jxLyIuKmwe+g5h+4gIt5L9Zy+OQHJbzxKh3I5upb23WEz63nXFCR5Mu9pHQFNYnhfFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=WyDDEkZg;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FFB606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 17:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7FFB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=WyDDEkZg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LGe3Ky4cqkNRa6pHqFN2PvHwNaDOFf35av2DuVOd6oI=; b=WyDDEkZgVVYhUwxbk1koignilq
	xzZk1rkH4VuZJAWHFucbRCBglUKqfwbUx+qlNS3xn6l9IBfFU4hYS3exllltUE7ZXW7Ds7zm7LtGX
	N6rGideJ9fw+U0oqvrMZPWsJfJ/phVt67tbQFXclS5YltKSyMsBxRVSaVSbx7/pv2h5oTngg0zI7j
	1iZ+pBkFL0gpZWNnxopBWKHbyvf30+hZJKVZEq2fQZ5Mrme4gRnyELUEIXfIA1IRmVSN1PkzAzMwY
	lvEn0DCelTnE6j3SLZ87YQ2K27sTI+k7fTnSKxM1ok2EgsfqjpPb3lDCD25xZ0pIBLCLZXJGJBw37
	TbkR4Xkg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRBhq-000000006yr-2ZL9;
	Wed, 11 Nov 2026 18:01:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/3] netlink: Avoid storage leak in tunnel_parse_opt_cb error path
Date: Wed, 11 Nov 2026 18:01:46 +0100
Message-ID: <20261111170147.47501-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111170147.47501-1-phil@nwl.cc>
References: <20261111170147.47501-1-phil@nwl.cc>
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

When aborting geneve opt parsing, free the allocated object.

Fixes: 59f03bf14835f ("tunnel: add geneve support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 8916370604c08..452721ec0be96 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1960,8 +1960,10 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
 			gnv_data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
 							 &geneve->data_len);
-			if (!gnv_data)
+			if (!gnv_data) {
+				free(geneve);
 				return -1;
+			}
 			memcpy(&geneve->data, gnv_data, geneve->data_len);
 		}
 
-- 
2.54.0

