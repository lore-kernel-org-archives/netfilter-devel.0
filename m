Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A711A2C0F
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723578824; cv=none; b=Ik3F0I7LGuD7kg/NvixfsNJgjaHr04Pk4CMN95DefU+XpBlbE4uqJ9NvKAgqF6sNmIwgeq7eWI+miwzDg3FrXguzS5aQfrNCAa9i8X27rgM5RmNCysd1r0xEnYo+g8gjgyOyGJmjqFb1YbjbwDwt/kV0xkibtMmFMvJI3QJF5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723578824; c=relaxed/simple;
	bh=6Jc+3AFThpGfIqBc/e6M4aWEXq/AGv42Wv1aelH4L6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMzrQlfRbE0X4xgWcRiZw0LHGuQQiDNBUlt11fkcpmZqSb4Ic/eF9L4+sqg4mNodGCbfcLNhbKAKO3f2g0S44LvIhpXgh3/Qi6R1cX7VjTfsUiQT0FZOx3WDpViMrAevFyNcQY6/KTr7/7VMfcSwJTprxa99jIMAcy4ficwpkoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sdxaN-0004Wr-CR; Tue, 13 Aug 2024 21:53:39 +0200
Date: Tue, 13 Aug 2024 21:53:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Extend table persist flag test a bit
Message-ID: <20240813195339.GB15353@breakpoint.cc>
References: <20240813193611.14529-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813193611.14529-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Using a co-process, assert owner flag is effective.

Thanks, please just push it out.
