Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727F71EA73
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753120691; cv=none; b=iRMaEMNrDP7ie3aZL1TNlk4CJIgYdAnXtS+IV0gd052WRr9qw82QCb1GmjvN5JZzUg6Xtg2BXYBb0F9zK9slE9nCIvqGt5hsHgE3HkQgIFcGw3AP2KoWn8ZVgZQbMnOrP3yh8AEz89uHwgl/MSoyd7DjPd6cAoWJXgqwSw9OSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753120691; c=relaxed/simple;
	bh=UB+GXOX/4S/Cb5EPWCjjKV0CFnQWyhJULAm5i2LcGHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k507RFVmoVFlHdrGHr/RRvh5LZna4/skyPO/DwdmnXGcQV5JTIGNwyre0cN2PVtc476703mTqgOrh5pvT+s/Ih0EIV2yXsbgJhG/ajvfnbLodqD/snLxAlZMHIIByO0qU4DWYW6g2qXbsv2W2nvYnGaSNR1crDDdvltzl5sbc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BCCF86032B; Mon, 21 Jul 2025 19:58:01 +0200 (CEST)
Date: Mon, 21 Jul 2025 19:57:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Promote xtopt_esize_by_type() as
 xtopt_psize getter
Message-ID: <aH5_pGe_3_OQO6YH@strlen.de>
References: <20250718160032.30444-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718160032.30444-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Apart from supporting range-types, this getter is convenient to sanitize
> array out of bounds access. Use it in xtables_option_metavalidate() to
> simplify the code a bit.

Reviewed-by: Florian Westphal <fw@strlen.de>
