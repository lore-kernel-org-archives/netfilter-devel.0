Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792538226;
	b=Hq2o5ygSFXo5JvzBwZ4KxhYLllk2Hx0z70rnBYMDXh7Cc+yvep23vh1Fz6kqDQAnYLtV
	 ZiP49Ctri1177C7vfb391ae62Q3kI02N7Ezje1OdazfivuzcbjXw6VuGxgx3il2K7L+jI
	 4GnGOyGpghAtBPc7ameWDhW+HygR8E/S1I7DGAJOnBV731KbNGf8uvkswrzvLkgYGTdkQ
	 ED/ZCRIBueOsQwWXmryDqoHUstMmjQtOIM9debZXI1TZpZo7/HOIgXVWAxDbHp3uwnuO0
	 dyqwewO9p2ikbIs2zGlGfYSPHVtpvWtTltLSj/q2dv0NhMhy393r+mPtMj0f16n5mAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792538226;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=DpoVZIX+wLnFN52e0quM21al8hpPZcSTcRv6TBtVCR4=;
	b=b2oJkU7diSyD0LZKNx34xTOhlei9G5KcmUzzgaJh+j2bAZoSabXSuGJim5yjzebJgt5V
	 +IcmctpK99j6BFGkZbcVo3kMj/GFha1Hes35DrQa3Gi8iv7aC3Gt8HjaCV++PidtbV1FE
	 a0Z5mA9hE0tHFS+du/JS0gIUqtt4qAnV9IJavquc02G6k35Gf2sdquFjyYlItutGco5S3
	 Tu2oTf7N5vAwDcNZiGRQfBhzACJqv+UIW7OK9lQNPxWRujuW12BrJ6RbBnVJWpVPWlgbK
	 fi5s2ZYlkl+rA9G6DYlb49DfCCeAwWGeG2noyRY6BTp6mMVPQybCnyouxZ/PbX7Fihw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XOxRhIY7;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 458AE606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 23:17:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 458AE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XOxRhIY7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792538224;
	bh=DpoVZIX+wLnFN52e0quM21al8hpPZcSTcRv6TBtVCR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XOxRhIY770iUxOEG2SAzIBmP2hggzbqknw7Qsn52PtPLJHnJnjkFmMXAJfVlR8TkI
	 8SQi9mhBYTsslE9ewdg/AHC5D02aqIO2jxsLCP+wiCL2JdchGaUcGcgd3QpyiN0oL6
	 uLybJWiKksGXmocw0uAUmroFQh4q1/K+9oNQ9hScAGa4EyLEdvFuyDfSLYeVQmLVHu
	 xEHWymTMqXY6rjsvn9mc6Moo7HPETG76rJFVPXOwpAdfg3d/LlC7JOSx6m90RuorX5
	 SvOFCVcziItJPDQocyY5S0hCs1fT5yJJ/zi6uSg1t/43WjvAD5mEWMe2Yjf2Dfp3Kz
	 6dmVgNGM7LS8g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DC67D60050;
	Wed, 21 Oct 2026 01:17:03 +0200 (CEST)
Date: Wed, 21 Oct 2026 01:17:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yuen Su <zypulsecore@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: apply the receive buffer size
 to the event socket
Message-ID: <atf2bRP7z2j8gogm@chamomile>
References: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>

On Sat, Oct 17, 2026 at 09:03:09PM -0700, Yuen Su wrote:
> CT_EVENT receives notifications on event_sock after socket
> consolidation, but --buffer-size still configures and queries the
> separate control socket. A larger value therefore leaves the active
> event receive buffer unchanged while reporting success. Use event_sock
> for the forced setting, fallback setting and effective-size readback.
> 
> Add an isolated real-kernel regression that traces all event masks and
> two requested sizes. The original fails because the option targets fd 3
> while the multicast listener is fd 4; the fix passes all eight cases.
> The existing conntrack CLI suite also passes 286 cases. Prepared with AI
> assistance and verified against actual netlink syscalls.

Applied, but I stripped off the test, a bit too specific for this bug.
