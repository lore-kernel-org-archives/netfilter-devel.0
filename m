Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BE434EF0C
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737767; cv=none; b=sH1btaAz85K0x1H0Ov2dS83eoFCnkiveTX4d0yuYlNBZ5xaNi6Tr8kn2I1JgfK7iu7wT4nNeWaOgbL7r/l2s+yhxjEZk77kbBNzR8BAsTmN7LBW21jRtiQxMliy5xSzjiYV8Ub8H6r6n5iYZzESfo70mOt9J/bE8TkMdlgIajFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737767; c=relaxed/simple;
	bh=a2MRMg9FossOaMNOur78sADjTEYFBKtQuuAWC5XPdv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxSLehhQ6z+Zwf7Wb5Bxf/YfibXxGHHaOGl+U97j14OaRIMXJlxqtF/0GHOqCoKG1b3m/z1pMQNU9andJOtrHuMLH8DsaCtkEy62akZBs/u457CWqXFzx8OijUAjSTJIOxa+a2t3YZ0RFtT9UlNUzX3Pvbov+HvBz84fSRv58ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YGgQ11Ny; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YGgQ11Ny"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791737761;
	bh=6BX8JjnbeABi0fEew62TJ/2ZaUg8Q4FeF1FEc12HlRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YGgQ11Ny8RL1hDzrEh53xyBk7OF7nSts16G9X8Q86rI30P0ZSsmZYoBHUF6hPEbz/
	 jSefs90YuuIblddH7JtuQ9xF2e16RfmvryNqt9p6VcBRuBt7jiHqAfxR8OXUkBibaj
	 S5YOQoncRk6+hvDuif+qV35LBv8SOySgUS4tEfihHYZ6Sl61nu0RL3pY95QetO0wJb
	 32YvFP8iW5El9WiMmbVVse32RY7UhgUDmdyeF0XTLIFlxblJPieL8MjxQzE7YES+ZO
	 pb/vTCWh+z3Ge/JlvI/AnTeyPcnGBBiDHkf+BNLxauCXSzxVIBsxQhDwDOMFRmYkv2
	 CMzJPkZwqGsGg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 857136007A;
	Sun, 11 Oct 2026 18:56:01 +0200 (CEST)
Date: Sun, 11 Oct 2026 18:55:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: netfilter-devel@vger.kernel.org, security@kernel.org
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <asu_nz0tXmnsZIFQ@chamomile>
References: <CADikNYAX9Y0kTzdAZ4zNHrxcheN-tQ-DfQJxzmVmwgR9c5FKNw@mail.gmail.com>
 <ass78_hPLuoRO2kW@chamomile>
 <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>

Restoring ML as Cc:, please don't drop these.

On Sun, Oct 11, 2026 at 02:06:15PM +0100, SaifAllah benMassaoud wrote:
> Hi,
> 
> Thank you for your feedback.
> 
> The issue I reported is not that limit rate 30000 bytes/week fails to
> configure. The concern is that the multiplication used to calculate the
> token-bucket cost can overflow:
> 
> u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
> 
> This occurs in both nft_limit_bytes_eval() and nft_limit_obj_bytes_eval().
> For the tested configuration and packet lengths, the overflow causes the
> calculated cost to wrap to a significantly smaller value, allowing
> substantially more traffic than the configured byte rate would otherwise
> permit.
>
> I understand your suggestion to use nft_quota for byte-count enforcement.
> However, I would appreciate clarification on whether this behavior is
> considered expected for nft_limit or whether packet lengths that trigger
> the overflow are intended to be unsupported.

This can just be rejected from _init() path in a patch for nf-next.

> If this behavior is expected, could you point me to the relevant
> documentation or implementation rationale?

You decided to tag this with [SECURITY].

But why you or your LLM decided that this a security issue!?
