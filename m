Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BAA2882A6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236076; cv=none; b=fPPS/d2dWVoeBj4GE9Jx3gIUeW5p2kHSrECdOOWoQuzTznr58Ui7iuVPCt8s+/ig+7bD43B3ftI6MsQnbv4KY9hDI6edHU5etGm6nmrJzixmsImtMEnytaLfnkf/Ge+dxbnOrtkTWAKxfkWq9HCJhs25PL2xsE6BZXdE/RgiY94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236076; c=relaxed/simple;
	bh=cGBenr9l7UEwaq18bH0g85ALk42EnZZ0I2eQWoh9LiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs0bR0O7+P89Oig+Bak4hhp0/tekHhZfmirGkvY1jIQHjIMyyjvTfMDt1r5pMQgtf6tpJNzflts9XmSyrV/kBqc6nhwE2C8HvpIHZlCyLLMSVeCKzqFRw+LuzH2kOvb1DxDy00G8+9iuDDwYddragY1t3Wpxo8oUx5DcSudYgFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hHPJPPqE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hHPJPPqE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kS/TJzM1jMQ1meKhE8aCGPtnXGmgVOw17dTq/GdLEOg=; b=hHPJPPqE+oa/HzGNzsXvLDMxUQ
	8BGwCpwTFJIC3lbmW1RLCmqO7WDPZ6FrzOI9zqgfBMRmEPjjtFr909gCrwdqX1I1zivYJ80KNH7IJ
	tBMpuSmLHIR63xAl9PeJri2Dy6zNS3qSYcz+ZiK8ZDnqo/gnWX4nypbrGVNfk7jc8WADqG7CCTKBs
	yA8CkRrfzUO2DPv4erx22FYwjFl3tP5NHmxLqQIDVBA6e4UC6d+/Np5mQwwZ0yUgFquQfq3eRS69u
	qOVN5LTSvyqk+U5AUAf/m7Q7rJDkRDHV/dbWPJC67NBTVKqj6ee17Nk4VCDXitNpz4ZwajkhIpPoe
	EhdgLhDA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxQ-0000000005d-0KvR;
	Thu, 23 Oct 2025 18:14:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 17/28] segtree: Export complete data before editing
Date: Thu, 23 Oct 2025 18:14:06 +0200
Message-ID: <20251023161417.13228-18-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Big Endian export, this did odd things: Content in 'data' appeared
at the end of the buffer, so given the parameters mpz_export_data()
actually overstepped boundaries.

Fix it by exporting the full data (just like string_type_print() does)
into a large enough buffer, then create the constant expression from the
significant part.

Initialize 'data' to zero just to be on the safe side, this is actually
not needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 5a334efc8bebb..ab107493ea97b 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -403,10 +403,11 @@ void concat_range_aggregate(struct expr *set)
 			if (prefix_len >= 0 &&
 			    (prefix_len % BITS_PER_BYTE) == 0 &&
 			    string_type) {
+				unsigned int r1len = div_round_up(r1->len, BITS_PER_BYTE);
 				unsigned int str_len = prefix_len / BITS_PER_BYTE;
-				char data[str_len + 2];
+				char data[r1len + 1] = {};
 
-				mpz_export_data(data, r1->value, BYTEORDER_BIG_ENDIAN, str_len);
+				mpz_export_data(data, r1->value, BYTEORDER_BIG_ENDIAN, r1len);
 				data[str_len] = '*';
 
 				tmp = constant_expr_alloc(&r1->location, r1->dtype,
-- 
2.51.0

