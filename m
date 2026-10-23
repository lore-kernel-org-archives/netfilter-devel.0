Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756604;
	b=P/qSBWlHYCOUIMPc4sCKa3q28jkRsLrBiowAoeNxaYlQ3tKLQjsZjM0autoyMU0ispwP
	 IEyBNqqnIEi8UpLmgkdZiywAWZfAlhW4wMpOEB4KLfOsuUV/e/jDwxqJ5YitkYDTXPr0a
	 7uGmxPku6HUbdA8aO6dzbzK0mvsAfqJ4A8U8ivmofjx2dQcQ3F+4yGpbmbbZnK5oIwYE+
	 L9ETj8ULM3e+b0SYXsDnk3WZ6SR5XvGPqDCFJkVMP12IWU+uwfEQ4sJoPA0BiYKszapNA
	 we9kX0pgXv0x/ROABrVpZyGBsngFObIXADaaJ2h4orcrERDaBAA8OZusb2UF/1rNIow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756604;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JIHwxeTAEob3DTE7Gv6LcKMmxCel1xscC5p/72XpHzU=;
	b=G+T+OPIX+SsJsGib+NNF+HQbSWLVcoNM6GShAujjyZy16ufij14dsaaBRbpiX3Cw1VpR
	 0b3HDxZn31TfYaWjNA/9MHdcEOzWH3aqwU65OtgPJeKzt0OJUv+PFOXnHV+D4FZRxpVia
	 PHY2gYG1/W0T7hJ2zZxbw0dqe4HsP4dMUCCWKY6amktm/u0emIpaDb/9bBDcXtyDILYqW
	 GKmbnB2qi6S7Rywf1vKC/nugKbL/WApCUMykhH7SKKwYoazu080n+RyksqHZSuyi9sezH
	 GtZFydP7KT3Xmq3nQkBQEQJUDTbm9LoRcmDKsMu5irMsYPwYBGDmEyjxpvU4CXYJdww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1EA606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 11:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF1EA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D36A960796; Fri, 23 Oct 2026 13:56:34 +0200 (CEST)
Date: Fri, 23 Oct 2026 13:56:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix for spurious fail in
 maps/typeof_maps_add_delete
Message-ID: <attLaqI7J7QcsupL@strlen.de>
References: <20261023103603.1048380-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023103603.1048380-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Testing on a (probably slow) aarch64 machine yielded dump failure since
> ruleset listing had '# count 1' appended to map size statement. The 3s
> delay supposedly wasn't long enough for the element to be reapped after
> disabling.
> 
> The test itself seems to perform all desired ruleset checks though, so
> just drop the stored dumps to avoid this problem.

Annoying, but spurious failures suck more:

Acked-by: Florian Westphal <fw@strlen.de>
