Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493AC18C05
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710869171; cv=none; b=Ps1MzWKByxlC6lam8wfAJrOaXhG8LLDfjY8U6yWGSmwKVDvYndROXD3PN9b8jcS09blrwtUfwasrpp5TZO3CH8FNEmvUmLCfJ64WLcs7/9iTbMGBuHMXEsu+565Q3mUPFr/GdNqmuVuF/mpbimcgXNPAeriEbWdTF7MOU3IWpIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710869171; c=relaxed/simple;
	bh=gOnanjPsLODy9lBqGgZHfPXu9Skfnjm91y9UrDvgARc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4qH4QNAES2VFMRsPG3UR0pVK+xaa4BnSZsNXC2jJuMNZMkDJsDuFAYsBeyv3cO1oSBaXLs6zaWbJNsCPP3be2Q7AZmgdeQld6jz1hvmQ81Zq1BFDiBA31Hu7JX6tvGUxsXVeHphhcoCUYyaQWAuc7hSd8HzsAWPg9j5jHgf3Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=czxdX3kK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="czxdX3kK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5i+x9U495FGkPTUS3kGQKU3W8tOtlHpgnkUe4Ms4pfQ=; b=czxdX3kKRDKJERYzGnFK+0yIqJ
	uHt5zmSbI7sSRS7nUkW7k/zbyCg07aDXwNvg7DOoiX+5Q/LS19iyBEriH4hMUCkT3/BPZEHPbsTeF
	PyvPqxt3dqA1zrYxhpDx5QKY1dmvMkd9H5W9/EoSftcwDSTFEb3bY2t59bjaKRW3MRadh5d+8np7+
	X8rZ/O6R4LEkpB/WL9S2P+ClSsk5+TpUnkcJ5LGm6badSS7hz9xmBC62s1VNr45EjJjaypENVQn0G
	UieYoOV27139j0OSzsMJ69QRBSwLv7g2QIq6dNWQXwGn2RQnFTxkK4+Gb0gMtdiwx17kXV3omIw91
	pQ5vBhmA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmdDz-000000007s2-2qYz;
	Tue, 19 Mar 2024 18:26:07 +0100
Date: Tue, 19 Mar 2024 18:26:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/7] A bunch of JSON printer/parser fixes
Message-ID: <ZfnKr3MSzQK9hMfF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>

On Sat, Mar 09, 2024 at 12:35:20PM +0100, Phil Sutter wrote:
> Fix the following flaws in JSON input/output code:
> 
> * Patch 3:
>   Wrong ordering of 'nft -j list ruleset' preventing a following restore
>   of the dump. Code assumed dumping objects before chains was fine in
>   all cases, when actually verdict maps may reference chains already.
>   Dump like nft_cmd_expand() does when expanding nested syntax for
>   kernel submission (chains first, objects second, finally rules).
> 
> * Patch 5:
>   Maps may contain concatenated "targets". Both printer and parser were
>   entirely ignorant of that fact.
> 
> * Patch 6:
>   Synproxy objects were "mostly" supported, some hooks missing to
>   cover for named ones.
> 
> Patch 4 applies the new ordering to all stored json-nft dumps. Patch 7
> adds new dumps which are now parseable given the fixes above.
> 
> Patches 1 and 2 are fallout fixes to initially make the whole shell
> testsuite pass on my testing system.
> 
> Bugs still present after this series:
> 
> * Nested chains remain entirely unsupported
> * Maps specifying interval "targets" (i.e., set->data->flags contains
>   EXPR_F_INTERVAL bit) will be printed like regular ones and the parser
>   then rejects them.
> 
> Phil Sutter (7):
>   tests: shell: maps/named_ct_objects: Fix for recent kernel
>   tests: shell: packetpath/flowtables: Avoid spurious EPERM
>   json: Order output like nft_cmd_expand()
>   tests: shell: Regenerate all json-nft dumps
>   json: Support maps with concatenated data
>   parser: json: Support for synproxy objects
>   tests: shell: Add missing json-nft dumps

Series applied after dropping patch 1 and rebasing onto current HEAD.
