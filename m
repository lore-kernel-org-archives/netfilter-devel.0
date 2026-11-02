Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633625;
	b=3UHUC4G1ZsODxatS5VzzC98Hsu5OtxsOSVIWcUAj2I9sBYpdE3zQhjM3KySqPZHIaR1q
	 ZQuQrbpC5t0KRbRRIlm9mFLwe0MV6Wf6IJ16L3gpICjrE0alALPxxOmwNQ4V/eJju8lV1
	 RhyNfZtZByVDXbcM7I7XK8y413xxIQaHI1LmmjvMIcF4E7DoLa2MYtIztjBXxA/eVQUd9
	 L7DLXMNghB5UuoJT4f4T2Alze8rYtU/DY1m5GSeaRybZLllNz3mNbAQqbsHJ0pfKCmiwq
	 +WX7obZc/h0bjcAJHYiaMRdYMl9xg3T2hyXlxpJ4L9VuC6t9Hbi02e/+TT2kKV/Qyhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BYZEDCzllD5FvV0RiAothYpDVB25T0bLbRlXBX55/B0=;
	b=17JaByXKzprh7sBAgx1Y5Xzi01CfhXCXgsFavvPLShpgUAV8U4pZ15gwd8I8BYzc/JHd
	 EEBYVSR0Tcp4c67O6cZaX6ERhUZD/1NtD/Td/x3Bo5ViK6NeFElflohWuBQo+3FmHSLab
	 sQyOdj1iFJaP44i0lsYQXZlCU+UWNdod5glw5dHXHQNZ5Iu/Dm8D50+a3s/+57lyYLkov
	 Slo2BlTtNv7thXVDETlCnesSimqyustZmjfeHQuuFMu34ygKdY1lwHm9aciAXdrkXNQiZ
	 6VR0uyJqMkq8NTBOx4GN9Rpdm9NObtyXhhLVxedqSUeq+HQXje5R/rtKUvEzdQulCYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7PcjIzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E460A609FD96;
	Mon,  2 Nov 2026 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7PcjIzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75501F00A17;
	Mon,  2 Nov 2026 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633624;
	bh=BYZEDCzllD5FvV0RiAothYpDVB25T0bLbRlXBX55/B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7PcjIzyQrjEGJ9fwR7MaqZdF2dhQ5trZ3fXLELkUW6Mk7AuED+u0lxQefyER6MJt
	 bhwsVRaB/80GQ5VgUJq1HI23RO642AuUiq1UuBGemmWhE/M2YLvb9p+wZpfiwN1+1L
	 jLM+PGNi7riUoZl73DQ6jM08Y259wCF+RW5rKpVAVqa7KItBRWDUqFSnbG3pplYylL
	 tqy7scql9hpyF8ykxDbxCdmiTG7gb0b/raEGcwLkx/MMs4a6QsTFqYl2BdJgBcBmmJ
	 wEM2jArVfdc1Tk8V665KglvXhWA0nbo1/nOcilg34g5eRJGDi5a42QIkxZnOETrw5U
	 p7dTpwddH644w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jaeyeong Lee <iostreampy@proton.me>,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Subject: Re: [PATCH 6.1.y] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Mon,  2 Nov 2026 10:33:29 -0500
Message-ID: <2026-11-02-1-daily-reply-0003-nf-ct-expect-related-pair-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261101-nfexp-pair-6-1-y-v1-1-5aa95ee76098@gmail.com>
References: <20261101-nfexp-pair-6-1-y-v1-1-5aa95ee76098@gmail.com>
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

> Add a new function to insert a pair of expectations, this is required by
> the SIP and H323 NAT helpers.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
