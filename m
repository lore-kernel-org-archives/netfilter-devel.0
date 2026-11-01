Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793572614;
	b=tBG070xcc8NJROgLYATuE4dpQimpYprZl0TtbEXVV9qEkH47CpxenSxyk2x7Pgpr52eq
	 NMIhzLIBiJp/+ZnYNiN+55TA0gJWaYJUzg5umhjt9du/7mrYgmQTH9dclsgoho8arDT8D
	 yWXRjLlrvEC/psZaQXjT6zIRnRZJTI6OMBJLuVSbDFQG3CmhtobElOluknFf9s8sLeDhV
	 UqEOwr9RcfOKpnRbNFGzgR4OrLaCC8dlNTClDy0ZJ+rPFCwJhAibL5KgotrQNLEVHaH8O
	 +IuLNXnAM8qsXWbRZ1n+NPVmS96qJE/BuubwSHrsufXMSfvoOLfYg07CCYYFzMOL+VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793572614;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=UoOI3jsmWer/TIn9nziRtwwXmGEWEEzJSuSinqSOf+8=;
	b=4Y4IKd09qphpw7Fhsn4GOZGj1K3PiSGQuVIazATGoNMqQ5LG7pFdNEcackR1jfk6i0UI
	 Z8kBknOrtyBGH1MCOAQCRYdFCOeDDPRBPjdQ7xK1Jb5X+unMpbhBIZr0eKrMDLwvtCXjI
	 hHcVyyB7B0Q5kc5GB48nPXfEGk11Jkxbkp00na5r1IM6imbDU6hzTEUjKTBfE3bm3mo7E
	 islGzkCYVSiWGyr7mwSs2LoTKml5iU4OeNpPliJACf6XW9qcqGeg8UReQlEnzw9POAPNn
	 24gCf4YtIU/otVAohUpFsnxhnx5DjioXAqLX1kWU9kBJrCAuqQy0xgObPzOVnRLx+1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vcks8mtS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374FB606A324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 22:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 374FB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vcks8mtS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793572603;
	bh=UoOI3jsmWer/TIn9nziRtwwXmGEWEEzJSuSinqSOf+8=;
	h=From:To:Subject:Date:From;
	b=vcks8mtSNnCZU5JcISfggMmVs6M2O9uSizRuFAMa4UkZ9qzYgJqZuvsYhhQmUUSmL
	 l0hVVAOXdgHSDP+LMArR5cdS8zuJGKitOxMtvhSSxlVDvr2LTCZ80Lsl48zVEQGBON
	 i/t5N58DoLXJG/39EDGjXTiGLI79foosXmmHuRr7JrwH7Pc+t+AjNcxz4pMRKCoDeO
	 sct2aSJ2Qcpu3+ycP7TbyiWcWXNf7DjY1r6PzREDtadcDzcekoxCr8Jtc5CC93n1ig
	 imnFrNxC4mtL56TGs8eqLP4uyP3PiPg74V9oVZQ8r7+co5C/6U7F8RUb5DDMALa+x+
	 6YGY58mdO3zvg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BD7D960056
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 23:36:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_ct: reject expectation if conntrack is a expect child
Date: Sun,  1 Nov 2026 23:36:40 +0100
Message-ID: <20261101223640.444247-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

The nft ct expectation object can attach its internal helper to an
unconfirmed expected child, then arm the next expectation with that
child as master, resulting in a long chain of sibling conntracks.

This custom ct expectation support barely works for one limited
use-case, skip expectation creation to address this issue.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261007013301.2524415-1-4ncienth@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5a8db5592036..a6013d6a110f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1254,7 +1254,7 @@ static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
 	int ret = NF_ACCEPT;
 	u16 l3num;
 
-	if (nf_ct_is_confirmed(ct))
+	if (nf_ct_is_confirmed(ct) || ct->master)
 		return NF_ACCEPT;
 
 	expect_data = nfct_help_data(ct);
-- 
2.47.3

