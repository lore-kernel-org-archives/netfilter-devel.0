Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83733332EAD
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761669239; cv=none; b=sHidqgUGnRjC6v1AdN/mO4YbPUoGXR8aq5o6grnbwvHTbL4JqrdEIF74VJl+BGSPAvW2zQBeNKg1ks4KoYEIxwM69tCKIB4tjy1+pLnrDZuFzS5wM4zupk/nJinrHoGIsARFpIKv6IVTLvuV5sWKF0SHcHPkBg/nd3bKNHyg48M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761669239; c=relaxed/simple;
	bh=YL2cOHSMT9ZF+Z7Uoa8rR7j9OkFuEbFRqeBce6j6buU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdmExpCv914VaUj7vXbc6IMxTYMg9MEVD4l6Y5CkBoBr+ISz2BFtOKK2BO03+96S8b0JzuA/zqfWEDTqtNfFiHGKY5CkuRdrq2l+GU3VesSrUC+r+Q7UWhyAfZYgp6tA9zjD6XpotGy04+/S5M1C9Qdl8m3n7q+p922qbF77FOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4E0706031F; Tue, 28 Oct 2025 17:33:54 +0100 (CET)
Date: Tue, 28 Oct 2025 17:33:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: Re: [PATCH 0/8] improve systemd service
Message-ID: <aQDwcsK0RKsrtVop@strlen.de>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:

[ CC Jan ]

> This is a first series of patches that tries to improve the included
> `nftables.service`.

Sir, this is netfilter-devel and not nftables-systemd-devel@.

> It contains the (hopefully) less controversial stuff I’d like to do. O:-)
> 
> The main idea is to make things more hardened as it should be for loading
> firewall rules.

I have no horse in this race but I don't want to have too many changes
to this thing.

I see Jans original service file) as convinience / ease-of-use contribution
not as something that should be maintained continuously.

As for your series:

Its waaaay to many tiny patches.  The first 4 patches could easily be
squashed into one without making it hard to review.

As for flush-on-shutdown: I see no need for that either.  Jan?

FTR, this is about:
https://patchwork.ozlabs.org/series/479245/mbox/
