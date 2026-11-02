Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633622;
	b=nJXE2zUlv2w7Vrj+/z6XgqKEd5VswGviF3HeHOjPokPgaTuGiPIzyw0nlyONMUDlFOO6
	 ATXl910YUFBGvaGRB3Vv7q0gZ8Em42hDLKhYm9MWXAXrgy8t/RSXzkubvJfP8NlgdYpyl
	 qDWfWZHFjZHoc4AfXzrNtjdKfjC4yDsNKYysMg7uOR7aFudw/Ppjvh6vx5cwjt4McF4N4
	 viYbSKSDfXveVNh2HwLU6x3/CVoEj1m1KThOp9378VBFHtcPfCzOaE7PEXsG05NFJdyUD
	 Vp7QB0huQu3VGC7EPOZLG0wLRiLP39LpxbjqCLbr4Zc3mRlBgSIGAsekceqC+X9sQEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yw9Std1n9px7Uu0g7JUg3JtCQdnqzvP6mmyhR7f6bxw=;
	b=sB1R7ctPcLdweWE7fvL8dV6D79UIcFGM+zUiiF45S0dK4bjjgEzcpnQz+pCZYMLLFuTe
	 zhvyaEa0oMpMIDNBjptdJkKeEwYNn4g3e/Q56iA5j8biIRj6YVVh2SMjReAHe8zJoJru0
	 3zEHl7jt0SL0bBACJ/NCX5WaXf/SNnLVBf12gCEU5r7Sr9fSz+0rOlwWhRxYSvMdivoKt
	 nUdAG1a5RwR02nZfxA8Uvs9Epc6wZFkcfZ6kRCyME1WCO2Tr3/qMaghISo/XY8w+Hs50J
	 psglLVPUg15LHMkEYO2c7agDv8KkoZoKp+ejTMH55FqpnVkNXVxACwGHIPXP0PYX9Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNEOcAq5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C16072EE8;
	Mon,  2 Nov 2026 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNEOcAq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654221F00A17;
	Mon,  2 Nov 2026 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633622;
	bh=yw9Std1n9px7Uu0g7JUg3JtCQdnqzvP6mmyhR7f6bxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNEOcAq5uKYyu6WNFkKiSDEs1EshgFpZ5DbFsu7Ap1y6cjWoAC6W5i9Cvap3pcxjo
	 nqHzncBM9lFRyNw+zkL4tbAwPrR0RfPWdvKsafr+RM7+BoIbMFmuKqHSYpz7vK6KaD
	 zhI6G+wFyBqkOrKRQMyNsa5Wm85HrnnSgIbUQQ0sgUxzdUkugNHFjUlTxJ1n7k7dPK
	 a3Cz2h4KZEg4fStkw9zW8dWmLPzN7X7cpIyNDD21B9TPP4r/o+nY9kosf4wzii76EQ
	 55nH7aKqw7+Umrgm/iV3fgGbfUsZLkN18wzHquqL8QHODQrxZWWKPFFI8ilYVZ3Psz
	 cWo9fxZy3uQ+A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Jaeyeong Lee <iostreampy@proton.me>,
	Joas Antonio <joasantonio108@gmail.com>
Subject: Re: [PATCH 6.12.y] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Mon,  2 Nov 2026 10:33:27 -0500
Message-ID: <2026-11-02-1-daily-reply-0001-nf-ct-expect-related-pair-6-12-and-6-18-chain@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAOCBhwFHdydRCh87VNAnTC0Bh4_2NU_77zViQHUOF1QC_XP5pQ@mail.gmail.com>
References: <CAOCBhwFHdydRCh87VNAnTC0Bh4_2NU_77zViQHUOF1QC_XP5pQ@mail.gmail.com>
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

> 6.18.y does not need it: it does not have b8b09dc2bf35 ("netfilter:
> nf_conntrack_expect: use conntrack GC to reap expectations"), which
> is what makes this follow-up necessary.

6.18 not having b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC
to reap expectations") is the gap, not a reason to skip it. It fixes the stale
exp->master race that bffcaad9afdf ("netfilter: ctnetlink: ensure safe access
to master conntrack") left behind, and 6.18 has that commit.

So 6.18 gets it together with 4aa63842fc92 ("netfilter: nf_conntrack_expect:
add and use nf_ct_expect_related_pair()") and 322371b09058 ("netfilter:
ctnetlink: do not expose expectation DEAD flag") as one chain. Nothing more to
send for 6.18.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha
