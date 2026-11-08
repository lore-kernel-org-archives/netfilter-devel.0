Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177144;
	b=HuYTNcC9+1klhPlJTsJTsxBJjuvv3RYuHLz4sixuQPeeyxu4Q6Fu3YZoNddMGcpLfCT0
	 HMnSf5+YJnGj4OTRgK6eDu/mwlb3If8UcGSfuvmGRSHLjaPsWj+CFUZEXER51vQihTk5i
	 VaRQE/mN9igvPZmvlpI5rqq8GfWcg8XoG1PRA4qYcFmm2JpZYuN2Ym6o/5Xukqiux4b+5
	 Zo9ght8O4nDrH7KmvYXx00QaOFKyS8OiaIUAJRJyphbWMqV8fEH1wbUXz6ZcXLcQID+GU
	 eCTmGSbppeZ7UqQQjNzYYqG7BY44RHxDgW/z+pBh5Tj7SNPsSBrZel0G4LFy9XSgncw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177144;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9L6q0YkJhINETobLEedWRcicqFSMNtT+abPs/Uh3YjQ=;
	b=0ihEUy/0Fk5RRCnxV4JAgmUgDr3ZcoCiOX8B9XKdgnMIDJcuNjjW30RCIsg82jJqU2Tb
	 8LhVbU3Qid9z41vnm3qY2CuNUwraVpIM07ameMVdnoKcc9tq9b1yJbSma/OpykDbhtIQq
	 848Zf6gdwWnLg54AA+7dbt5ammKKnJL/KRQlRF5ZCsBE5shyoXL8RXDEfhWD/b4NVi+EZ
	 3PAFfC4Rpek4xVF+AQUclGTYU9lOfjLLjpXB913nQ6aRDKRlDpjUIjXgKzi4Xhvp21LUn
	 dHNu6l0nOiofQAJ0nX4sgy0v6FaoZPqHKbg8SQGJWrBu0jqz473W+twlucK8Vhxfs9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=MgYJMhsc;
	arc=none smtp.remote-ip=109.224.244.17
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6353606A325;
	Sun,  8 Nov 2026 22:32:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6353606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=MgYJMhsc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794177140; x=1794436340;
	bh=9L6q0YkJhINETobLEedWRcicqFSMNtT+abPs/Uh3YjQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=MgYJMhscuxKa5ltauC/4NPylXLPFqh+Aw+jKviKjQCQggaymPYTCvXkUA/c900lzM
	 rQFE6nfYKuLJewo7YAMy9lvgCqUvrawlDRRSttktpFvMyXZDdVIpDN7JBOrPUysU7k
	 JFII5XAZu6MP8rNwVS26707DqGywS+dOhqrMb6tthM43WUuXw6CVizr73ZZdApH1fY
	 UPEyOKVhcZl+S/zKOfOO4C8cqXzOKvoQnwsvqKaYaTonKAbJIp6A5w9g77ac4Z+lrS
	 tCFu7/lT8yX3WwsLgsETA+nEcFesC+SsB4XXsmLHMSxcIvydSdDSiVkorBzVZwRsSv
	 /mdgYX4BxEzvg==
Date: Sun, 08 Nov 2026 22:32:17 +0000
To: "pablo@netfilter.org" <pablo@netfilter.org>, "fw@strlen.de" <fw@strlen.de>, "kadlec@netfilter.org" <kadlec@netfilter.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] netfilter: nft_dynset: reject DELETE op when set lacks ->delete
Message-ID: <5aybqcVfq3WxYdpbT0Ea6bEWamp-4x10J9FF_5La7SSXJ57a4j176x_t3zUW8Ii2r84MsPX8xx_vNashO2PRWvuO9yNsaxS8YV_4TLc-QHU=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: b3d9ccead2c59e7b876970e6da36d7e95a6fdbeb
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

nft_dynset_init() checks that the referenced set implements ->update,
but for NFT_DYNSET_OP_DELETE the packet path calls set->ops->delete
unconditionally. Today the only set type with ->update (nft_set_hash)
also implements ->delete, so the call is always valid - but any future
set type implementing ->update without ->delete turns a rule evaluation
into a NULL function call.

Reject the DELETE op at init time when ->delete is missing, next to the
existing ->update check.

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), net/netfilter/nft_dynset.c:98-101 (eval), 209-217 (=
init).
Longstanding asymmetry.

This was found during an assisted (AI-supported) static source review of
mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); e=
very code path cited below was re-verified by the
reporter against that tree. The patch below has NOT been compiled and has
NOT been runtime tested, and no reproducer was produced - the triggering
conditions are described above instead. Please treat this as a report for
verification rather than a battle-tested fix.

Reported-by: Noah Weinberger <noahweinberger2003@proton.me>
---
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index fa4da69..5e2bbd0 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -216,6 +216,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 =09if (priv->op > NFT_DYNSET_OP_DELETE)
 =09=09return -EOPNOTSUPP;
=20
+=09=09if (priv->op =3D=3D NFT_DYNSET_OP_DELETE && !set->ops->delete)
+=09=09=09return -EOPNOTSUPP;
+
 =09timeout =3D 0;
 =09if (tb[NFTA_DYNSET_TIMEOUT] !=3D NULL) {
 =09=09if (!(set->flags & NFT_SET_TIMEOUT))

