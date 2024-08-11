Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E31757D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Aug 2024 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723377192; cv=none; b=r6CjdNz8c6M6zC1XzaYrVdOvwQqsXS6oHneuB33gR2zZXEImycXU1EjlT/YXDzQ1QHV1I1J3Xst4jsGAyd7pJXaDIyFqHzQrKyGsy6gQohjzNZmSfoNfrWwFjq5ks9gefcrI+NfEHz4WDjl4FwtORW0pmtfeleabsi/ke4xANLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723377192; c=relaxed/simple;
	bh=QXG2ZGooxPQb8BMvM0UNDhHGun1iKJIzWEkGQQIYPTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDcu6bNA4Bv5BCIi1elCumRm4f2N0nJOmjJS80U4rlRIb0+FroQO5X77Jxpm26kgliF+zczRiw9Sazb97m7ZJVtGeDaDOiW9TSIdwyvkHD9kazQuNxjLGJNz8CyoWDQIETG30XiYgMFgp5RyF92zRcTqcmvwIzlkkQmrtTN+ieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sd78F-0004Cb-Ln; Sun, 11 Aug 2024 13:53:07 +0200
Date: Sun, 11 Aug 2024 13:53:07 +0200
From: Florian Westphal <fw@strlen.de>
To: chayleaf <chayleaf-git@pavluk.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] set: export nftnl_set_clone
Message-ID: <20240811115307.GA13736@breakpoint.cc>
References: <20240810190605.1215981-1-chayleaf-git@pavluk.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240810190605.1215981-1-chayleaf-git@pavluk.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

chayleaf <chayleaf-git@pavluk.org> wrote:
> This is present in libnftnl/set.h, so this has to either be exported or
> removed from the header.

Please remove both nftnl_set_clone and nftnl_set_elem_clone, these are
not used anymore, its dead code.
