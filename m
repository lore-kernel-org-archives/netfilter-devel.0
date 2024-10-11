Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBB804
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 09:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728638871; cv=none; b=scotrHppX1r3x20Bfe/ASoGEjqjXlQEcpY9EhLk+SXFBqLQq6fOI7WvhCnDC4Hb0V4Z99CYyJC+mZjncw/qpQebc40YTkMdcXHqp3hABMpqku+F+dURnfQBTYAI7TuUXtHUx1c92e9RTwS1GEHvW+RbqiFp73RztjnqkmqvhPxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728638871; c=relaxed/simple;
	bh=G4fz+ZHiYEcEzLdYmSGo+Gp2fAnC1XQ3mT8YGYWa+yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlQ2hNcRNJZE2RIow8rblscwACiG941RO8RbNwTRrvKrxiclOLQLD5XTrmSXAoJNuK8dIE+uvkAMygU3Gp3lk4Ac88FM9wzIhJmGFdrr4hmbSkXrmOWXJAN/e/Y+mCUPElBXIgooMYIip0OfG3gHx/qEXPpl3FmVyfOQ8gE3FPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43668 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szBvt-00G8ek-Ut; Fri, 11 Oct 2024 11:27:39 +0200
Date: Fri, 11 Oct 2024 11:27:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [nft PATCH] tests: shell: Join arithmetic statements in
 maps/vmap_timeout
Message-ID: <ZwjviVcN1LfcBXee@calendula>
References: <20241011092508.1488-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241011092508.1488-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Oct 11, 2024 at 11:25:08AM +0200, Phil Sutter wrote:
> In light of the recent typo fix, go an extra step and merge the modulo
> and offset adjustment in a single term.

LGTM.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/shell/testcases/maps/vmap_timeout | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
> index 6d73f3cc9ae24..8ac7e8e7684ab 100755
> --- a/tests/shell/testcases/maps/vmap_timeout
> +++ b/tests/shell/testcases/maps/vmap_timeout
> @@ -9,8 +9,7 @@ $NFT -f $dumpfile
>  
>  port=23
>  for i in $(seq 1 100) ; do
> -	timeout=$((RANDOM%5))
> -	timeout=$((timeout+1))
> +	timeout=$((RANDOM % 5 + 1))
>  	expire=$((RANDOM%timeout))
>  	j=1
>  
> @@ -28,11 +27,9 @@ for i in $(seq 1 100) ; do
>  
>  	port=$((port + 1))
>  	for j in $(seq 2 400); do
> -		timeout=$((RANDOM%5))
> -		timeout=$((timeout+1))
> +		timeout=$((RANDOM % 5 + 1))
>  		expire=$((RANDOM%timeout))
> -		utimeout=$((RANDOM%5))
> -		utimeout=$((utimeout+1))
> +		utimeout=$((RANDOM % 5 + 1))
>  
>  		timeout_str="timeout ${timeout}s"
>  		expire_str=""
> -- 
> 2.43.0
> 
