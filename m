Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=83.166.143.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992753;
	b=QEkPTHVdEIVVi7FxCgUIYQLzbrRohKDVms9RQbEEQVibjnRSE+PXkfoYR9jZEHVmen5W
	 //gNScuFRiNImzOmcBjzzwAMIdUq1O+kD6DFTd8R5Cvx0KZZKDsKmviSX6zj2zk07WHBw
	 e8XMLBSSfMo2UjNLwsPbV7xLOG+QiDCZzCeYpqBOBvom7u65i+efEyhYh8Bucg3c2Sn8A
	 dKpSnTOkqT86K2R3hryeecciig28jdgiooDLOYNt4Ek2Uh7BiB6A+cWSQcm4A7oswTSCJ
	 b1ImbFlGeaFQ+qSumRnu/Va/QQOaeSSHN0qIcHs/v6D1xWjU0Bnt2Tx7ELBiyop+0Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992753;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=BcF9S88V9dvN0dmDV7B6phwWo7cDzEEKifLzTLy53CI=;
	b=HjpG0dvFoBr7eTDE5zXmmM63X3eRPgk0b8RoTn7mLChFmdNehluyMPzbEwZEZy0ncG7j
	 hJjA6xScg+YVDfNKTINzXcQAPNdVnicfbRO7NQuzcOD+fr0wRl95ssBzp9kdVU4K2KLUV
	 6iiJJzoN3AohSlXfevJovmww4Vs4j8ZTK67kVijb7vDRcTDreFBETKaW87T6e5ZIwtiVI
	 Ab29lh//OMJSV8mJeIwr2s4rVCvY/JBpGHbKltps3VaS1janwcelm3p/ZKGsAmnIgvj5D
	 D/SXVcQIICYtbJ0BwE9vts4JuVyKtqxsk2Zq6nHGffvd/1Bn3yu/cieq8RfnXyMThsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=14HLE91K;
	arc=none smtp.remote-ip=83.166.143.170
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C930A606A32D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C930A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=14HLE91K
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprS1MGyzmbv;
	Fri,  6 Nov 2026 20:19:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992744;
	bh=BcF9S88V9dvN0dmDV7B6phwWo7cDzEEKifLzTLy53CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14HLE91Kza4LraxcVRj5bKjvEhBoaipTcjZcxtUiV8YWOg5hrcEHZlcsuP9dmD0ds
	 Jkbt4Cth1jB32TFJak4kj8Rj6vSeXRxatNqrdhFyKflz+iLiu3169Hdt7m7r6Tdxnp
	 Iar1EVj3ENssFUlaXqNstrm/YuSbeeneibVpLBJo7xpKnrPYmspHWAtpctUYPGfoFv
	 E8IYnpmNKyArILcpuQLFCxIlF1cnmx0ceo3xCiXtWHuw9hvgudFwOfpl2R6jtQVsyx
	 maXIXuC0ukaV9qkyfzXjcN00do+aQQBcIORDD39OVS5gMvO38B3McoAuhFoSHNTw5v
	 gSkqj4nPgqPdQ==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprR4fjBzS2j;
	Fri,  6 Nov 2026 20:19:03 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 2/5] attr: account for alignment padding in the *_check() builders
Date: Fri,  6 Nov 2026 20:18:37 +0100
Message-ID: <20261106191841.1645-3-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
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
X-Infomaniak-Routing: alpha

mnl_attr_put() and mnl_attr_nest_start() write the new attribute at
mnl_nlmsg_get_payload_tail(), that is MNL_ALIGN(nlmsg_len), but
mnl_attr_put_check() and mnl_attr_nest_start_check() compare the
unaligned nlmsg_len against buflen. If the caller left nlmsg_len
unaligned (e.g. after appending raw bytes to the message), the check
passes and up to 3 bytes are written past the end of the buffer.

Use the aligned length in both checks.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---
 src/attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 20e99b1..0254190 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -600,7 +600,7 @@ EXPORT_SYMBOL bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 				      uint16_t type, size_t len,
 				      const void *data)
 {
-	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN + MNL_ALIGN(len) > buflen)
+	if (MNL_ALIGN(nlh->nlmsg_len) + MNL_ATTR_HDRLEN + MNL_ALIGN(len) > buflen)
 		return false;
 	mnl_attr_put(nlh, type, len, data);
 	return true;
@@ -745,7 +745,7 @@ EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh,
 						       size_t buflen,
 						       uint16_t type)
 {
-	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN > buflen)
+	if (MNL_ALIGN(nlh->nlmsg_len) + MNL_ATTR_HDRLEN > buflen)
 		return NULL;
 	return mnl_attr_nest_start(nlh, type);
 }
-- 
2.56.0.windows.4

