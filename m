Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2D137205D
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 21:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790026256; cv=none; b=WcRxjpPPYMUGAii10L9Usq6wzwXJjgqnnno6hbDZOHNpiC6TzBay0YXrRswayX/zrT9+yFCoVclrThkrLC4k1vHRCvRh8DdK3zd00Ez18GPSqLlBeWh/QUBXyWV3Mc0x+ms35q5DtPr0jJaGuegFdb52n8Crbf7z7YMQMhp6dyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790026256; c=relaxed/simple;
	bh=SDD5uJHfK6z8nRdxuK0ng0TRvAY5EGWTNJID3QGutxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGbbHCL38SoH8CH2IXk72ZoMyWcftaa5cimuehLyfJEiCznol9QzG7pQpcX9X7hWhkjk86YyD9Er8FdyCYEHYAYO+1LoPQrk7Yy3mhKORSdTzyas7vXuWQtl06vmMiii9LHOsLVAn2TzmqKnSMgXu0mUnSqbu619Cj1Zlco2+3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRroXxKS; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRroXxKS"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-486e1a044c5so2454100f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 14:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790026253; x=1790631053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SDD5uJHfK6z8nRdxuK0ng0TRvAY5EGWTNJID3QGutxE=;
        b=NRroXxKSntq3xO4MSo3ErmviL4Xxw4fuz8NUWG+GV0sooY5EtQX558oSc0esSAbopE
         XsyztbYzA2x7Dkqy2hio380jFCPzVTeSCYgqYM3aKDUa3kGTG7FfTX9ZfT6sJEONx/dr
         knuUYZ9++zkefwgL9ghci1AJybaWRPftuwsqDAfe05Gey0dt4T+geSFR64uIvYscBtiY
         5pGFDZy1wEAQFuTHX9McyL8Tlh+5YJqDs7rKaxCyk8e9nNGM5tzPwYIfB1bMXfgsOeZm
         lS2lSCpIoUEd3Z73iI+sqnXuYqYL5GVZuh+a3MkXN4+2de/TEl9NXBOVDCJybNx3cf+R
         nRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026253; x=1790631053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SDD5uJHfK6z8nRdxuK0ng0TRvAY5EGWTNJID3QGutxE=;
        b=QZrUi9uRYN3CEd1u6658wLCNZew2IS/okvkgrpEVvLNTgK5JOexRrYJfASo8BN1Fv/
         RqFw7x+501PxN0Jg8to6F0QtDqqYE1vB4So2bnpatveJcvaQLpG4kqdcC3ObhaO7wzvk
         kkB1Ir9lnlhFb+dSRkSUZ0li+69DfFnFwVzK9ZcO7SEfcZ6CShS4OFgsf2ePv0UNrJbF
         R0xbRcxMtWWOPKGrBcdyi5Qr1VFrMP9zFun/Gb2pa4XJVXxgqYsazYg97O4Hc4BDpoL6
         t0FoC7DVmtWyV+V2cAtvFnoS6aEYE6Ta41wxqt1Er6+GzGo8CbNQHE3FkTwXh6AtYrRt
         vbgg==
X-Forwarded-Encrypted: i=1; AKwUvBz/I/AF4ANrgEuZ3QxygLkCbQkIk1yltcEfQ37Lix2T6uj2TyQMP7LcS/sBqwdK02VIoE3FgLwg1GXOA5PC0QQ=@vger.kernel.org
X-Gm-Message-State: AFuF++kqum40A4BwMwY0uhkrvbBbTSZIVuHOjzopyHAeD9k4w6KV1noJ
	me2Br+m0Gy8GbaKmXZTWvvt9UU63yNeZQW5YycvgUZyDsAWVOAB4Y6Gb
X-Gm-Gg: AYBFou3mjhUbwAPtfQxoPSqTQR2YlYV0qyUAxLla+mRnUU2ZRK6ejigcRzyKGxHf3BE
	We70mF/NCfnQB6CFE1Fr6E8GqBVXKrEjpy1MrxqtZzR7EOzCT1Xs+XzzZ7dIICZZIomD2L3KnIs
	OsyXxMDGf4na7B2tFAZnhiFbnDMfJ5P0aEYpxQr7RYUEieDxYT3afhg6SCvBmQekLOOKHY1vVw5
	gBZoM4u5QHT554rfL5c/SdJNGxaEjnjVAM4NiS19/+fkxZd4KWN8uVlpuLx+dkbSPfX9g5o0n33
	SvVJbt9p898SxH71wa9BWx8RzsAHCrVeBHHNcUq5887Ka1p0mdobq3pDJEwMb7uVpuqztyyv/TE
	iBrtO8Biz2PtbpflVj9dkp0wqQlxXjm55gMM6c/CZlUUdw8/poif2jB5ocW9mfsiRem55+kPYZD
	UIUIuwHEDPfXE3FO8ayuQ7gcO0WY3LD9845pzgrzahqnGdEiHMzq9pShnhSD352ZBNXRYMa8dMC
	pcxgN5Y3XMe3nCO0Dqacb+FYwWxqK92BlITby4SsdsSxubmyA==
X-Received: by 2002:a05:6000:2890:b0:486:fa7b:d3aa with SMTP id ffacd0b85a97d-4871e2273a5mr15062011f8f.23.1790026252444;
        Mon, 21 Sep 2026 14:30:52 -0700 (PDT)
Received: from linus-personal-clanker ([102.164.100.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862287b6esm239042f8f.33.2026.09.21.14.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:30:52 -0700 (PDT)
From: "David .B. Dull" <monderasdor@gmail.com>
To: adrianox@gmail.com
Cc: fw@strlen.de,
	horms@verge.net.au,
	ja@ssi.bg,
	linux-kernel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v5 nf-next 3/3] selftests: netfilter: ipvs: add per-service secure_tcp test
Date: Mon, 21 Sep 2026 23:30:31 +0200
Message-ID: <20260921213031.6160-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921205706.1055288-4-adrianox@gmail.com>
References: <20260921205706.1055288-4-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Dull

To: Adriano Cordova

Cc: Simon Horman, Julian Anastasov, Pablo Neira Ayuso, Florian Westphal, netfilter-devel, lvs-devel, netdev, linux-kernel

This patch has already been reviewed by the netdev bot with Sashiko on 2026-09-21 for the v4 revision of this same selftest patch. That review found three possible issues. First the changelog wording claimed a bare SYN ACK suffices but the probe actually sends a bare SYN followed by a separate bare ACK. Second the script has no kernel side prerequisite check and no skip path for when ip_vs is unavailable. Third the secure side assertion cannot distinguish between the per service secure_tcp working correctly and the ACK probe never arriving at all.

This v5 revision appears to address the first and second points by rewording the changelog to say a bare SYN followed by a bare ACK and by adding module availability checks for ip_vs and ip_vs_rr. The third concern about the assertion being ambiguous if the ACK probe fails is addressed by the addition of checking the probe exit status so a probe that dies after the SYN cannot leave the secure side SYN_RECV assertion passing incorrectly.

The code itself is well structured with proper error checking in the libmnl helper for setsockopt sendto and mnl_socket_bind return values. The fallback definition for IP_VS_SVC_F_SECURE_TCP in the helper is a reasonable approach for older userspace headers. The test topology and the approach of using TTL one probes to prevent the packets from reaching the real server is sound.

However there is one remaining concern. The assertion that the plain service reaches ESTABLISHED state depends on the probe successfully sending both the SYN and the ACK. If the second sendto call fails in the probe the exit status will be non zero and the test will report failure. But if the ACK packet is sent successfully and simply does not reach IPVS for some reason the connection may still be in SYN_RECV when the assertion runs. The sleep between the probe and the assertion is only one second which may not be sufficient on a heavily loaded system. Consider increasing the sleep or adding a retry loop for the state check.

Overall the patch is in good shape and addresses the prior review comments appropriately.

Reviewed-by: David Dull

Signed-off-by: David Dull
