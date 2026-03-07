Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E62355F47
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772908455; cv=none; b=Ekj8zUsDisRJUaiQCRABSYztIFKF60aOxIpidRZeTGje/UNjibeBq5t616fYtQuZUgGk9lB0f3UUbRvVA7xvXhWWgUWuSIkm4JNX0DM9mIOsCkVkfeh1emw0mSjWD62BiO7NOO4Atyt8bBjffHWliMO6jpgxJkEEcq3o15GvWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772908455; c=relaxed/simple;
	bh=3jIOgTLFYrIKXBL28OEeR8JdjeU3+sJZRUV8YJa5Xp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDZdSRkq18YUw0yFG2yaOHjgwp/2wtQqmM/SSzjnEuawp6f7+6uijcHq0ji/MhtotMZnwyIiOrYP030O1a6Sz8x0oxdJ+fJVZOFgmf3hRgb1bcB+x+XSZu0xnDMTP/16pWeiTKNlHA+BjdBNSrPlMEH24ryyXLrkV7JgpPVYWsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 71DDF6077F; Sat, 07 Mar 2026 19:34:11 +0100 (CET)
Date: Sat, 7 Mar 2026 19:34:10 +0100
From: Florian Westphal <fw@strlen.de>
To: David Dull <monderasdor@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: guard option walkers against 1-byte tail reads
Message-ID: <aaxvov0E_yR6SvcJ@strlen.de>
References: <20260307182621.1315-1-monderasdor@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307182621.1315-1-monderasdor@gmail.com>

David Dull <monderasdor@gmail.com> wrote:
> When the last byte of options is a non-single-byte option kind, walkers
> that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
> of the option area.
> 
> Add an explicit i == optlen - 1 check before dereferencing op[i + 1]
> in xt_tcpudp and xt_dccp option walkers.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
