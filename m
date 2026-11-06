Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793941028;
	b=tjtxx6KwYOcMHZx+qpgGYuizk5MR80vMPHRIa0aJsKSi5h+aF5FoDtCtgrKxRO0IEE7s
	 hIlHXBm+BmEg6FUoJeoaVGJcsctfAHzAht+cC8AQQJ2jw/kaIx/Gk9nxfPowXWi2V2eN5
	 kmAWOj/DdN+o0EuUrjUvoKzEikp23+SaaL0lv6Sds05a0Mj+wNGrDeIt5mUcd8MFX/Jt/
	 uHto8uP0sKnZPLG+iMmf6aU3nbBPFrwAseh5FRac4rsEcGLA6pymg6bql9qIE/MhXXFEq
	 ilbHe9gUGIf0P0mk7Xxgu/AUsLNAkb+vf+yfkI649hZ3mVgbGMlHuBOiKzHuOV8ieDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793941028;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jCFp+To8gkzVSYMDGFS2fjcVLuPw4VOjxT2u6qkONLw=;
	b=KzKbb94OBJ5XI4fsQ1MI44oBiBm1L3EDgOmiLo9hmoi0d/Yhf1yP+XSsZohp2tT34wTF
	 RHp8OGz8HMbIlln2WhjwcIdPK6IhptkF6mC0HKu0Fk/5ekU59N61jJcPleFOrhho6PCy+
	 h1x1i6GIL0uKf7r7U5bxBPwSpfKoGNq61SRS8RP3juEmD/Wjcy/yqpMVrJCWH2LMed0Qw
	 pMcwvfBarg82SThGErwnkfzEjycwQ19XzqzRxv17H10MDbgkd+SKHztSj7rHLs37ZTVBj
	 PU9jtfYacUVscLC4JtrOYgQ5LDCnIiB8fLdeEgwne0gtpt8tmjLRig6QNCzn0InQmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF66A606A332
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 04:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF66A606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E2D9D6060B; Fri, 06 Nov 2026 05:57:05 +0100 (CET)
Date: Fri, 6 Nov 2026 05:57:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, xelra <xelra@protonmail.com>
Subject: Re: [nft PATCH 2/3] scanner: Fix delayed start condition pop logic
Message-ID: <au1eIaNvvVpgUPZJ@strlen.de>
References: <20261105173713.72238-1-phil@nwl.cc>
 <20261105173713.72238-3-phil@nwl.cc>
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
In-Reply-To: <20261105173713.72238-3-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> If scanner_pop_start_cond() is called and the passed start condition is
> currently active, it is supposed to pop it and all delayed states
> identified by a zero field value in state->startcond_active. The counter
> state->flex_state_pop reflects the number of delayed start conditions
> waiting to be popped.
> 
> The implementation mixed up popping of the currently active state with
> delayed ones though and therefore decremented flex_state_pop for the
> currently active (i.e., not delayed) state as well. As a consequence,
> the first delayed state remained active after the function returned,
> causing problems in corner-cases.

Right, it doesn't matter for inclusive states.

Thanks for fixing this up.
