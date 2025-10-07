Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BED165F16
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 11:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759835341; cv=none; b=V8QsJyd5szgzjfd0mlWEbi7SdkRIh4e8yVMVR5voMb9ZlNHdxsUrpUnn/Nc0reW+zCTqqcCodm6XL0cMES62sAokErRTHLrlyRHqF0Yt4vV+WYQj7XVd49Cqgnwm4TXErpQTPo9MoMRafVLINa8Ms8LvWDbFx+Tj4VwCDkDf3aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759835341; c=relaxed/simple;
	bh=T8tp7rCSkC9p4zVC+y2XqpIuakrTRrtzO2vo8q36c4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0/7/PIu6LE8Qi1VHojVIvbBxAirJEOw2qjsE9bWfq75jvaJSQiF0XPKZjr1r6LnlKHn6oPiv9SPp8LdQw/TR7MIgs0cBGeMuCgCBid6UD45CoYt6BAuQdFQiC5g2GBDzs3jkXsz++cbgs4VvBmQY1TBQLtc6PT4GxvnU8/zCGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A15+X+rN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A15+X+rN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A15+X+rN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A15+X+rN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A07FC60269; Tue,  7 Oct 2025 13:08:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759835338;
	bh=N0gxvovFgzQpcnFjQ1q0IPss4eIWcbPnEOft5DAae68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A15+X+rNNI1FvzpJuCTNAVVhFGLaSug+ROppWSxnJ2WuffYg0PKQvHv0dsOiv7HOS
	 4oLLvcM+5cvQCEtxz594ZfpnKncH85OlUR5WIvWFqmYHtJupFOmSERyoMAPIAurBHT
	 vE/oK5zXgfgBRcvNuvs51KkbxqQ0N3zZpu8aWgWyIqgFa+CuzMor+6qxwOb2sJWOg9
	 HFEzFyCPEWt4iG2lbneb7wtqb6rg5xj30hS12/bNm/i+PzeIWBT4sHykBZvT+8HxZv
	 HOdPinyNzHQBt0MCrhWhqzdo8gexJlqU66oPgZiyDnwj4KmgoyxfNAkr7xpFF3jHZT
	 moJ4qiXy5iyog==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C47160255;
	Tue,  7 Oct 2025 13:08:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759835338;
	bh=N0gxvovFgzQpcnFjQ1q0IPss4eIWcbPnEOft5DAae68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A15+X+rNNI1FvzpJuCTNAVVhFGLaSug+ROppWSxnJ2WuffYg0PKQvHv0dsOiv7HOS
	 4oLLvcM+5cvQCEtxz594ZfpnKncH85OlUR5WIvWFqmYHtJupFOmSERyoMAPIAurBHT
	 vE/oK5zXgfgBRcvNuvs51KkbxqQ0N3zZpu8aWgWyIqgFa+CuzMor+6qxwOb2sJWOg9
	 HFEzFyCPEWt4iG2lbneb7wtqb6rg5xj30hS12/bNm/i+PzeIWBT4sHykBZvT+8HxZv
	 HOdPinyNzHQBt0MCrhWhqzdo8gexJlqU66oPgZiyDnwj4KmgoyxfNAkr7xpFF3jHZT
	 moJ4qiXy5iyog==
Date: Tue, 7 Oct 2025 13:08:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: py: must use input, not output
Message-ID: <aOT0xy0PhC_vbIIN@calendula>
References: <20251007104852.3892-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251007104852.3892-1-fw@strlen.de>

On Tue, Oct 07, 2025 at 12:48:49PM +0200, Florian Westphal wrote:
> synproxy must never be used in output rules, doing so results in kernel
> crash due to infinite recursive calls back to nf_hook_slow() for the
> emitted reply packet.
> 
> Up until recently kernel lacked this validation, and now that the kernel
> rejects this the test fails.  Use input to make this pass again.
> 
> A new test to ensure we reject synproxy in ouput should be added
> in the near future.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
