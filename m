Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633624;
	b=eJMH1ohC2+GSIODlP0SRGmQm4PyqARmS3/tw8SMhuiOM7EZZ7GRUfsw6McyPryLM35/C
	 egv+zeYbYq/z4erF+Ywa9TYIsmptGGFUbKyl+ReaoEbiuIuNhNLVHtSoGXmLHqbrS8auK
	 GYWVc/DvtoVpA1iLBdWFpyIk+jHJ5NILKYF1/IXjXVU275oQAV/j++w+ecmL4IC4SHPuq
	 wMGFgwH12kwdhYa8iIT39/ImylIZO8jk8zS705lR30mlBjWvXOKxuhhILJP9v6OCtGRYQ
	 Q+CGC4g0gY+vZutRraZMzI86kmHcmuYmdX8Q6z6i9Pj2nmXD9IpYspkz+oJ+53O+ptQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mBjmT53C2Y3Y41oftSSZ+Qf8SGLrXA9SnMA0gQOguYM=;
	b=SZ+quNQkmTFFNQF0XU6ulGcTIWtBlOCThPlCl2qR7JuwQo5Zrl58ON6gmRE0R7V+U4ad
	 leJ/b2rBQIXmc3fP1wBeA5APmB6AjuP8IOVIx+Lq6RFVyNfdc4g7g83TmKG4XYthIu94P
	 Yn5LMW4RO5V1jowrLGtA2+ydvuShKVLH1xPi9y/g3wBBt7sp9vA3wVg8ZpfN2JU+YJt3a
	 Ws4LUwQA2dHGuMufzdHTDWZ6KHxWAusOB3WLTxbtm53CQx6+IfmxVX5DsM6Ow/oumktos
	 qMf5Z8C+W3lZY0oJNO6rC0bdxuD0UTqwGyH1VxXKOiiC3ivghkYWv/KmEYCDnDJZReg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jbg/RrZ2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D429608A36F;
	Mon,  2 Nov 2026 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jbg/RrZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0C1F00A18;
	Mon,  2 Nov 2026 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633623;
	bh=mBjmT53C2Y3Y41oftSSZ+Qf8SGLrXA9SnMA0gQOguYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbg/RrZ29gEdvERxnjwZWdiqJidhM/b8Nas3Xd3dKuYxqxllkUtWjida4jj8z5Ixn
	 s9GkfGAgu34dTnpfIYvEoF8qmNk1mjtNKlWrdoM2TE4azlOSNuxMn3widbndhbZvya
	 b52XK6jcax6Yo3xsd0Pyrdu0775PrliNeQHK+lXpBjBD8rI016wtuBAk4rMgZffevK
	 OMnNU6FS9o4aSbFnz2G74iFYUQddcxoIYTgb2URbJsHTEc0cxUKAqh9rIlPfz0f3T6
	 OOahJ+J/9rfTF84VeFARIz5xGdBiNlAN/os693WTKAIdEVGw7W7vItidpPTrRXq35h
	 q2txg0ksfkU1A==
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
Subject: Re: [PATCH 6.6.y] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Mon,  2 Nov 2026 10:33:28 -0500
Message-ID: <2026-11-02-1-daily-reply-0002-nf-ct-expect-related-pair-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261101-nfexp-pair-6-6-y-v1-1-049943e85067@gmail.com>
References: <20261101-nfexp-pair-6-6-y-v1-1-049943e85067@gmail.com>
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

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
