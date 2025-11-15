Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40CE1C3BEB
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2025 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763207371; cv=none; b=CzwElZa7wkg9g3/lUqgeGwTgePS8jm4xu6TqHX3acVTo86bnSMVkcScPEdTdFJgKZVCNqShyi8KM70hez11GYfeTrz9SCqm/avq/tWx1AnUe/wv+riUNWV009kjJ/jgSunGT7rsSvg4JiLQ7NrytuOxjSxRUmwButUumF8SYOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763207371; c=relaxed/simple;
	bh=wiugPf1CU1O5uoB1XL1yYfFLWJg3cLK9vhE48fcO8Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhCFlKsCzBZ31ooZXhMje+tXlKjEjawfk2+ugRUYNFl9ed4RP4XSCCITJOUHgKSLwxP4uYolZo/NdUwdYJpO42RWE/ziCog1ZTkvKbnbhF69cqu1IbUZv7QK/Rat7Up5WSxb7o6f2rovmLlyx5PDiYBmj47LEz0lJ6LWbgr1334=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 49624604CF; Sat, 15 Nov 2025 12:49:25 +0100 (CET)
Date: Sat, 15 Nov 2025 12:49:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <aRhotOKf6VjOWX2f@strlen.de>
References: <20251114210109.1825562-1-jeremy@azazel.net>
 <20251114213718.GB269079@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114213718.GB269079@celephais.dreamlands>

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> > Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
> > multiple commands were given, options which were legal for any of the commands
> > were considered legal for all of them.  This allowed one to do things like:
> > 
> > 	# iptables -n -L Z chain
> 
> 	# iptables -n -L -Z chain

Whats wrong with it?

This failed before
192c3a6bc18f ("xshared: Accept an option if any given command allows it"), yes.

Is it still broken?  If yes, what isn't working?
