Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FA93876C6;
	Mon,  7 Sep 2026 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770005; cv=none; b=hJusBPxn1Cji+0pA0RpBzwtOXNwmMlsvjqAbFJ8bxPTXSwvKhHqNbtRUq4auF55LzEDpLZVBgb+COBdPs0mEJubqgAsPzUJecvqk3RsZHH2vXRbKSfwbEGVZxmd8IUCZTtPJXSdEi6e4xuQB7R+Gjyby/ZKjLX3Y/VCWvD5wARU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770005; c=relaxed/simple;
	bh=G0Ls6hGpgkBcrO/SpGc9Cz1kboCdluvHoiOH1nVxegE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rISbSb+j49UTqO/KWSbMI5UB62kVLYcmJOn2I24RgxVPU01nXmwgwqBTKsk+VanY0aKf3GvqKJOnN3yxDIojIyM8vUw6L02gkPo1AoU+yeZ8vO0CVFdwQJ5yGaVEJ6mdLkFImjmCj16BQ1ENOb8rMj9Q7cIHxt+bZ7znxrClNW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C078460544; Mon, 07 Sep 2026 10:33:20 +0200 (CEST)
Date: Mon, 7 Sep 2026 10:33:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Message-ID: <ap520Gf4XawDWeaX@strlen.de>
References: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

Aamir Ahmed <elb12345@hotmail.co.uk> wrote:
> amanda_help() uses simple_strtoul() to parse the port number from
> Amanda CONNECT replies, passing the result directly through htons()
> into a __be16.  simple_strtoul() returns unsigned long, so values
> above 65535 are silently truncated by the implicit conversion to u16
> inside htons().
> 
> The existing check "port == 0 || len > 5" is insufficient: it
> catches values that truncate to zero (e.g. 65536) and strings longer
> than 5 digits, but misses values 65537-99999 whose u16 truncation is
> non-zero.  For example, port 65537 becomes port 1, creating a
> conntrack expectation for an unintended port.
> 
> Parse into an unsigned long and explicitly reject values above 65535
> before the htons() conversion, mirroring the pattern used by the FTP
> helper's get_port() and the recent IPVS FTP fix (commit
> e625a9477d12).

Is amanda still a thing?  Maybe time to retire this helper?
