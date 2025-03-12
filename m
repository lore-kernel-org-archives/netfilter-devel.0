Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FD01E5729
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789015; cv=none; b=hy/9ObePJ3bwfcNVjEVGRchErbR0y6nd2FATDvo5hYqwE6KP4S/vEtiALtzEwUfrKt+wqW3heksFuN8xml3CNXCgwiy1AUOdseSd/zYK4N7e/fCabkZREpYbvGJjvRH1psHFcH6WUvsWK/TJoefXGd/KqdJ5OiWN6c1JTFqzHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789015; c=relaxed/simple;
	bh=EodryovNXC2b4jfpgk9qnN2QLeoJ3+pPGEEQJDccR34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=koYSv0xKhGTY7NLGQTgXDiONMPPr9bQ6mS00zgBw7f8Ke5AMwDG5ZL42nCRXTRShkUNEdzFrwXvg4uSSunXfZLXcPhYx3FucEZGD7q8UAb/fAVAw8OX95Hqbk5aBtMWAXEgA9S+B6suJgP4tMSfWN76sGq04uRCZdNifzVHvBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsMt8-0006ot-DG; Wed, 12 Mar 2025 15:16:50 +0100
Date: Wed, 12 Mar 2025 15:16:50 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Alexey Kashavkin <akashavkin@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Message-ID: <20250312141650.GB17121@breakpoint.cc>
References: <20250301211436.2207-1-akashavkin@gmail.com>
 <20250312091540.GA15366@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312091540.GA15366@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Alexey Kashavkin <akashavkin@gmail.com> wrote:
> > There is an incorrect calculation in the offset variable which causes the nft_skb_copy_to_reg() function to always return -EFAULT. Adding the start variable is redundant. In the __ip_options_compile() function the correct offset is specified when finding the function. There is no need to add the size of the iphdr structure to the offset.
> 
> Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")

Patch is fine,

Reviewed-by: Florian Westphal <fw@strlen.de>
