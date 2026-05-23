Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB1233939
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 07:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779521197; cv=none; b=FPLl3R6UEwo9xBNMJZbodCm1mVe67H61nA1OIXp4FbZCkkb47PyxOTIChelrlBdXA52NzLUa9E8W2mc5u2vVnmnupRu7aUQXA4WAben5bXJsigpkiVDG/r028mhPKRIcx2gk5ZUWILlQxxHZrEsXFmjbP5pRyp4nfRCt6e6P4oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779521197; c=relaxed/simple;
	bh=5bu6o5NIKJxFJyJ0ciB8SUaYwZdk+ZFWoAhguWTVrUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5Dv5ZILYujI6wmmucUBocXY4qsX783XNf2WGNyD5V5UnuRb7hbHj+AIQkYZo426t+7ftLpr6z92elxfBxQoac2C/RflTk8LeAp1DUi50ktcxpu+c3I+eGjH3rypSTg8FfrNKNIRa3nwbuXM70df/ckpm+v3X+Z6zVtltbVBAkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1AE0A60842; Sat, 23 May 2026 09:26:33 +0200 (CEST)
Date: Sat, 23 May 2026 09:26:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] netfilter: conntrack: remove some code
Message-ID: <ahFWpR_boNDHZUmO@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
 <ahFJGSir1oJ5i7Fb@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahFJGSir1oJ5i7Fb@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I have been working this week on fixing the helper infrastructure as I
> told you, my series is directly clashing with this.
> It's is taking me a bit of time to make sure to validate this is
> correct but I can hopefully post it asap.

No need to rush, this one needs a new revision anyway.  I will wait
until your series is applied before doing a v2.

If you like you can integrate the last patch of this series (irc/pptp
deprecation) into yours, that patch isn' strictly related to the
others.
