Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8834C1DF261
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791755035; cv=none; b=uZYeFFZSc3EBEo0QofsJOWrrSWFtIL1i2MlCg7oj2VT7P1wR4m2rKCUCAsafOVRFZeRBeyyy3BlmJnkeIlM6ch+PEadEtWg1RJZeWNo6d1O6VhKKJAy91CwKX2X4wkwxcbFzpuh73wAwi0Z7e0ue1PsgAuvauGDXTkjoClP23TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791755035; c=relaxed/simple;
	bh=yqeEQOg8pJ89TGGDe4AaqE4yqMHZmLhwSseRs0PWdfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulqQehrSWFMs51qi5YvEzAs8xIgAV1hL73xSBBaWEHHxqrB6BBuyMQvgo67xXYN9Dh9IGFiP/R3DupEgM/cqRJKifGk+KIKHa10ZUKlx1vHamNHuovrCVnuf/qiWRWkKnBtVXQBp7AAGAreqHcvQq14hirSNjobdqo709TPv4Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vI38JdK2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vI38JdK2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791755031;
	bh=XGwdQmCqYtpmDS0ixGY+ihs4QAchs47Nk+HM5jvV+i4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vI38JdK2V/Da1Cht/NazpWtrT0LJKA8lFcIFEf9M64i3du8oKqLLM2MxqSQ4B2FVz
	 q2EX7TKTSMn5pUbqzhQ+OfjsUxzA5uiOgObTiz8oTbnWuA/87Y9uEobTxGX8nGriyr
	 TBeSmEiMLw3dRg/6QxtJqPXyvgw9CqoiAN4aKBnMl4wSUZgD5EtBx9xIOdNBbXhBB7
	 ObomW8L98ZKphFYa98V+VJtcqKQcWTr010IMu5L4sKaxYBP3aEoM7/Ets8Uq/F58jc
	 18k3IoARDD9+dgJbEG1azR8CRdMIKUZWdH2brsDNqirONvwETZgPB8GpglvDpH2Gr4
	 JN+tPAo7HSAkg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 94C056005D;
	Sun, 11 Oct 2026 23:43:51 +0200 (CEST)
Date: Sun, 11 Oct 2026 23:43:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: security@kernel.org, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <aswDFUpZcFr6jYGL@chamomile>
References: <ass78_hPLuoRO2kW@chamomile>
 <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>
 <asu_nz0tXmnsZIFQ@chamomile>
 <CADikNYBiijxQjptcYf-2+omXj8Mf5PTGVwK-Ho53E7JEe_ehvQ@mail.gmail.com>
 <CADikNYA74Zco-PnTvQOih+=A-Hq6ZCV1oyoC+xszGJy756gzMw@mail.gmail.com>
 <asvf-crRnd2ReH9c@strlen.de>
 <CADikNYDzCg46TWPk0dAXQF-Yar+FgEegWEzFZvzCp3x7-k_mOg@mail.gmail.com>
 <CADikNYBZ5MqJWypk5NFYcxYvPKJhKKyJ5iOWN4JTZrUWf1AUAQ@mail.gmail.com>
 <asv7meqLHaULXrYE@chamomile>
 <CADikNYC4P0F7gz4nCxKcJwsAzXEEA-a-8QRu1TE3SUzXvmcuZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADikNYC4P0F7gz4nCxKcJwsAzXEEA-a-8QRu1TE3SUzXvmcuZA@mail.gmail.com>

On Sun, Oct 11, 2026 at 10:27:07PM +0100, SaifAllah benMassaoud wrote:
> The fact that the kernel does not crash does not, by itself, determine
> whether a bug is security-relevant ( I mean that a security vulnerability
> does not have to crash the kernel to be a security issue) .
> 
> My PoC demonstrates that the byte-rate limit can be bypassed due to an
> arithmetic overflow, allowing traffic that should have been rate-limited to
> pass.
> I understand that bytes/week is an unusual configuration.

It is the user itself that configured this esoteric ratelimit...

> However, nftables accepts it, and the issue is that the kernel
> incorrectly enforces the resulting rule. If this configuration is
> not intended to be supported, rejecting it would be a reasonable
> fix.
> My question is whether the security implications of the demonstrated
> rate-limit bypass were evaluated, rather than whether this is a common
> rate-limit configuration.

We are busy handling _real_ issues, please stop the bullshit.
