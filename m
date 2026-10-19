Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422187;
	b=nqD4dkucD7bf0A2Rp2XvsEAqMieOEd5J7KKZQP2LyXrYs+nzAju8H0/N4BRzP6bfd1iG
	 CN2y65jOrEVAvfgsGGn5XxZ0P/qANcaRrE9PXtcO8X/1zAGDDCEg6N7Ai0vZy/J58JGZW
	 02fvmZPyZ+WBi8P/+ZG7jVplbdFGgln0DfvJrfkMPiLSpopomPQ8/JANSVXyR3lhcIQ+A
	 Jzyjxhq+WgYIauw+ENXVPhcANuODPku5uwLixk//3Icu7N3OnnCdG4kSA7Sf7APIC1/GH
	 AmpTdFWFZE7LEpqzvP+lXrM9yAimj1eo7fIXwiqP6HxI61Sd74EyNiEpjiS585hPG1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=AzkPEoV3uKSzYp0zJzfa2EBj8nbvGyGKjt7kqEJZqvs=;
	b=Y5GJHmPnX/IZgHz3GIBc2GFW9yFuV3wnLAbDtHwjzLfpzR1MclGLL/hMC9kskapWVvyw
	 SOgsqGdWFLO48lPgpjxWFp0OpE/x006mMqc7vPWoeaomtzQ126oNSDZgLqxkduQN6ctvS
	 OhM2d2hQYiwit2jmS9yyCKblzB5S7awJJFnjnd1UhR0vGiZD9QdttT3crqfCqDTzhMK0x
	 slJ+QfqE0TeWbClpMofd0QmBnBM/UZ2a2+xg1bs38bnS7VrhOU3JtjAnnm98Gnjp4+7vv
	 DLffcXTvj4KuyvCP+3z6mIyhYDpDOYcY/6m2JNuUeRrQlYLUQXOdU6r6/U/nBF1tdGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=lvnIgZDx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4800607D34A;
	Mon, 19 Oct 2026 15:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4800607D34A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=lvnIgZDx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422183;
	bh=AzkPEoV3uKSzYp0zJzfa2EBj8nbvGyGKjt7kqEJZqvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvnIgZDx3R2WiM17NfgsMRRVk6Ahlujfuw2EkinSmdUoMctsEDLdrPRYi1AXvl/By
	 sdoaZMy4O90IvHYjJxmf3ZC9tUhmW1nlnmo1tDJ6TRAURp0dcXV+Ro6wRN5UGkvvFk
	 MN/cwFCt6X4wC4Lo4HVkyl+jgOko1qsEwQqdKbrWrz216xz4KmmVnnQVmJ+gX2ia2R
	 kpLZuUFXPlwNseKVGC33zVVFskeFQ9mKQD8N67mBTGikl1KUMZwnOcwOFpOWCJBVLc
	 H6xYA47cIiy2PLoxeOJL9QHjVgabHMX18qNf6cnAkJIIjfNopztrlo3vrB2VJ/qsxH
	 ChuJDDBe9/3XQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18BC060060;
	Mon, 19 Oct 2026 17:03:03 +0200 (CEST)
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
Subject: [PATCH net 04/10] ipvs: skip committing sync_threshold when proc_dointvec fails
Date: Mon, 19 Oct 2026 17:02:43 +0200
Message-ID: <20261019150249.1879516-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
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

From: Joel Granados <joel.granados@kernel.org>

Forward rc value and skip updating sysctl_sync_threshold when
proc_dointvec fails. This targets a write such as "5 x" which would fail
with -EINVAL but would store the first element anyway.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 3003547dcabe..ce9fe20d6106 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2452,6 +2452,8 @@ proc_do_sync_threshold(const struct ctl_table *table, int write,
 	mutex_lock(&ipvs->sync_mutex);
 	memcpy(val, valp, sizeof(val));
 	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (rc)
+		goto out;
 	if (write) {
 		if (val[0] < 0 || val[1] < 0 ||
 		    (val[0] >= val[1] && val[1]))
@@ -2459,6 +2461,7 @@ proc_do_sync_threshold(const struct ctl_table *table, int write,
 		else
 			memcpy(valp, val, sizeof(val));
 	}
+out:
 	mutex_unlock(&ipvs->sync_mutex);
 	return rc;
 }
-- 
2.47.3

