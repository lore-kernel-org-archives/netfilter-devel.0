Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9492EA16F
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552781; cv=none; b=Xj3RW3JGpR29MDviGoTJkzGoxHa+GsVFjgwr/3FuHmsWh6OEO0i5Ji0ICbFj4a2/HJxmWpNxyiA7WvMhN/2JItdjZrtfGHFTb6SBm1t0DzyYdtT1jpgEKs09tVpbnMv4u/0WyQAhWKUR5sVhGABZJE8CgZLqqCzDsZe/IIdX6zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552781; c=relaxed/simple;
	bh=tsRK79dktGBVRTtbymkitKNPmF/mrBrhHyAMP2iVCWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMLeOlu9fv0NWg7iP8ZjKazCZqQWuhhHq1JqBUpLbyzkU0v4KZQGgwvpg2+Dj6/WA+T9IElmzLYjmXNon6MfzcJEw10O7S41PFNN1aotQIObTu6XgA1/7Rw/2CgYbRHxWH3capfMRvQp8k345zXFGJWKgh2xBbNJXjJJy8WcNOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HtYbP1kE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HtYbP1kE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WkJcPQduuWpYZVskxwY218SesY3odcd2w9UyIDcF8Y0=; b=HtYbP1kEOugZ7Mhof84Lg2tpkN
	fuPW051JxD7TMMxvfGsHTT821UI6ephZCmgB5gHCbCqbTkT7SGeiOAvYSq8yKhW9ESbyPi49KIxpR
	bC2aGRBeL7f4wHzBCzWg3PWIfbNv+9zhfsorLXX309RBSe8OdDYYlI+3a1FYmx/0R/DcpW7CWCPfu
	c05hAz5WzZW+XuElEI/Fli/AKYIaVgEMbwWadXdxYdCZhGITxY9pNejzRQqtm6rScY0GgRyNS3iUg
	jia+gxhtxbuHwglAms87DMp/vvpzKflVSbrvLGbIJL8oH9GPVcyayIKTHkCQuwhfp7WVVr1UZWSXH
	f7ZTG5vw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXKtC-000000001Gs-0WNz;
	Thu, 03 Jul 2025 16:26:14 +0200
Date: Thu, 3 Jul 2025 16:26:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH nft] tests: py: correct the py utils path in the source
 tree
Message-ID: <aGaTBm2-wSvSySEN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>
References: <20250703135836.13803-1-dzq.aishenghu0@gmail.com>
 <aGaN_9hnyR9AdOdT@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGaN_9hnyR9AdOdT@calendula>

Hi,

On Thu, Jul 03, 2025 at 04:04:47PM +0200, Pablo Neira Ayuso wrote:
> What does it break here? Provide more info.
> 
> On Thu, Jul 03, 2025 at 01:58:36PM +0000, Zhongqiu Duan wrote:
> > Fixes: ce443afc2145 ("py: move package source into src directory")
> > Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> > ---
> >  tests/py/nft-test.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index c7e55b0c3241..984f2b937a07 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -23,7 +23,7 @@ import traceback
> >  import tempfile
> >  
> >  TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
> > -sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
> > +sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/src'))
> >  os.environ['TZ'] = 'UTC-2'
> >  
> >  from nftables import Nftables

This is a needed follow-up of commit ce443afc21455 ("py: move
package source into src directory") from 2023. Since that change,
nft-test.py started using the host's nftables.py instead of the local
one. But since nft-test.py passes the local src/.libs/libnftables.so.1
as parameter when instantiating the Nftables class, we did nevertheless
use the local libnftables.

Duan Zhongqiu, could you please point out that it re-enables nft-test.py
to load the right nftables.py module in the description? Also, please
add:

Fixes: ce443afc21455 ("py: move package source into src directory")
Reviewed-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
