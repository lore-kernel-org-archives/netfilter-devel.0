Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636C14DE712
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792407187; cv=none; b=qClXOb3pp25/jLdzRtwl9GG1G1LiSsyFgB/DXWPB6yHjWPNfKn3b1I3u1nPTO3lYoZKBsKosPEkeU/BrEupEFU8eqP2pLZIICGRVYstP611JdRMADaKqla8fp2uggECZOfksTA7o/LnmMr1eSGFH2ZpVm/1Ks+8C7HBcplmcDa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792407187; c=relaxed/simple;
	bh=mXqcORp3c0k/JI9vRxkWcWM/ra2RqgtpfC6MospUu20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNkDLp5HQ8V7mksLE+dztBH8qCXIVHnkOdkLFTkJ+x310N/J/VbzV6RLzIGTHosmiS+Z4NsD5yL7TL1QFKHPodst5IjNAsrE/mzbSCqFnglUiB4DSGlU6W3hJPchAfKCeg4BuoYW4DreyzWYSxCgl/TZzqnhSZ8h0AE4IQNFWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=vs1EWY72; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="vs1EWY72"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so2821254a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 03:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792407182; x=1793011982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mXqcORp3c0k/JI9vRxkWcWM/ra2RqgtpfC6MospUu20=;
        b=vs1EWY72TTdEmqgg9GSothkPq2obVMv8QC9r5XAdgkoE8NNuIVDDGkwXwbb8pnktXI
         TPsn8u+s8YshT6XpfsSzVPU2XlH8qDLgrmozRU9K5RGxC+Xl+xKb5PSrmoZ3lFQPiZ1T
         SLGWiDykt9+w4f8Zfe63tOkfymqgy0Hqnu4m1Mpqy28VLNDU+Ea48Jrsjc4vW/VMJvsR
         tVLbyPAiTgmYFno/8wzKpoMjmVeN1hyhYrQyrYV8mPSOIrm/30esG/yaoFgSD+t2BlaQ
         m8GWYN92xHDGGy0VIeucD6mvNjf+VhWPcj/f5fRqfSENVX+gQf5iiOumNicfYKl+T7FJ
         hKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792407182; x=1793011982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mXqcORp3c0k/JI9vRxkWcWM/ra2RqgtpfC6MospUu20=;
        b=x4K8Kcg80dLmyu/EO9OL6dXkNMD4K8CLEsQw2suNfaYTxjotMmfDhA4yYLsFJJuKqq
         T1kAlQOZdA/WoHXJAmUdqyPbnAWK3CxnsqxYiPWYdbE35HpzY2hxbgVimyDf6kdVZkCo
         0cezo7FRsbZlLWOEOaIvOO4IHwkmsmQlqQbjPLEsHg4sbAmhyTV6n7u4WKbqAhUXxYCK
         ZRh6QEkdiRsskog8Mtlb79Frb1v6gkL+IvN3/tbONJsvS4E944bINvSzAB1HPy9TxZYW
         0uZd2+EhMaDI79DxsBIuQUEWhdE2K8za8coQ6guzwsTXbqT/0QoBugYJepouzcpeKCx/
         JkFQ==
X-Gm-Message-State: AFq9FYIIg7n8rjf82O9zmqGnIFiHTSHGNFzuxH1LoQUz6us8TQav30mC
	bWpqgI8KjPhLaLAD8ivCuN4F9EaB9AvuttDU6zXMVUyg3fn/5lveyUQ2nDv04gkvDQ==
X-Gm-Gg: AYBFou2hBvN0BWIg3lph7WzkekRhKfT49ooUbQ2Qu/xiwbdWn2ljww3kq9mGWJkW+V4
	Znv6Oqng2uKBSgsrIWGdFD1h8pVzINuqMbBoPCzI5mQ2f9+n7VkkjuE6ojOrgoI5duHjsL4IOse
	YLt8VJ1k6vq4ClUfyHLzo/7HsFRZuSN2PUUq7WQBzWwYKX/tMbyXmOXJCqTnxpIVIi2Ji6JWvdx
	z8WzZg6CQu3q6CRKmiYo0F5oxEqWbC1MDGLLs0GAv3F06vyM1J4ybrXpIzrfldwA9PphU/rZZ70
	j7yEi79mS6XrwZ5+Toy1cLcdTF0L1N3vSnKSQSGyq9Zf/2NJDbM0PsYfsFTBpUgHNITVqrhVUlu
	smy+xgOrioaSmuQFs+wPSFLSdhBkzti/soJaoXmPR7r+RgOZmTpwP8pcrqqs2HodgkdX0B8GEdP
	67iA5QUND3W4G+H8206xKfhAfBawYIi0R0/pw/HKe9rVOgKspKlRTzCqR5bzjCitkYr9Zep1649
	xXsG/6dXEYMMabaH5p3Iyag+WDsnysmg4ahe4a78UR+ln3LLjJzkvj93wpZivsLkAPvoUPwtFo+
	/nLvaNtpCC3t7v58Uu4ckE/TW6JuUqxqAiXi9uHz+Yvx3SfehbAQdFAnisaPTXS01CjIBEXU/up
	dcfHhT+M/mPi26x2lWJq5E1PGoT04jd0WqS88lCQ3s305I5ilGfvk8dA2HryBZmGIIdKPWjYhAj
	UbJ3jgcq36WagaDQbx
X-Received: by 2002:a17:906:7947:b0:c29:22cf:b0f5 with SMTP id a640c23a62f3a-c419f122235mr458126166b.33.1792407181819;
        Mon, 19 Oct 2026 03:53:01 -0700 (PDT)
Received: from Desktop.fritz.box ([207.22.61.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091fade41sm345091066b.82.2026.10.19.03.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 03:53:01 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Subject: Re: [PATCH nf v2 1/2] netfilter: flowtable: fill the vlan key from the outermost tag only
Date: Mon, 19 Oct 2026 12:53:00 +0200
Message-ID: <20261019105300.767810-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atXxYLFOijwbFXqB@chamomile>
References: <atXxYLFOijwbFXqB@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 12:30:56PM +0200, Pablo Neira Ayuso wrote:
> There are only checks for ETH_P_8021Q in this codepath, no 8021.ad.

Right, and the commit message gets the order backwards.

> Why this new check for tuple->in_vlan_ingress & BIT(0)?

It is wrong. It drops the vlan key for PPPoE over VLAN.

As agreed, v3 will follow after the fdb series.
