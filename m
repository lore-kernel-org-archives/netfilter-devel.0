Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90F17A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 00:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770855588; cv=none; b=lBjbp6E8KkFo2B7kSK81BDu85T1CLMejiWBwEq+o8o5D0FFTbE8FTlOe05fjy238b8Q2tX8BKcaQ8DA3U8KDpZRqmFKe5ZZ6Apu7ukMye3ar+y5iYay8KqN1jOlFsj3bE2xBemqRiXjuiVgp3O1NhkPOYXpzm1T6hLK3C6zRoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770855588; c=relaxed/simple;
	bh=notlyEdSO80ElMWgRIuy6Q/GTCc6hcvSp7GxWKgwZL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpHNfVL+DTgC3c0oFs8zJ8RYK5UavSWxCrn1sOWzmIJaMrQPZXgofM7NwKTJRFNP5W8PU1tTOQO8ax5z80JkGWwhkBJ0+QVy42KADUAJk5SjWEERdg93GlM3SrhVDwnFUkE0WfL4TZZoaPerxL31qnMms29gfh6UVM8/T07lkKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DDFCE60186; Thu, 12 Feb 2026 01:19:45 +0100 (CET)
Date: Thu, 12 Feb 2026 01:19:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3] configure: Implement --enable-profiling option
Message-ID: <aY0coRhtrFsJTOBv@strlen.de>
References: <20260211201503.27186-1-phil@nwl.cc>
 <aY0Z63yPjQoXYp9b@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY0Z63yPjQoXYp9b@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Sorry, I did not think of this earlier.  If I'm wrong and this is safe,

Grrr, this was supposed to go on with:
"... then please just push this out."
