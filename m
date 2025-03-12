Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA261E48A
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 00:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741738507; cv=none; b=how+psh9AT1VAjqUa5ZlHeuqB3Mq8Mxw/Q13z8ylr3kcWbRfOuAGggswJg1E24gBGg29s+bMr3X8nWOVIpST5gRr5hoetJsPkJ6FbLfmT5yeoyKbEXXY/PZYUIzoQVh1ZATOm5EQzEPwjHFtaQT2+UKoT+OSMcBJAtwn1RqySp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741738507; c=relaxed/simple;
	bh=yhmGdQyqjR4l56qcesKlEMgtyWaSlnkrBmp+maDfwQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJxlhKM5Da6cRgNZ7iuPnBo3wdvtzFP9DqKHyb/OiwkyScrujq18n0Io8CYV82EUiBUgXNwykxcroDcPDq5hM3MZspf7L7zCf2vHIV412W2WutofVxGvKx3TfjOFZLkqChuWRVppOfkKH4Clna7W1diYeyosn5TQs+9/SI3CLVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KIMEO+xL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oxAwB+T+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KIMEO+xL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oxAwB+T+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1E3CE60285; Wed, 12 Mar 2025 01:15:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741738503;
	bh=cbeeveHbYvGwX9+dpfgVlf7DtVSPsO01dgtvVp4Mk2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KIMEO+xL2N0T+lyb0tXzd3C0k/QCYFJ5rhFBQeDU8X6wLpYdPgeyy+SgR67XvCUBy
	 23YiP0ZsBuESznZsYSc1gauqxOBScr/D++ximDcTxFmvNsE0o6C8x2rqyM4qOUWEay
	 kGAa/00nOdEQtpHAHSmm/IbqhUcJlIvtPX3iJEVejlo6ZVAZW2dzUMgqKhVzaoGaOF
	 FdD12dH3rtFt+gXvBPK9HsoPqlpWlN+pwawjzlpHT9bwpQahUn3ChMEfL28gsfhYRQ
	 nDE+63WdpvkkL86s0h1EtlU5c9woB/UCffbIigUvxh7O0BtoeAhi706T0V4T20Wwic
	 9IdfSbLV0SF3g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E6D260279;
	Wed, 12 Mar 2025 01:15:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741738502;
	bh=cbeeveHbYvGwX9+dpfgVlf7DtVSPsO01dgtvVp4Mk2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oxAwB+T+Yf5migFIWSebQ1a7M7jMbkAJwVV/jztyVu3np0ueMQGhW8BOB6mJDDseF
	 s0/xLFtNCJxvfNpSg+Kge6p9BOIhcoGUr+icrD35+6qW94P9UgPWGNLAcufhabGbgL
	 pIed2JrP9s3nGvsgI8MR2ViEwX2ls4TwLwTTWMN9pWuhLN8w3xogAB3jtU8oYpc2aP
	 gYXaJbIgloxEds+pO7gwOaA1bY4AS7zU80zoH9DYjSDf8+mvRNahcZfRdy6QLrC57t
	 EM4Dpj6Cydwbv7JkAM5rCdsRQbd9xDHZ3sqIDXnv/JMyllT26hBGLPYsoeJw4jlXEB
	 s5MB6awLhbNeQ==
Date: Wed, 12 Mar 2025 01:14:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix expression data corruption
Message-ID: <Z9DSA-cH-eWPyWBK@calendula>
References: <20250311130707.12512-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250311130707.12512-1-fw@strlen.de>

On Tue, Mar 11, 2025 at 02:07:03PM +0100, Florian Westphal wrote:
> Sometimes nftables will segfault when doing error-unwind of the included
> afl-generated bogon.
> 
> The problem is the unconditional write access to expr->set_flags in
> expr_evaluate_map():
> 
>    mappings->set_flags |= NFT_SET_MAP;
> 
> ... but mappings can point to EXPR_VARIABLE (legal), where this will flip
> a bit in unused, but allocated memory (i.e., has no effect).
> 
> In case of the bogon, mapping is EXPR_RANGE_SYMBOL, and the store can flip
> a bit in identifier_range[1], this causes crash when the pointer is freed.
> 
> We can't use expr->set_flags unconditionally, so rework this to pass
> set_flags as argument and place all read and write accesses in places where
> we've made sure we are dealing with EXPR_SET.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
