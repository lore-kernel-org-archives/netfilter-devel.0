Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793473382;
	b=nZOl93E5XEitThm+u9Rytj19/Tbb7iMlCjcZBEb3hWdNJST3BbMQ8Qit2Vq9qrCRo6AZ
	 ttoDt9PZuIoX1QvdZ4DyPd4WCHDVo3+z9x8dzSzJUysteprGfyUP9d+nu9ovmEUnzUlpt
	 t4cCj9SVmDcH0+HovdJaZWFOOJmm6Ar70ibS7V3xdb2fYayhSyU6kXrKinmnh6q+rJoEb
	 L67Rqkq7QZEiGVEsJ4Vxc2Y/aZbQZOOVruZlxcQ5clSp18cVUGGgVCNh0uIO08zLD47LW
	 yF21t36du7X9Y+BsMhsL9HXb4D/Da/X2dX+MkhCuEMyApWqvjmASsFeStc6YHXDbWKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793473382;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gGN03qe09SNkizCPfFELgfkpfjmkctr2ib49NxHt9pE=;
	b=it+ETQXVxMXkfcJQ4lpVgsuBFzj3TcUtg5OLCQlA0BejRU2sVvXoBhTJI1eNRByNhMSI
	 CH48l27mqpc7mAEHOS9njDqA/djhrCevpUY65qpIpmNkNv7cfiBSDmsSliF0ZntfzG6lw
	 glbifcUiAFAGRV5W84m2sfpazYdb4SYwlCv0XSe7Mns2XswdkQB0LnY+wLnn9RKGEZqql
	 RfwuxVqFZX/1IxBYLEUB3KMSv6q9mEMGTIMT1dpaBhyWd/wsaBo0Sz81Ua7YrFw14oRpy
	 wMmvVPxyrijc+AXWi5hBpnWTR9x/UgCpX2EleuS40Fbi41Pic2DfLLKhGr4iwt5jUhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CBC606A31C
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 19:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83CBC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2748260796; Sat, 31 Oct 2026 20:02:59 +0100 (CET)
Date: Sat, 31 Oct 2026 20:02:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nat: zero newrange before filling it in
Message-ID: <auY7YkXDSBrbYAHu@strlen.de>
References: <20261029165445.3745-1-fw@strlen.de>
 <b6dd522c-dee9-4b64-9ac3-b11e03b21135@suse.de>
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
In-Reply-To: <b6dd522c-dee9-4b64-9ac3-b11e03b21135@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks for double-checking!

> I agree that using C99 struct initializers would be preferrable but let's
> look into that later.

FTR, I do have those patches already; I will send them out once this
patch appears in net-next (via nf -> net -> net-next chain).
