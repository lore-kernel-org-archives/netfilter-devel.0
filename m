Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F1928DB54
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 22:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764887857; cv=none; b=Za6mVDtxHpSIIchSU4XDDb/yJbRoxbO0G4qsM3zpj8c9GvZ4hgVS+XInX4T6RpkURJGU++deeuGEKu+c2dh1DETzRNDEWvCJXX/m0j0EiWRZvLWlyFFUCjj0nrTaR/77SH/hQomuC+WWHQoe/hNHI+KicHrhfnanl2j473H3PoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764887857; c=relaxed/simple;
	bh=Ppdgx/cQLEAkvTAL1rDot1kgQQjMFFjZoST5v3hXX/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FY/u0H5WsT7/4TXf3rnj5u6LWsV07z1hZL6ZE8kVr7dryTRIOunQonMuPLDtccpQrE4cZYfPTo/wRjaoTDnDSwS//onJwe8rm/2E2cr28QdRa9tegihthEK3scF7MNNSbnzEoPPM1fy9b3Bm/nBOugNxjZ6g0yKd5JatioLERyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D09D60336; Thu, 04 Dec 2025 23:37:32 +0100 (CET)
Date: Thu, 4 Dec 2025 23:37:33 +0100
From: Florian Westphal <fw@strlen.de>
To: Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: on syntax errors, output expected
 tokens
Message-ID: <aTINLRJlBUIox3pC@strlen.de>
References: <1950751.CQOukoFCf9@imladris>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1950751.CQOukoFCf9@imladris>

Jan Kończak <jan.konczak@cs.put.poznan.pl> wrote:
> Now, on syntax erros, e.g., 'nft create fable filter', the user sees:
>    Error: syntax error, unexpected string
>    create fable filter
>           ^^^^^
> The patch builds an error message that lists what the parser expects
> to see, in that case it would print:
>    Error: syntax error, unexpected string
>    expected any of: synproxy, table, chain, set, element, map,
>    flowtable, ct, counter, limit, quota, secmark
>    create fable filter
>           ^^^^^

Thanks, this looks great.
Just a note that there might be slight delay with this getting applied
because we'd like to make a new release soon.

> Heed that the list of possible items on the parser's side is not
> always consistent with expectations.
> For instance, lexer/parser recognizes 'l4proto' in this command:
>    nft add rule ip F I meta l4proto tcp
> as a generic '%token <string> STRING', while 'iifname' in 
>    nft add rule ip F I meta iifname eth0
> is recognized as a '%token IIFNAME'
> In such case the parser is only able to say that right after 'meta'
> it expects 'iifname' or 'string', rather than 'iifname' and 'l4proto'.

Yes, thats fine.

We should move this to flex keywords, this STRING hack dates back to
the pre-flex-start-conditions era where adding new meta keywords might
have broken existing rulesets.
