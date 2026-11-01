Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793572755;
	b=ybB88sKiQ77w3zPCZQq3CrN4LuquwLPdJOk9jXwpZ0K/MZ+zLAkaG8nshHF0ceIW3Jb6
	 pBrrhUrVoNVkoNZSzIj24vmBgFwGwGrJa1Euntz0kQ1S+BmA36QUv6yEjrqhjge6AzL5N
	 bt99kblMrwbCqReZLlPmCUggRboRooyleS6R545woLX+DclCEjCSF0qHcxI9oR1vngL0w
	 37ZIPwrIAMCYKUdL0M3upZTNcl9JPUA9kwPL55A6sld016eldLnpZscqQmSbyvfga3aYV
	 r9svqxbKNeErVVMN/xg2NyfyNyvQrfeXgKgpX8gCUMp82wweF1Ut6Ba9QlCoyS702Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793572755;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=UoOI3jsmWer/TIn9nziRtwwXmGEWEEzJSuSinqSOf+8=;
	b=jt1eYvN11ybAFlh0s36MRuFuQsipglCeA6XRaolb5gADI5rVLVJgPBZ2QtQdKvCEBY3Z
	 GbquCh3qxEv5CM+aWCNsb1r8/Tsopwy1X5p4CaZIiK9gogNfYOj5Hyj5ZHbpQgywwf5d+
	 Q4JmGiH6WmYlqL0WVwgZ86+XP7p30a54uIwB2baNUr4mktmV86nJVoIeviP/S4rta77CN
	 RHY4t575xknJ3KC14N4mw+d83w6v/SA8h5owRwe5jMIgUwiwKfnyCcrNkkBTYc/M5uSk6
	 nFPjiuzWq7d44uh6PYILbiNeK6ycj8eb3UoFt4CKI0QXxKFuGq8E0a1+1P09gXbX/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pvYq0kZX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F19606A324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 22:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40F19606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pvYq0kZX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793572751;
	bh=UoOI3jsmWer/TIn9nziRtwwXmGEWEEzJSuSinqSOf+8=;
	h=From:To:Subject:Date:From;
	b=pvYq0kZXPAfUBjowW711WA/7vjYid4s06hxW5yn6OSqCZ7v5Whj/ttXlXjvUMlMHp
	 DBCALBHeTlIKogqcOfyKk6YDJEYRuCdxWX78bpEAad8jpWudZrx7G4PIiT6MvUS90d
	 tTDDIxn99ngoQ/blgns214PykFW5NPItY6s7kIkikyqSaJdvoHMJ5dKjPLMIkd+diM
	 IuDqzLC8zap+XC4KSlapuqv9Z1gaYal8W8QRjNQf0xJ0xUN4CVIfqFd//JlmkJdL/t
	 likiz0hKPtIMYZltZ3cvp9pgw9Q6HExHVJeXlFaWaIOvNjEv+0aLZH7Q/mTZdPBa3z
	 FUR/3TA2FsqBQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7BB8060056
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 23:39:11 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_ct: reject expectation if conntrack has a master
Date: Sun,  1 Nov 2026 23:39:08 +0100
Message-ID: <20261101223908.444543-1-pablo@netfilter.org>
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

