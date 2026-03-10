Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B423859D5
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164244; cv=none; b=lMj9E0+4XyvehVJT1DxLiFiRvDlOwwWQYqepJYScRRENkFI+Sb5c0E22aSbk1KREbzHzUnsXK+TKZZcT7uAjNcS9eV7RQnVt8YQMHDw8LwwIUUD1JQEKJ5L14c4onZYFO8W4NYz/enExswraLCUInyqYkiOURO3u5+jZRb9sAu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164244; c=relaxed/simple;
	bh=ti0Ho/MECAHrhwSyprKlZbOGzXxq4wXFOETI6SBoIiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBp4ZwoeV00JWTBNibInjFlgdzAEVVMWjDGXpp44vqFu6WMnFABp5KljmOAF/prPAL3tNW3bZjZKvdhBKNYNo/SPNOaSqVZZSasLuUQPUUd07LFWjYjEiKfbQgUTt53q5FFf9q97IC+sprNFQgHNdTfZOLNQxcW1LzK2vEB5c1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2FDD560516; Tue, 10 Mar 2026 18:37:14 +0100 (CET)
Date: Tue, 10 Mar 2026 18:37:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xtables-translate: Return non-zero if
 translation fails
Message-ID: <abBWyuHDm7MT9JC3@strlen.de>
References: <20260310171853.26362-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310171853.26362-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Untranslated parts in output are easily overlooked and also don't disrupt
> piping into nft (which is a bad idea to begin with), so make a little
> noise if things go sideways:

Makes sense to me.

Acked-by: Florian Westphal <fw@strlen.de>
