Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFFC18FC86
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769556653; cv=none; b=Zaw+57Suw+LCHVqwFWMDdTxitzVjpXlPPhOi8ZUiVplVbwikldtPoyoxLNu6JSfkapIiL/t8Teaa4u+mXp23WJcMdkEEFGI8M2elInC6O4j8mmrL0jxv1AwVbZPy32aTcEbpYzaFGjQHE0+w8pxhr0iG5AAVXZDTtGC8/ALRwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769556653; c=relaxed/simple;
	bh=MiHpP6czi7w2fBEAAB1bD0PZbdqHRqIIN2HdNL7Eb/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgIad+u4oFXTwcstgY5doXL7wKRo2sY9mesbRdDGIzAZf3qHe31Kj3xdRLy1F8dveS/SKZy3+hy17ixuTqZg30C931gZrmeDyV3s2qhVL6Yj2saumYm99ullZ0Y5MUZosBrgZtm/OwwRI4FeyT06Z34rJUf9g5/3z5NoJ8uWqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=diYf/0ak; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="diYf/0ak"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vo1ga2XvDFC/n0gGhSSA0kmGscWegtPT9p0il5uZcD0=; b=diYf/0akkYCjZKsDmMNKzrA86+
	NeWirf9vOFU5jvYzohA+pt7cqaKK6MdERSuEPGe+2u7RHcdZJwnB40Z0fRW7+9l5DEchWp1PPCEEs
	YbBHza1kivDuchyrEUCNsG7zLApiu6rgOPWcACzMh8CybfZ7sFVz5Y9N4GBaVTTkxFs6gQhtWIAa+
	j5eQP87oF5580Q9QnvCuozXz7O7u87oyz1zGVqfpyeQcjlDlrvJJ2SwYqKVItYaEH/WnXQCdZjd+N
	o43jo5zYc7g+PPSziN+7LtW3ewU5I/mWjdlmGxREpjY5ixnCjOMiQPWEuPVxxLpfKiBF+UFQexRab
	aoFy06ZA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vksWG-000000003xl-3oVb;
	Wed, 28 Jan 2026 00:30:48 +0100
Date: Wed, 28 Jan 2026 00:30:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aXlKqM0lim7gvOGi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260127221252.27440-1-phil@nwl.cc>
 <aXk5l4AQ4XHvyBrx@strlen.de>
 <aXk-ZPRpYwj_KZ5e@orbyte.nwl.cc>
 <aXlAdFAKM5SVfFfE@strlen.de>
 <aXlDPwtasLIQ9NMg@orbyte.nwl.cc>
 <aXlH2xBJdgX9gFgj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlH2xBJdgX9gFgj@strlen.de>

On Wed, Jan 28, 2026 at 12:18:51AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > As said, these headers are all structured as "<typename> TYPE":
> > 
> > - INTEGER TYPE
> > - BITMASK TYPE
> > - STRING TYPE
> > - INTERFACE TYPE TYPE
> 
> - INTERFACE TYPE
> 
> > - LINK LAYER ADDRESS TYPE
> > - IPV4 ADDRESS TYPE
> > ...
> > - ICMP TYPE TYPE
> 
> ICMP TYPE
> 
> > - ICMP CODE TYPE
> > - ICMPV6 TYPE TYPE
> 
> > - ICMPV6 TYPE
> 
> > IMO we could drop the " TYPE" suffix from them all, but only merging the
> > "TYPE TYPE" cases is inconsistent.
> 
> Why?!
> 
> INTEGER TYPE
> INTERFACE TYPE TYPE
> 
> Thats absolutely sounds inconsistent.

Why is it? First type is named "integer", the second one "interface
type".

> Sure:
> payload expression, datatype integer (integer), 4 bits
> meta expression, datatype iface_type (network interface type) (basetype integer), 16 bits
> 
> So what?
> I don't see any implication that you can take 'FOO TYPE' to mean
> that the type is called 'foo' internally.

We start splitting hair, but IMO a user reading "ICMP CODE TYPE" and
"ICMP TYPE" will likely assume the first type is called "ICMP CODE" and
the second just "ICMP".

> > I get your point, it looks wrong and sounds odd when reading out loud
> > but it is formally correct.
> 
> Ok, I give up.

I'm just stating my point. If you think we should just
's/type type/type/g' and it's not a problem, just go for it and I'll
adjust my patch to it.

Cheers, Phil
