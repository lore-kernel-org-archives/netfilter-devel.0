Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793504502F
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759233120; cv=none; b=f4/3gHKeSsQqffw/HzT0waQ5rKlDAfWAEadGX0FH3J7m9L5tsm3hTtHrl5drAbykfs7kz9cNhqA+IoFP/X4QdX2VKaPw7l593tgyGYFdl0AxoMTXpJXdlOzOwegRXIBlQdBpkPMNgVGaSXUfIW4BHQ8DXcJ6otnCmy+Mr2uNRzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759233120; c=relaxed/simple;
	bh=VhHXBF+IOF6pnmlWuHzip0za0Kyd9gWoOZz/7yfx5DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxH+syyme/2ZJgGIaVsEf6jdjBpAHUXhC24CDsTF8MiICFWn9mTUsQTJ+MOs3ga4067qtTosqTE3vblvIUIFoqgH8Tj2T03u/srqhs209avgjgas3qvU9KGIGcZUXNNQHsp3KbhZu8zFUD0tF1E7ilzL1tEg2hsAd56Vz3BFnTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9045B60326; Tue, 30 Sep 2025 13:51:56 +0200 (CEST)
Date: Tue, 30 Sep 2025 13:51:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/7] doc: add some more documentation on bitmasks
Message-ID: <aNvEXGTouxKGHqZ-@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
 <20250926021136.757769-6-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926021136.757769-6-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> +It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
> +as *'expression' {'bit'[,'bit']...}*.

Yes, but i think in this case it should also tell why.
