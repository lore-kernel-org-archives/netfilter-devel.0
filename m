Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06952128816
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760794538; cv=none; b=QYWRPJZyZXnABr6SrYH0Fp550u3TCTPm+X7W6Lk9LDh/YuO1G+Ul3mCrkv1dd0UXc85oKkRVMaYw71UtcUqCwRcRFiFNhimWNJ7ZQhWXho5mw43eTxsi5ztYy25+Dbet0ICgeAn7moG4sj5IoAiLs8NAloQVCwnVwalyW8hehM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760794538; c=relaxed/simple;
	bh=l49rS7MTZt8xEEvS0d7YBCHfuTM2lKUxxKboeJuDe+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8wf4GthQto/+ZM2n3BdHUF4BnzLyooziLfHHiVyFnORc4r3sd7CdkaJ8MZ/KqhrKr6BRfo5r1aODOqapGz/TrKUPTrb5Wgk5Zrh6C/s+UFfSxbKpw9tImJKE8wriBJ1EikddUggyad/0DqVJvKbPLe9F69ypyhKbv64A+3ZqPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2A36160329; Sat, 18 Oct 2025 15:35:30 +0200 (CEST)
Date: Sat, 18 Oct 2025 15:35:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 6/7] doc: =?utf-8?Q?describe?=
 =?utf-8?B?IGluY2x1ZGXigJlz?= collation order to be that of the C locale
Message-ID: <aPOXob5BUPRLIjjH@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-7-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011002928.262644-7-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> Currently, `nft` doesn’t call `setlocale(3)` and thus `glob(3)` uses the `C`
> locale.
> 
> Document this as it’s possibly relevant to the ordering of included rules.
> 
> This also makes the collation order “official” so any future localisation would
> need to adhere to that.

Pablo, whats your take on this?
I wonder if libnftables should force POSIX locale.

