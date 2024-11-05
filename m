Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C053365
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844121; cv=none; b=LQiSoXWAQoZD4bNLIgZQhKHyecglvMMsJ4IQHJzacE175fywQmmwfAw2UM0ny0mzjkkWGtPhO27Zcw2HnY+zEMHF6W5d24h5JQSvJUytvASMTLRB1eJWVTJW5rvVWgwaqd2caZA+bi8JJWuocXqvr3SvbR1FRJYOOSZZ6UxjlHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844121; c=relaxed/simple;
	bh=Vewkyr6TrjtXY14dOAGavO3GGdwWQajI+MOKPr2JW4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTqxZA7XTVnCDut2Opo9kKyCUUP2NBj69kIDQd0ntdxAkZXYuwdyxiV2WMBI9t/oewVFR1BXj9gknJJmtgx44Y68secudCyh3G7h8oO4aXfVYGcU9zM7p1UvRC3vP8Tn9aOuzAmUDtAX9+iayzpUXR1A3oWzjDgjihV2edGs3fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8Rca-0004fX-Ce; Tue, 05 Nov 2024 23:01:56 +0100
Date: Tue, 5 Nov 2024 23:01:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] src: Eliminate warnings with
 -Wcalloc-transposed-args
Message-ID: <20241105220156.GC10152@breakpoint.cc>
References: <20241105215450.6122-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105215450.6122-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> calloc() expects the number of elements in the first parameter, not the
> second. Swap them and while at it drop one pointless cast (the function
> returns a void pointer anyway).

Acked-by: Florian Westphal <fw@strlen.de>
