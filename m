Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E319F127
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738073313; cv=none; b=Lep+L7CfAXVrh7m66V9vfYjkHAXCqgUoDD/iC7ha2MPFz1khlRaVfOALfMScmrA+mnCGWiRUnh6+JzFytbcnLupAyXfSSkUDaJ+xMFL6sYdm6JznRneLZmD+gqbRKjjsMbQ8v1G+xnzm4rXX1cXP/DZqL6UrJ5BnsqZodPflXR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738073313; c=relaxed/simple;
	bh=2YjtTbihtgIgB53vYhD/Ss7/mpx4OPhMKOT++Ib4jb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzEmJeTwNcOEE9aRZBVFCmdpLf5qoPHewND40ZvwQhVn/a58fbMP+5xJawJPCXlgHttaTK+oaB7jn/uoD2EkNaLZOVR3KetTx8CCJFR912NFsfSHSm5k3dvgxWRQ9k48UkN+oX+bZ820p8fXTyi/vnDQ1alji0v7ldJHUy9tJkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tcmGS-0004C8-AH; Tue, 28 Jan 2025 15:08:28 +0100
Date: Tue, 28 Jan 2025 15:08:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: reject mismatching sum of
 field_len with set key length
Message-ID: <20250128140828.GA15027@breakpoint.cc>
References: <20250128122021.2104-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128122021.2104-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The field length description provides the length of each separated key
> field in the concatenation, each field gets rounded up to 32-bits to
> calculate the pipapo rule width from pipapo_init(). The set key length
> provides the total size of the key aligned to 32-bits.
> 
> Register-based arithmetics still allows for combining mismatching set
> key length and field length description, eg. set key length 10 and field
> description [ 5, 4 ] leading to pipapo width of 12.

Thanks for explaining, makes sense to me.

Reviewed-by: Florian Westphal <fw@strlen.de>
