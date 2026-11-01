Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793573681;
	b=fFGMZmu16CBGT+d6OV4aVYBL3+JtNlo15GBXe7XXjXsTyB4FrdHFnjbLo0apJJgua4Ri
	 HBjvi3L1aDZZ9xUWq8RlSgbcy0okhwkfyvRVsMbHrZhe/qbMnK18qfV1+P8GGIHvmcLl0
	 gwdxJa1JRKEp48ucudhMfDF89FlS7prAUCPj2ThPhrEMv4CrK/tUTsHWacHcoadxp95v4
	 wH93hey0MdUQx5yT+y93irIw3dKjw/oya9geYIcJL3NbDgch0d3eUB7qmnGtRno5Fd9LB
	 UOYSnqoTJixfKkG9xjkJOin/WMbKZyIB/9+bIBfKQbNGAplU4BY6MqAXdPopAOOUIfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793573681;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=bUZe05N9f75utumrUUKMTiFUNt7feUX1PjhJPSMOZzk=;
	b=ffD2g0pKG9HgoRkvBULXLu/lPJobALDrSGmnSSyGtgkk+71W5ZEy/NhkUb/ONS8KiTAN
	 CmarSeRpDPG6DmXP2V6mZaKuyxK28fINJtmWrBoVE+/7T2hVLcCaoQSBzqeFGeLGdcGZz
	 r/i7fXjG5FUwf3BFRNRPvxjHOOjIPLQh8mtO59vnYBfiZR8FR2dqUgMN0t/CPVMsEe2R5
	 toL5RcyLlPlfJQIvTv4ZsjLpMTqLIq9iVo/g2jn6CuVUGUslTCG/0sSAI9YqiAXskwMYW
	 nT9sey9jvpsbAwRyMh+3dYS6kzeP0gNLVpEVPxanZsnV/tKf1l+Y+MTuJd9Pouvli2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=r5MSt+zL;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1FB606A324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 22:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B1FB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=r5MSt+zL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793573678;
	bh=bUZe05N9f75utumrUUKMTiFUNt7feUX1PjhJPSMOZzk=;
	h=From:To:Subject:Date:From;
	b=r5MSt+zLZ2k5v7tHT8ec1nq6nxTtWTpYLHUo94KWGbNgSto3qSzlyXIyctr0p+cQs
	 y864Zvlh4KOvYuuPRL0NNQrxEYjV4RXUjWGLoXf2RLyaYnZ1W/e/vlwUI9w9qhjE81
	 XczpPAA08vrMuU2K+XQUOlMyv4sSeK2wFNX+hePfme3/Vvq98dIx2BrGetNsLDTy3W
	 VdE18+J84PnrnxmpFqbtRlcCJW3T3b7PzxPGX4FS5/mk/zyOsUIt8P4R8H577LHt4n
	 ZC/KpLsS/GJKN4Ae5dnQnee0Lqt1mRDR393ug8kO+fzZWQEFWEZ+v4VbM9DSS9cd51
	 jZPslt/XdacLg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5BF846005B
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 23:54:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nft_ct: reject expectation creation if conntrack has a master
Date: Sun,  1 Nov 2026 23:54:35 +0100
Message-ID: <20261101225435.447072-1-pablo@netfilter.org>
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
v2: check if from obj_eval().

 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5a8db5592036..a2f87d657262 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1418,7 +1418,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
+	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct) || ct->master) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.47.3

