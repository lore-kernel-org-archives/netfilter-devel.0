Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881750;
	b=2jIU4QMB/hydCdaqvn2kqYu5rHUbiZwhii4yWVYNgtqOmN8OsdH7K8/MnQeRKBQ1Hbt9
	 I4nfc/uadO/Y0+WhAwcSeqiGwqZlkmJ0Vk6cg6S+v/2wQvZHIpseNTsY+F+E5jI76X++f
	 Ypk0SyuAVI4g9xDRqlxPqPhRHKfyLVEO2RrA5SKS4wox/RXJI3yKuGQ5fvFhPV/stLcBk
	 NnO/86wQWo7BqFaD2o8RvHD47sq0VPr0t3MEtt2j5b+NvxujlvNpDiMY9pTDLxoK9Qtgb
	 ZsLOVilKIZekqllYCqjF3Rff2XQXSStyEmBoZcpm8qwV94KyEMNsGszS9YaL4CiopJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881750;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=L/wCDZTny+Lvo3Lr7G5P7WIRmymnjKm8RubBMyE/Vws=;
	b=WyQqo4Pm7BqLzfr44jKTdaKOyykO534S0WoYM249vbCVg7i3pHgUh/7X2os4+JDNMm5N
	 dpu8oiZ27jWhrxYF4XkM1bbG/W+qorUVtIYW7NzMgrXOvB6GfvcJ20a/vTLh3ddxNEzkM
	 7rNbJmWjAflmpGxfUY8Ljc/8tXVIGEQs11T/LOa0Np8SZrrIdt4wTuFc+SQ5b74PR+5gg
	 TlR3T4cp5Kco9B9XgIT09khjbPRQlifxbueluaNE85uYqyLA4PYJ5w07Zkbi/LdAXCzdm
	 FZ/7DJoisK9hvjacvrTcWJdy7ClGhI3GluQSb+nhhkNy/kWlAwNhv18uf5X+1CuptSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=HtTZbiF1;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D6594606A326;
	Thu,  5 Nov 2026 12:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6594606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=HtTZbiF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793881745;
	bh=L/wCDZTny+Lvo3Lr7G5P7WIRmymnjKm8RubBMyE/Vws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HtTZbiF1xVeDEHJ+P0DUkkXecJufRpNGTpLjtyETBMWmm+Gu9yyfDGSiijvznxSDw
	 mSCk6pCuax6YfauJmYoDc3dWZlYdc7qbXuq/7kLWZCfJeyXIKYQ40TueiPC939vqHs
	 ZyCEVCV9XuoY+guCMVDIsvj/8bCyXP9APLGGwABy/QZHWnPZcSvRauWS8dr0oGyJ3r
	 y9f4MtawcCMVnkxql1DVIwdikAjxlJNYui0g2kVJ7m45ibFsijnpCCnxF+QasCMpH1
	 YCZM47Y4We0h2hr+cmMTm1s2ad1ojgcmLG1uAeSOljUgOUonuOERa+DUCb/9iBkZg2
	 XM9i3t/REaE7g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CCDA8604FA;
	Thu,  5 Nov 2026 13:29:05 +0100 (CET)
Date: Thu, 5 Nov 2026 13:29:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net,v3 00/13] Netfilter/IPVS fixes for net
Message-ID: <aux2j6CxDB9ZxxO1@chamomile>
References: <20261104090224.750548-1-pablo@netfilter.org>
 <51aa2527-0a99-4d67-845a-a8b28f822efb@redhat.com>
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
In-Reply-To: <51aa2527-0a99-4d67-845a-a8b28f822efb@redhat.com>

On Thu, Nov 05, 2026 at 10:46:46AM +0100, Paolo Abeni wrote:
> On 11/4/26 10:02, Pablo Neira Ayuso wrote:
> > v3: keep back two patches in the series with sashiko reports that
> >      suggest they need a bit more work.
> 
> I *think* Julian additionally suggested dropping/changing patch
> 
> ipvs: do not create conns from packets with port 0
> 
> but it looks untouched ?!?

I would suggest Julian follows up on this specific patch.

But I can drop it too.

> Also AI review did not kick on this revision, likely because
> the bot is confused by the mismatch between cover letter prefix
> "net,v3" and the patches prefix "net".
> 
> I think a new revision may be needed?

I can send a v4, of course.
