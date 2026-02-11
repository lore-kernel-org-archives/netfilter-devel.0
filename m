Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EAB242D83
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770839940; cv=none; b=ifskIH8+yJn39B368Sew4w9cBjcqMy7t0YIJr1TAzLFAUvIEiObj7HtAQXvAoouFhj654a8iTmYvu5PS2kciPM//QDiXnYQNH08hhYogCN/USIGi7+suYsIKlSvptNR/NdG7APqYLK/0n1R4e1A3D3mv0SNaWyQ0xHcBHwFhOac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770839940; c=relaxed/simple;
	bh=Y2RHCGYfylBmMmSg6fgYopKpBlKk1MNaqc45+48O3pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmOVGt8MVXvYVXFMX7bTpAHj84oSFAzNZjbUMv1NJjvqumHZkie9pPW3Vu8Wkv0BBWOduKiKxdf4SjcqenLG1afpzJtYGwopC5WKvv3c+plE0acJtSu144bPWgSHd9kCpBHYCw+LijXtqIWkhADvIEJqC3HM0QVP0i/ceXzehF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 98713605E7; Wed, 11 Feb 2026 20:58:57 +0100 (CET)
Date: Wed, 11 Feb 2026 20:58:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>
Subject: Re: [ebtables PATCH] useful_functions: Fix for buffer overflow in
 parse_ip6_mask()
Message-ID: <aYzfgfEVjenfc_9v@strlen.de>
References: <20260211194203.6383-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211194203.6383-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> This patch contains a simplified version of his fix:
> 
> - The original code attempted to div_round_up() for the second memset(),
>   to zero the fully empty mask bytes. It used the term '(bits / 8) + 1'
>   which misbehaves if bits is equal to 8.
> 
> - Addressing p at offset 'bits / 8' is illegal if bits has the legal max
>   value of 128. Also, zeroing this byte is needed only if bits is not
>   divisible by 8.

Thanks, feel free to push this out.
