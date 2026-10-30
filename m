Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372855;
	b=m6XykfxKQsyDZJ+Vk8B153GWJHqigZ6A7Yx5vkQ2MxGwMA58qS3hLkZox2bMc74op4wV
	 S54oAbC1wSence4jZuMIVKtJhYpzGsXdsyb0G/a5TbFPBtsfjSshdc386XuEgG7CGcM85
	 ipGpUSX8z5BjisyvJNmA3Z0v0s1BdtJzNyaVHwaCWsrASXGI0obM0/Oe5Ouh1WWedQnII
	 lTTE48cVcxID/pVq146MBsBt54mqT9fkprxe5Bz2fxClPzNCs3ShylCIdRAIRcojSzfrm
	 1i0idGaNzvvcadW2ApmYNlNSEHLJOhyNSyH436N3vcjtr6QwKKUQlRqzKUu69mAUYcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372855;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=edacEfUUfj9+2Ds05x9ylerXtG7TayD8NJcx+WdX5wc=;
	b=Q0c/xxjBUvNypu7yDUqBhnxZcShkwPKrqvm70oZsTgYsYVctlAuslXPZkI+bwScl1cjb
	 DI72qBKUM5LkiJQWSNaYx9OIlPv49xnUVwb7YSyDtv0+2eGgGTltSP9pme3BJ0iEiSAl8
	 VE/XMCbKZbmDj0FvYKGJpO/aOO6VOA/Ttz8fkRdrrGtu/RdBW2jWicLBO82YPnuEtYmT4
	 6O347ydPjUrGv/5fT7tYz6W0Lu1Brd0B41Abg4n0vHpZgA6q10WSXkC32xG3P3uFTHlpZ
	 Uus4Ry4jDL6NakA7LL6NYWYEbNWxLbQt9neskW6QV9F08wecr9A1m1O4FyptE1PjaNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3745606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3745606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BE864609D0; Fri, 30 Oct 2026 16:07:32 +0100 (CET)
Date: Fri, 30 Oct 2026 16:07:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership
 when expanding skb
Message-ID: <auSysrRmBdIesdue@strlen.de>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de>
 <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
 <auSvco0w7wKkuyE9@strlen.de>
 <964c22e6-9be8-4896-8c7c-45d927789c97@suse.de>
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
In-Reply-To: <964c22e6-9be8-4896-8c7c-45d927789c97@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/30/26 3:53 PM, Florian Westphal wrote:
> > If you think its worth doing, then by all means, go for it!
> 
> The ownership fix is trivial and already done so why not? Anyway, let's 
> see what does Pablo think and decide based on that. FWIW, I won't go for 
> the whole memory issue fix you mentioned before.

Its not trivial, unfortunately, this needs wmem adjustments depending
on destructor type, else accouting is off and sk cannot be released
anymore (or we release to early if truesize was reduced).
