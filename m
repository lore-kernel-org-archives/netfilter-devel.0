Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A642E7BB6
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551311; cv=none; b=RKX1EI33qar6L8XDwkLYhhfWyrUHVFXpYHPdN/9Uo5Ye4xcscHr/xT9RSiAJtSdbVSalJdjjy4EkrAaJ0LlZ6rFUKiCfQ5s/UFDeouMExQ359UBv2Kwt1UHKfyTFRGEQe68AdbtIVCKGymJL+bX3Gt985VkDpDp6pq09XWXbaa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551311; c=relaxed/simple;
	bh=tnLO6KpvlvlYM4/popro3tOYXBioz6TWpSIlQJvvX3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLvwGggbyMZ/O5EtcLE/Nqvuzu/uDF0b2dctQ9riNjtMfQGDVHU+FpZvFUODxdQpbR+ky6gdfJtK6ObSQs9SZuIrLBju2Vcmy66C7Mrbgx7OcNsZ9UrkKlIBChGT62TczSxHldB7Puc3R4hF5bhGV8K9v/KmZ7J/HjEE8Uu2efw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EQdNresv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FmE1wN8K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EQdNresv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FmE1wN8K"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6AFF160265; Thu,  3 Jul 2025 16:01:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751551307;
	bh=tnLO6KpvlvlYM4/popro3tOYXBioz6TWpSIlQJvvX3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EQdNresvNxf4E92QHjV6sb9n6rGFosaY9PiPSe5bzPCOsJlrUmK9mbZJF1W+Tvpvu
	 /d1ueAkZuaIZmAcZtwPkFy1+J+AZF+lIYDlnpYS7S2Whdp2kxGwBXta/UOac39KmT+
	 6j4gSTcYiHu4Xb9B/FVGonWpbkEDPS3Xsu19r48JhFareogT3g+xx6zcZLnoFpvg9G
	 BR4fX3lldfPl6RsEuOkMOxBjw//JcUaQypzBfP+y90w2T9mlhiNNBDdaDt4FrA5GHc
	 bwTRWJ2i/xkv9jDIarYQXm/r2ymmARMj28LT2gQvrIcIOrBH/bFQS9XWjsxEGpy+q6
	 GpS042lwIk+zA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C79C060253;
	Thu,  3 Jul 2025 16:01:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751551305;
	bh=tnLO6KpvlvlYM4/popro3tOYXBioz6TWpSIlQJvvX3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FmE1wN8KY1PBUEaPVhK6Yh0EV2MUObAs6a5jqkZgba8lnGaPoUaQwXfJR+ucnmo+w
	 J+GjtN5LUcZnjp+1QPiFHe969eHXU108TGwq4Nb9x7GHpkzeRdU/UqUtvPsiqNZgoP
	 XWpXW6Pic8ck1cXRbudn5peeEvaV/8RcUPSCYqj0VBe3xAKaRjjMo/tVHF8Hiw6Ihv
	 djKvCeDp+eQddsxwYbcp98xteUVNIHhbUtSVq5DKKQwhJEbksQr+XxppGd5RxvpQ0z
	 mvbXDmTQ9F3lkuFGk6p2zXbOXE+k0ObxCbBmfRQIgdwS0bSh+C6bCfkRd3QLJmptp7
	 6+Up3Y6/EnJTw==
Date: Thu, 3 Jul 2025 16:01:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nft] tests: shell: use the given NFT instead of the one
 in the search path
Message-ID: <aGaNRgktGX06q4z3@calendula>
References: <20250703135717.13735-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250703135717.13735-1-dzq.aishenghu0@gmail.com>

On Thu, Jul 03, 2025 at 01:57:17PM +0000, Zhongqiu Duan wrote:
> Fixes: aa44b61a560d ("tests: shell: check for removing table via handle with incorrect family")
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>

Applied.
