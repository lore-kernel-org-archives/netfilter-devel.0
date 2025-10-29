Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C82D3314C8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 11:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761738061; cv=none; b=u5QneZvFDzRs3xlxodxuF3LXLF3ur92BDN2tnvNjL9Faf5SaaKwJy7p/+7k7y0uvWeVah9xDttuYBP8MeKBkJew4Y/KbXqnncf0t3H18H+BSWuYYpqD4oqXcWkVWdE1om9yqu/CM0pHSFnzk7kFhsu3e2ii7HminURQOqxbDx9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761738061; c=relaxed/simple;
	bh=lm4FgANgkYynHZRRNMYPv815x0OkfpqalmF2nXeVcGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqZpX+EmZpetpRwsZ6joFD5YZ7XEStEMCRcpPF1wTE/FBK/WGvv+61nrb+NsLsuaJ6Qo2nmdiPjBY9+dFuKzoWQcxd3o6wEiv65hgAhRXsmSlHHuKioegXZGe1h0vziPEJ34atyt6pbvpjs9tJwefux/8TxYx+N6qclJSOxACBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADCA2602E2; Wed, 29 Oct 2025 12:40:57 +0100 (CET)
Date: Wed, 29 Oct 2025 12:40:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: Re: [PATCH 0/8] improve systemd service
Message-ID: <aQH9SaAdc8fDKjcc@strlen.de>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
 <aQDwcsK0RKsrtVop@strlen.de>
 <b66cb7d6e998dcb76cee90694d4632c6d7122153.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b66cb7d6e998dcb76cee90694d4632c6d7122153.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> On Tue, 2025-10-28 at 17:33 +0100, Florian Westphal wrote:
> > > This is a first series of patches that tries to improve the
> > > included
> > > `nftables.service`.
> > 
> > Sir, this is netfilter-devel and not nftables-systemd-devel@.
> 
> Uhm? nftables ships the .service file, none of this was about systemd
> development itself, there doesn't seem to be a dedicated list for
> nftables and no one complained about me posting nftables manpage
> patches on netfilter-devel.

I don't have the expertise to review systemd service files.

> > I see Jans original service file) as convinience / ease-of-use
> > contribution
> > not as something that should be maintained continuously.
> 
> Hope that I don't negatively affect anyone's use case for this, but if
> the file isn't meant to be maintained, shouldn't it then rather be
> dropped?

If this thing needs constant changes then yes, absolutely.
