Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F522DE70D
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 11:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761736690; cv=none; b=pK+jcCpD2c8Mzo41lTZlwpZ+LmGitWLStRmLdXiaabHRiVHYr+T4XKMNN/fo+oCb+rJ26+n1gJnYtTncskN0dOM0CYzlG4Y840R06zt8Bf8OkDT1AQ+lWFE12t0WMGCQFT2cfWGRU3jtMBgE17qCD9zi6v1ogtdJ6fvwOAi8rv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761736690; c=relaxed/simple;
	bh=lrBPGlCbCmTv/Q4FVq0rk37wFeAEbdLfaXvCgi3vKAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7EI5i8xfdI5A2/G4uZMbsCiSsnouNJFRbaXiL0qSMutwBtZFGzfFx+x1X4i4KVVgLvHO7I9jeZpE5UlOD5nbSE34I+SUxNCakRVhfebRggi3Wjk7SKR352ZLA2dI7MHGpo5Nn/zu2eNIfMCPxUBvHmWPTL8AD7insJat1txPwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6C9DE61AF5; Wed, 29 Oct 2025 12:18:04 +0100 (CET)
Date: Wed, 29 Oct 2025 12:18:04 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] parser_json: support handle for rule positioning in
 JSON add rule
Message-ID: <aQH35JaXW_R5j-pl@strlen.de>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029003044.548224-1-knecht.alexandre@gmail.com>

Alexandre Knecht <knecht.alexandre@gmail.com> wrote:
>   # nft add table inet test
>   # nft add chain inet test c
>   # nft add rule inet test c tcp dport 80 accept
>   # nft add rule inet test c tcp dport 443 accept
>   # echo '{"nftables":[{"add":{"rule":{"family":"inet","table":"test","chain":"c","handle":2,"expr":[{"match":{"left":{"payload":{"protocol":"tcp","field":"dport"}},"op":"==","right":8080}},{"accept":null}]}}}]}' | nft -j -f -
>   # nft -a list table inet test

Could you turn this into a test case (tests/shell/testcases/json/)?

Thanks!
