Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B54A6CD4;
	Thu, 10 Sep 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056188; cv=none; b=STIpbkgxfm6Z3/XVMv08PI0XNrKRzXTHXNuLBGosBZymJWr+yDbQgjxvdXWRgm/4D2vsUqwEYqem6bwCV5uwiXiCk+IazDk0atmBFf0PL0/YZJIljm9//xCPZwugOxjIXKwC3h3tw5MzqtXKJb09qNNxvOcM6Kz1K3xItZPL/Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056188; c=relaxed/simple;
	bh=bDcbaPFNZr5xBRY1xc9NL6Put++QctJsgCgk8jmTm0A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kY12BJyjaoTOATeO5cQ0FGo1XB2oFgQl8hkrsGR4J+gBF5LtCJt9tJgcOca3SsA3sW8aFRjBm8LgDfC0dKuekF904z8yb+Ao5pc3ohhcoPgHT6jfa56diMTGGFawhY/VSy8QoIBnj/W7bvQH0cvunzhgsiYvvA5Dok3dv99lElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2jOhy+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2jOhy+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE13B1F000FF;
	Thu, 10 Sep 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789056186;
	bh=bDcbaPFNZr5xBRY1xc9NL6Put++QctJsgCgk8jmTm0A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d2jOhy+Dn8cK0ItQV7iVdGsK2E9lsnbXmIMcDl/o1Q9XVOjdHJJAC6D/zFQQ5bVWD
	 1ZIKcea80MJ2NcdGKMnuIpcu3nvjaXAkeWiTm5YPxiKb/faDyowJKtthoCVAqtoXh1
	 ZgSYvZdHC0/JSPfrAlwwZ+Gu9DOSiOJ9qPh1BceqR7hNFYlJsJM18JXJnCDFN0SMrV
	 yMavA+CzWoEX2jFob/+DvjBbPvV77bjZSZpCArSxMaGFOUyAy/DDHVMf3IrA1uFAZ7
	 9GlNAUBa2t4A7jM/6mtcQczJb+Moph3ClIBN4xz3YRL+4RyY87J26eExrgtEbjIwrB
	 pV2jvyZatn/zQ==
Date: Thu, 10 Sep 2026 09:03:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hangbin Liu <hangbin.liu@linux.dev>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 donald.hunter@gmail.com, ast@fiberby.net, i.maximets@ovn.org,
 one-d-wide@protonmail.com, fw@strlen.de, pablo@netfilter.org,
 netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] netlink: specs: conntrack: minor spec
 fixes
Message-ID: <20260910090305.2fb2a961@kernel.org>
In-Reply-To: <aqJQ2rz2HDF5FTM3@fedora>
References: <20260910003852.2184031-1-kuba@kernel.org>
	<aqJQ2rz2HDF5FTM3@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 14:40:26 +0800 Hangbin Liu wrote:
> BTW, I'm still working on rt lwtunnel encap support. I noticed some sections
> in your change have documentation while others do not. Are there any mandatory
> requirements for documentation at this point?

For the new families where YNL actually code gens the uAPI and kernel
code it's recommended to add the docs in the spec. For classic Netlink
families it's up to the author.
