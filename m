Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D7F3081DC
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 23:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471159; cv=none; b=YE4R8eFb0P4N6WdL9y8DvQhb3BntpFTpLO+zbUV9fMWcdmNC8hJAibqY/oRf0qpW0FNp4tEu8rniVnF0ZTGWnwjosjumDXScVHIkUMaXKcoc26q/P7mprFdRLavUmGJ9cnHklvMMqRu52IbpEgaL001vTZwMJUrtdFuOkOVbd3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471159; c=relaxed/simple;
	bh=maMIdU7N0GegRrowO2iV8ULBCJYVKhiLGQRkDb9SZ+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Or5HUwYCXG/Cr0jX4x/hpp6YIB+b9RSLnazIEkm0+2fUYhE+eDOO0Y+YBgDtHJVqr/WVIeYUBT4qxGCefMN1QkkI/gy7ylIN5ytN94S3cKvPd77lWcXQVeIXC7SHHrz55664A3rQoTn976F1QyN9E6HUNe0RZJXivefu0x6dlrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7A9E860298; Fri,  7 Nov 2025 00:19:15 +0100 (CET)
Date: Fri, 7 Nov 2025 00:19:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: libnftables-json: Describe RULESET object
Message-ID: <aQ0s80YeCLRZnmsB@strlen.de>
References: <20251106111717.9609-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106111717.9609-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Document the syntax of this meta-object used by "list" and "flush"
> commands only.
 
> 872f373dc50f7 ("doc: Add JSON schema documentation")

Why is that here?  Should this have been 'Fixes: '?

Aside from that, just apply this, thanks.
