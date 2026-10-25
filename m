Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792971008;
	b=2CDRwRXJ9gzrJgD+yKT9epOaWiYZkrpx1JkNprK0YQgU8bQAZacMv/4P9+YXcEeAG7k/
	 jqV+I+RYDb6nFk3EtPKE3L/aR4MgAHLJEXvsEXnh6EWwGkfoJVfMGMN51n11pJPVHy2YV
	 Q6Y9WemuYG/6Scur0LuPHwrF6ZSjE+HO+YvIHd1JSFybxujtZYzVrWF31JYYhsCes/RTO
	 o76fTj0odqD/TbQpBwrSbtjMtVVg5bGELcOnjDM+HF57H+q+codjp08JJm28Xt/8AFuc7
	 S+zR33kXK1pw0DE/8K6MRSn9YI5lVmOD1Af0xefCQj5CFsZTavYAiZ8UXwILwXl4PWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792971008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xqwNDiGNGVMb06w9MvuNqYvE23SPSrcXfCHBvDH87xo=;
	b=bpQk2TyqZ/p3ar+2XLGIx5i+BJLZVEvO33jH+dnGRf1prCtcSap/g6e7nK0mlpDwEVI2
	 TX9X+/Ahn3vdwjyjYZQIEYGYXy8aGWPeMqGlhS+VcO/p2lmMiV2czS3pH6GYS99NkCTJh
	 R+RQrHGPkWmEdJ0sJU5p9NX2SRbnZ6O+pCJ2S+uwnmSN9wBQGHgNyrFtSbc5TbvWpjpP9
	 LGIF0RXG24K67gcVQCKfaHJV+sim0Y/SCWRbBnFw0SOJsc7PeLKXkWaGlIJO10lIx6N9T
	 tsc2XQyf33cWVumYHPO5Eb/uv/gmmkaWuUuhCnRdGulRXo+bKL0lPQGryvYSueqx3/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+Ok+46R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90606606A329;
	Sun, 25 Oct 2026 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+Ok+46R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A579A1F01828;
	Sun, 25 Oct 2026 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792971008;
	bh=xqwNDiGNGVMb06w9MvuNqYvE23SPSrcXfCHBvDH87xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+Ok+46RUylWLeGT9ONmOZKEMm1soS5MIj1AWbGIFMNbzUICDah6oqmIyBDGMvBoh
	 mUhKLI2ehobFGWS7JsunE7P7IURwdroRrJaKP5mfsIuYlYRSMCThSkjng4pFHsWaOn
	 CSTkPyOfcp2bDGIwfUMPrKdp788xZ3cqUdo9lvzzhcXFQ5mQEdtYRP5VBoiZWlFNj8
	 i6drcVdrBz+/lMKOJTMwc8KHz77PtzX4u+f7KFa3LoMqd7n3OoAAkElEK0UVgHB6Nu
	 M9sRoakPoOTApN83luQ/egHkqd+twyw67H3cuEUGBebAyWY5UHLK7+BjTgPIp4PT8H
	 UDe8qbSpdKMfw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH v2 5.10.y 0/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 19:29:54 -0400
Message-ID: <2026-10-25-1-daily-reply-0008-nft-set-nelems-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
References: <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
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

> This is the 5.10.y backport of def602e498a4 ("netfilter: nf_tables:
> unconditionally bump set->nelems before insertion"), now with its
> prerequisite d4b7f29eb85c ("netfilter: nf_tables: always increment set
> element count") as patch 1, as in 6.1.y and as in the 5.15.y v2.

Queued the series for 5.10, thanks.

-- 
Thanks,
Sasha
