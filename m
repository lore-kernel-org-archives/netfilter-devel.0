Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A3A1DD0D4;
	Fri, 14 Nov 2025 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132310; cv=none; b=lrAEb7er+Zr4/jfFo1E+SVPx4dSKdEY7lEOqdN86M9HCu4pbwXavqA5+HTwMJa3239gxD76cWGjeiZZgetCS15N1F48Oq18012c2W9hzdAIcD9sBz5+awMXzpbFEf++Rm5wQUpdzOLskvesVFklJLSriScudKBc/pcmdLM1nAfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132310; c=relaxed/simple;
	bh=YNngpTORlqLBS9xGNNu7NrB5Jq1paGOHBN82tODRVJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5pqq9pW5e0hz8JkDJJF2nYPm9WKkBSBZNRT8o4FhObkOXqmhuTRJKT0inwpJ2EqbYnmdnJSIESq8HllfEx1kOyRc+BfPZrbhECpSUDhQvKq/k1NFtgOd7ZySgW1dpPcx6jDg8m0Duo6Sbkp2z7zE/0WVKfNPeV9dXUL7Pk9g/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JESR+plj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JESR+plj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0338AC116B1;
	Fri, 14 Nov 2025 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763132310;
	bh=YNngpTORlqLBS9xGNNu7NrB5Jq1paGOHBN82tODRVJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JESR+pljmPIVWyEWTejUd0ZaokR/xwAw39F1Wp0q0XwuIUIwI15sYKVEuNSkr2Pcq
	 AdO1hIkX55IiA4USjGItTOX9LuN9PtwZhMhsIHrKf/Bpc0PP5CLMtAOulY9wL/Jz/j
	 SLrs3O+6Jc2OFettpq5lZzdJB60a0SVIlMZB6WsnIq+DPzKD4sr0C8KEdRHFoStrkI
	 tyx/KCuunCI+patyOMS2NyLwJUF21MDTBrOSkq20GaWWVKbK6++KnhCU44orr2INjH
	 cM6HLxaZjYRVV1VZu5WVBmRwNCGHDXunKlduEFA3xJCOHiEvKbLnzrN44nIP+p+uwA
	 30qHbU92u3PXg==
Date: Fri, 14 Nov 2025 09:58:28 -0500
From: Sasha Levin <sashal@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [6.17 stable request] netfilter: nft_ct: add seqadj extension
 for natted connections
Message-ID: <aRdDlJ0WIxLcGYKL@laps>
References: <aRc14x3YHACREzS5@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aRc14x3YHACREzS5@strlen.de>

On Fri, Nov 14, 2025 at 03:00:03PM +0100, Florian Westphal wrote:
>Hello Greg, hello Sasha,
>
>Could you please queue up
>90918e3b6404 ("netfilter: nft_ct: add seqadj extension for natted connections")
>
>for 6.17?
>
>As-is some more esoteric configurations may not work and provide warning
>splat:
> Missing nfct_seqadj_ext_add() setup call
> WARNING: .. at net/netfilter/nf_conntrack_seqadj.c:41 ... [nf_conntrack]
>
>etc.
>
>I don't think this fix has risks and I'm not aware of any dependencies.
>
>Thanks for maintaining the stable trees!

I'll queue it up, thanks!

-- 
Thanks,
Sasha
