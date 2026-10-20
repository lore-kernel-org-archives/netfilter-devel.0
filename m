Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792530660;
	b=sPJXANBt8J6KltU2g0PRt04/H9cURabYKioAknO5sWqeU+7ZCLFTjiMzooN3s8UPRGnG
	 Its75yMW0h1+Q5KgL2GIKHHGyEyVM5dOpSh5SR4nUdZIM2vTQ2vBCoTobO//sGid3NLBH
	 p0qlk1n+AsSHqpTnV/qBVNaAlQ3nbu1ELGrTWfgmOMiGwI8YuGdFWfKKkCmxWNuZHejnZ
	 cobiI0HEkX2IUOs1SQQxt64wMTV/2vDVITmA01ZHBqcdDaF59OeFCCB1VRYJb0BgQAlwG
	 +N6iJ+6490B2dQugYoLEVXO8TOH9R+0UvmT9YhPMGkBU7jbT0UWlebv6Sd5QpysykIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530660;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=QUYrFt/9/eGDOu6Wr8mvLw1GjBqci4jL1e89f6OPWXI=;
	b=fLtH3gKDkRgY7/TOiPdv0dWDtj6mUqeyJD6U4GszKmiDuu/0v6L5vRs6ruwLfPZnK6W5
	 OavDlssnG5CXnUoz4Q+efB5u5hmPskLicXT8QIcHmx1nDkj1Rj/syZHlXT6GRXul6XAFD
	 RGr50x3r8+uHlC5KJLh9e9wnynSCcDVi75VoP6howDSGUuuqgr7LWx34Kd3B975H++zDx
	 7ggXms+jwzPBswTcFjjTDDSyawHUId9ZQLZAUwtUnXwy08d/GskZ0Tdx9Pll+0yaFM0gR
	 zlNDFUWJMOczkACUsGwN8MPRUAqwRV6LE9uBJBeMpnKs7GVFkGrBmwCb5dqC/tBonMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2qpvyTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77DF606A31B;
	Tue, 20 Oct 2026 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2qpvyTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C31F000C9;
	Tue, 20 Oct 2026 21:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792530659;
	bh=QUYrFt/9/eGDOu6Wr8mvLw1GjBqci4jL1e89f6OPWXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A2qpvyTbemM/p00b3GlPlyBMFwlKkhprVh0FQY0JI3o3OsEA1RRTfoKyti41XG4S/
	 hDJTg/nHMCV2i9Zguygw6Yh8txRACVuY7NeEC20If0KJEnoLKN4RGzLOQZPnLOf/wD
	 dyh/iDYEB/4tLgDGdq+eoTsK6KZvUQ73+fbPpc4tF5lsBC1H8P0TxlH7aE/NXh0N/9
	 dvngmcoIGObp7B4yiNfMwHROCHKx3MXgmeRhpgwo0gwB/lPNm+qMtrLZXlep9P2seP
	 CFYIc4aCH+bgL5KGNGlUslGaenVjYBB9khxg4PJIGVKIuidakiWAVb5g05TWDiR92E
	 pwftDvOea8SlA==
Date: Tue, 20 Oct 2026 14:10:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/10] Netfilter/IPVS fixes for net
Message-ID: <20261020141058.0acdb035@kernel.org>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Oct 2026 17:02:39 +0200 Pablo Neira Ayuso wrote:
> 3) Fix races when handling overload flag in IPVS, this patch
>    is not perfect but Julian considers this improves the situation.
>    This was uncovered by LLM. From Julian Anastasov.

> 6) Initialize IPCB for inet/ingress reject, uncovered by LLM.

Could you look over the LLM review for these two specifically?
