Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BB5231A21
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773664528; cv=none; b=XHqPsGC/mgoVOkcu4XGoQa02GWY3YnE1yjRlB5XE5G2lv41TVC5FXF8sk0TizyNpFI8BpIDcsBfqZ59+A8hDAuW5Ncn6O0ysFtUdcAGazhRlW/jxj6T7kWj1suebr5J+L1qxCJNVVXX0XPQ4LRJyt5iA7IBNH9JEyYACFrZi+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773664528; c=relaxed/simple;
	bh=rYcPnuGJLZoJM9iqurdTr1VzlsrVSAvzak732A7Phbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC2s187DREhn6yv0E49VdWVzNlixGrpirH59X/XdTXckEbQ1NiZQrpL55J3sh+iOBNdDq0Wib7BcXWQzQvDih2/px3Fpm9iUwHw/L7oNzvh9k+c+oB9+evU7XtyI0BN8B0lEYqjLoOuIG+CXUjKdU3VYeMvLdSsodsgCYjM2Vrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8909D605C3; Mon, 16 Mar 2026 13:35:24 +0100 (CET)
Date: Mon, 16 Mar 2026 13:35:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, carges@cloudflare.com
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <abf5DO7J4xXEb1qZ@strlen.de>
References: <20260316114835.3834812-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316114835.3834812-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Chris Arges reports high memory consumption with thousands of
> containers, this patch revisits the array allocation logic.
> 
> Start by 1024 slots in the array (which takes 16 Kbytes initially on
> x86_64), and expand it by x1.5.

Do you think it makese sense to start with set->size for anonymous sets?
I suspect most anon sets are pretty small, 16kb / rule is a lot.

No need to send a v3, this could be done in a followup patch.
