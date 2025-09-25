Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F032D94B7
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758811351; cv=none; b=cYqYot9Bsla69b1wH3YOQFfybMczzc1TQ8LulouBRG9ZunxPRFVWGOunv5jscKQQCukfHAemQLUIA454KcF08lUP7Kc+i8TzoYswuVq6e2GAomY1YvMZhODt3WsgHeZsRha1JP+kNrsiByuNTYJ0WSnfxWl5rF0sCcp3z7qrZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758811351; c=relaxed/simple;
	bh=AKbrfzPY04HMUjuDai3SkpIggZtEb5QTO+jTfbiLorI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR6a0jdJ20h3rDJR0rbWtkmQCN6eR+5mX/gsO7ld3QWNZRArgWr3Z2anUPsQxnYJL4QrmmTpNkAXbBjr4bHufeveE7fyEgUgOY+zXGHks3kTSQRJJjPe7s4fJ6QKedibQnL40EQ0jdZ0tR8mXhQzcjjPleb+WaOkXD+4f7Wk3+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F163061056; Thu, 25 Sep 2025 16:42:19 +0200 (CEST)
Date: Thu, 25 Sep 2025 16:42:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
Message-ID: <aNVUxFz1RDsu7wuk@strlen.de>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>

Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> IMO especially for iif/oif, which hardcode the iface ID rather than
> name, it would IMO be rather important to show the real value (that is
> the ID) and not the resolved one.

Seems like a bad idea.  Existing method will make
sure that if the device is renamed the output will change.

Also, if you load a ruleset you get a hard error if the device doesn't exist,
unlike with a raw value.

Or, its updated interally to whatever value is needed.

I'm open to Fernandos suggestion wrt. new options but i just don't see
a use case for this.
