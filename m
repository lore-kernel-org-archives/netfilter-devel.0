Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935418;
	b=yfDvq1oDzGorYj/rnyvTdwOAg/xpq1lWiSjKrVgbs1PuJ0Bbagwy0B39tQhgSeJW83SA
	 aG0OJtDV+nZjrNnqB7X2b47T4c/e9oRAcOi031ljjbl+3PzPnfehr0Godt4fjoQqkS7Zo
	 KrI/HZh2ehy9PHKG6p6gBinZNCa7L8WvkYnLZudJcongwwKuIqBEC4I1tivw7GmyCASQc
	 HOUsNPrdTl55tuia0yd7EAoOfrAaw5hX95mWurK5akvgnBs2dGoCyPLDa2JqzWmnlYTA4
	 PoGIzdctr/xUzACSMtyqOTCnHe5fSRuxr47i0YJlf+HwNB8vRxp17T4tdPHmRWJ/hpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935418;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fVuwueDQHPgRhsHVqiZJjIWq6hcMgzSLoPqiqQuF8CQ=;
	b=RJwsJ8LYjfPnqcUTEUxlWLMnLVAyRHC6TnlqsdmrzOPoPODFNyszbN+3AuTEm/2CUDFS
	 NIUd55ezEi7b5QQ9SGIKM7eYnWVWZJnRHiEG+JCeLGrjp0+9MGrD67Mc0EwA1RW4q8/Wn
	 SjEHF1mvGwEO+KWlGkFNhmJaXTuaYjG6Twk5IekLBedaqT0kSdiA9ouF0f2U6rXP5Nko8
	 XTxIUH7WXZMnAivbFcRf6azhRVmsJYOdSHASxXfWJRteuZHBWhz1PCM1BG1S2G/jr2hLp
	 e29y7dv/GZq72qxJ9bB7Yppk/q1kV9bNdeZexPYFcWUnZRhMCUbPjwRHXRdc+EmC2ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AF6606A8B1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 17:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7AF6606A8B1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5DAB860342; Tue, 17 Nov 2026 18:10:15 +0100 (CET)
Date: Tue, 17 Nov 2026 18:10:13 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset] tests: hash:net,iface.t: add test case for
 wildcard matching behaviour
Message-ID: <avyKdRvnUJhocERs@strlen.de>
References: <20261028130203.1398-1-fw@strlen.de>
 <86662718-9117-5c82-cd2e-74298a9a2c7f@netfilter.org>
 <avn4KIth2ics2YkS@strlen.de>
 <c8ce3baf-9b2a-f149-47ba-1c8b5ee1885c@netfilter.org>
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
In-Reply-To: <c8ce3baf-9b2a-f149-47ba-1c8b5ee1885c@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> The tests you added verify the expected behaviour and v10 passes all 
> tests. I'd not add bug-compatibility even when that means the experienced 
> behaviour changes.
> 
> Please apply your patches :-).
> 
> Tested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Thanks Jozsef, I pushed them out.
