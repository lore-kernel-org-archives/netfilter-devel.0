Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A5192D87
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551495; cv=none; b=XCVFaazH0a4biob2GnAQm5+ZJ4lS6xWQaUwS/wU3Wtrtnm+/mrNAOVcgwHTZNOAmQLH7ukgOh4tW47YLxg69UwRjNnnG6bKnRS8hYpMwOzgbTwAGEBIehZpVOvv1VIa+SjZ5cHInswoan95onzdJ6/3t0ORH8bU/aOIK9Luh9KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551495; c=relaxed/simple;
	bh=MTRURvPdCaGw1SzKYIEJd4aMu3SbT+4LvovSrEpU9A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBkPeue4fL29UoraKNdS+BYDWXd1Aam2hBSuR9gfZpkah4fuMT3LKNYDOrvl6Bg5Gs5yjlJD61VEMvip8yAvpgJ9TKRDF6rhcXgpnxL87A736v8GZ30cyp3I23ELp1dfHJ7Qxvs6uh4ok+pshFNhq9zPJb0zpCgEcUfmLEnhrM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ewOf0PdO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gqfw7Tdh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ewOf0PdO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gqfw7Tdh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AF60D6024E; Thu,  3 Jul 2025 16:04:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751551491;
	bh=IYUtIzg+K2r9jdkDbpfhtSu687Zoov2RJvqSsYr7dvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewOf0PdO8WA0Ot6nj4mtHIBzNCwYx1bvYN086zBj0vjZO4nC7yfcpvtT+kX2T8237
	 ZpepOaPQCMwMT/j2qq5qW/cCpNykZdRmryFzEaGzqRT9W3MfGoLwoQ0MvHA969tTX7
	 u2VOv+OnJ7Z6fWuo0Gqx54Y51M0emNiOfSqiy23JvlHyuKrfdUd1vIxVxmAzHW/Vyb
	 7znLu6+5tjghY4bH89LrII5EjGzQpENKOADhEympYekS68zYeBrb/fBIquIlwAfSuv
	 i4IzpbIhuQWRjFEdBzH2J/Rrhk+sOmZ03nIrXAXe7ctb14XLdgcaX8/6LyDrdSPgzF
	 Vpb705GX5Z/ag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D07CF6024E;
	Thu,  3 Jul 2025 16:04:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751551490;
	bh=IYUtIzg+K2r9jdkDbpfhtSu687Zoov2RJvqSsYr7dvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqfw7TdhrJV0tQ6HGlWx+xz71e/kZexCYyR63kBLSfeY/9gxqnCqG9Xdra/nta/ST
	 dTwT6uckdzh9x6eNGPpC0MpcOnpdupGpbP6plc7NBOxCQ9hp3WC+g8qLvUrmvPBOBv
	 jap/EvN1wXJMzP3HQpVOuo6XgdXdJsOWy3tvxi5fhjGmx0UKIKYJsI3ErNfPP4HN3r
	 M0uNgFMO/kcgDGu9Vl98jkdecN4mIm/kaMe0IsVqXZ8jx9xEJT5zc/lALRhiMjb3om
	 95GC8tXwvAgbNZCeqDGU6JZqquYJKFzI8Zy6LTUBpnH8cFvA54GXojVSboAWVv2Hl/
	 Os7FQ74eWSI2Q==
Date: Thu, 3 Jul 2025 16:04:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH nft] tests: py: correct the py utils path in the source
 tree
Message-ID: <aGaN_9hnyR9AdOdT@calendula>
References: <20250703135836.13803-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250703135836.13803-1-dzq.aishenghu0@gmail.com>

What does it break here? Provide more info.

On Thu, Jul 03, 2025 at 01:58:36PM +0000, Zhongqiu Duan wrote:
> Fixes: ce443afc2145 ("py: move package source into src directory")
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> ---
>  tests/py/nft-test.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index c7e55b0c3241..984f2b937a07 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -23,7 +23,7 @@ import traceback
>  import tempfile
>  
>  TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
> -sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
> +sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/src'))
>  os.environ['TZ'] = 'UTC-2'
>  
>  from nftables import Nftables
> -- 
> 2.43.0
> 
