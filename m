Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521482;
	b=E/+gQAxMFQnbbCiUIsS1zeAV12A5lU596K5TWIV8KN3VK9Wi/3pRN6pDpj2K5vtckDrj
	 Dqn6QvwMus9GeoJHzFAyyVKGHHMmZetww9TEV8LunzpzJVjvk2c4Vw4f8wk1jegp3b+6y
	 mpQ5Qbf4bbTqwBbEoPDrF4gksjKuBY37ZXRRxngdnjAkKswNTiSS4I0HPRACtH2Xkqgbz
	 U0aflDId5xFDZSEOQKsTThduWLzc4IjTEnCMIl18D0vKAL10aiNETabtdYb00i6Nz0zKf
	 XIvOQBC5pBozdlX+0+LW/60VslIBaMnkNTlcRswY0LXst0EzhNWwlXN1bqoL7xrgfuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521482;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=McwIM8K5jFFS2Rob58TOcRIVBt2cmGHmbpJKj6n9DSE=;
	b=sEsrtenGELuaxUbhPCJ3BJlFYvr6cBlq4cIK4/jelx1HSUGUSwRgzHOvJdWWOJ4viKsi
	 HGe3Vn2N7WGR4GyZzekMfXUNVx5f/grnhVshWXYgY+610bOF6czS3ZuAtgyOH1OYNA99A
	 fnwDD/PHmDvZVZCNLcGRU6l4qrZyg70ze9u4cUgX8eY+1l6Qj+w9Vu5c4W6Nk0tv/96Sk
	 DYK83eQFDFeCYJMA16jt6zph9+Y/Dx7MxYyZ1U0+I0gja1ltt8zAt7daTrlYHpN/iBFus
	 Nk0vJ+2kH0Ldplc4GqMgd0spzkkf50NQrspX7HBtHF7gA+RgIZITaf/Yt9b4QCnsd4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WdxKNk9Q;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4F606A321
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C4F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WdxKNk9Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521479;
	bh=McwIM8K5jFFS2Rob58TOcRIVBt2cmGHmbpJKj6n9DSE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WdxKNk9QWI3gLZE9lPnS0lcQMGPO1lcAF1Kam9nu+c6INFxtKUv4KFkieKKOILkPj
	 AujmQrGV/VfXAYT5paVQu3P6R2I/xM1UyByVbRl1Q+liPET1TD7BkaMTrkVuqQxnUB
	 Jx7J1eO1IBgUbD9kkmkmjsUkgtzq/sKUAh/nsfsYtA+9ZWttbM7EaDASfA92c7p9rj
	 PHCY8ypgi+CmY/VRYLAjG1g3NrTS0GzAWeVrEYiQAZqk2zMU28FZME6ZJ+xs1Z+qTN
	 6mSbJXrI/f3j/7CNoulvpGLp5Hu3KiEkxKe/dc75ViFwlBMYK+Eij0VdJAxLQTJC3S
	 YuP1QP0zutrWA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 080B56007C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:11:18 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 5/6] netfilter: nfnetlink_queue: restrict upper verdict bitmask to queue and drop
Date: Thu, 12 Nov 2026 23:11:05 +0100
Message-ID: <20261112221106.2278789-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221106.2278789-1-pablo@netfilter.org>
References: <20261112221106.2278789-1-pablo@netfilter.org>
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

NF_QUEUE and NF_DROP use upper bits in the verdict mask to store
the bypass flags as well as the queue numbers. Reject any other use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: no changes

 net/netfilter/nfnetlink_queue.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c6ea584d5e9d..3f6b38776ff8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1755,15 +1755,21 @@ static struct nfqnl_msg_verdict_hdr*
 verdicthdr_get(const struct nlattr * const nfqa[])
 {
 	struct nfqnl_msg_verdict_hdr *vhdr;
-	unsigned int verdict;
+	unsigned int verdict, verdict_mask;
 
 	if (!nfqa[NFQA_VERDICT_HDR])
 		return NULL;
 
 	vhdr = nla_data(nfqa[NFQA_VERDICT_HDR]);
-	verdict = ntohl(vhdr->verdict) & NF_VERDICT_MASK;
-	if (verdict > NF_MAX_VERDICT || verdict == NF_STOLEN)
+	verdict = ntohl(vhdr->verdict);
+	verdict_mask = verdict & NF_VERDICT_MASK;
+	if (verdict_mask > NF_MAX_VERDICT || verdict_mask == NF_STOLEN)
 		return NULL;
+	if (verdict_mask != NF_QUEUE &&
+	    verdict_mask != NF_DROP &&
+	    verdict & ~NF_VERDICT_MASK)
+		return NULL;
+
 	return vhdr;
 }
 
-- 
2.47.3

