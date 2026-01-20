Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2223D1CCA
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768949755; cv=none; b=iKw+KwTCzhzTJ2mSK4JYc1+OAzOJPZdkWhUjUHfq2sumboleDvjd+ryJ04eNQVhYig2tt5p0WuSUHRvIGp0MGei+Rr/dY8/FbJdq2Ltc6Z71HjW2oHJNZOv/lk2MYnjEhx6/tvH9vCS1isF+3Na02d62kEVanTgqiyCTRsNqSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768949755; c=relaxed/simple;
	bh=bhBjoEA+Wn/JJzWlA1xf73Qfgf1bZ5RtBilIKVCH4pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YV9eRp3Gdup6DqR4j9twwLn8JTDE1Zbfpjn+jEB1TzqECKNA8yjWde/HzFegukjIf3jXGflwBXETPRePcTzru630E7W0wGaa2wY/Q6Z7btbciMKYOvTvwu8LM6prvWIT1ZnlTs+MdAPnlCoidEOaN633Kshq/LAcFMP80Tr0tjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=N3Njy+6h; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="N3Njy+6h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rgu+MFgNmkfRpJepwKGp577vJ0Ne7X1fdIG/hn9ypFk=; b=N3Njy+6h+57L0CgT/YIy2kuoWU
	B50d9pWy2b/V5MbhpAzGWEs1oCJm27YgJlCbT6Lhm8crSY9dc7UMJxGD0Mh4b0FAw+7hiGxJUYlf5
	gnJm8B6/NlpcvhoY32YK5TltiaudgjRt6Hz1sGjp5uBLIWFrDpilRFSMgXWArRy2gV5kAyFaSTD98
	OK9izgcn780ViRq0sBKDX2SyP6aKKsX1HbmvUHIzpOBUepcgynYy6ahP3NSIKujmQ70UOlGGVCdbz
	rSnLGkCNuX927Whe2czK+YvzWooIvbTBWC+DNurvOfh8ur6alJsoEHD4Y4i01fSBQpk1uRFqmN6nL
	Nf5twFhQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viKdZ-000000000Xf-1PQB;
	Tue, 20 Jan 2026 23:55:49 +0100
Date: Tue, 20 Jan 2026 23:55:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v6 0/3] parser_json: support handle for rule positioning
Message-ID: <aXAH9Zf_5z-gbP7A@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20260120195303.1987192-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120195303.1987192-1-knecht.alexandre@gmail.com>

On Tue, Jan 20, 2026 at 08:53:00PM +0100, Alexandre Knecht wrote:
> This patch series enables handle-based rule positioning for JSON
> add/insert commands.
> 
> Changes since v5:
> - Merged nested if-conditionals, sorted expressions cheap to expensive
>   (Phil feedback)
> - Use Reverse Christmas Tree notation for variable declarations
>   (Phil feedback)
> - Test 0007: Use $DIFF to verify ruleset state after ADD operations
>   instead of just checking command success (Phil feedback)
> 
> Changes since v4:
> - CTX_F_EXPR_MASK now uses inverse mask (UINT32_MAX & ~(...)) as
>   suggested by Phil, for future-proof expression flag filtering
> - Removed nested block in json_parse_cmd(), variables declared at
>   function start per project style (Phil/Florian feedback)
> - Test 0007: Removed redundant insert position check (covered by 0008),
>   replaced grep|grep|awk with single sed call
> - Test 0008: Added test for insert without handle, added test for
>   multiple commands in single transaction, fixed error message typo
> - Added .json-nft dump files for both tests
> 
> All JSON tests pass. check-tree.sh shows no new errors.
> 
> Alexandre Knecht (3):
>   parser_json: support handle for rule positioning in explicit JSON
>     format
>   tests: shell: add JSON test for all object types
>   tests: shell: add JSON test for handle-based rule positioning

Series applied, thanks!

I added a small fix for tests/json_echo test suite which broke due to a
leftover handle in an add rule command.

Cheers, Phil
