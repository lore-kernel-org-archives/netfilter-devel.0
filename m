Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519F818E372
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724146439; cv=none; b=EXXBli1BNRIptes0bM5SXeSHen1VjWAZVzy9NlbxTytuLJleD3PjrD5Ihc58M14LgQOR2yieUHJAluQew6CPUXsI8bVQh2y9ImgMt5AaoFwoInp+VeFML9JXzeKZ0t7p9rhG4u9t8ZvGBog8ZXUr8WiXVs8ksLUvivjLhql4hcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724146439; c=relaxed/simple;
	bh=G/6TGpEXVElPbOHIJebCaexquSxKueIbb0xkXXg+5G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sScU0pbFoQum1BvDMqejuiVZwQZz1KXdX/apm1jOZSTzYEARuyb2hrG82Upt9I9+vn79eS5RyNZkIoymEOvrci70n+FN7b6xogd5qGl3ioTC3I0XltmcyQez1pOTVnChUgimjFCF4ggAn45al+xkTH/rbW+xzSqr2oWKDMiWLDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sgLFR-00042G-FL; Tue, 20 Aug 2024 11:33:53 +0200
Date: Tue, 20 Aug 2024 11:33:53 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: Update outdated info
Message-ID: <20240820093353.GB12657@breakpoint.cc>
References: <tencent_E5B5CB5FC9F34CBBC4CF5CA0176D764FBD06@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_E5B5CB5FC9F34CBBC4CF5CA0176D764FBD06@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

谢致邦 (XIE Zhibang) <Yeking@Red54.com> wrote:
> inet family supports route type.
> unicast pkttype changed to host pkttype.

Indeed. Applied, thanks!
