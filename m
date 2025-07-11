Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37391C84D9
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752229675; cv=none; b=DmdzpQraM0AVb5kg6+wTmFLNafFCGVQ5CMVRH1o9ncYrnP2h7HwW71xwYMmuUBiwQbeBTb9hjovbVT2Nc2qoFDsUpiF0VhA6oo8mh3c0hVd5AYFYqgG48JcQ7yxKer7FLK7nhu8K65LMvDTzF87/3vCQn2QFccZbGOe88lum4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752229675; c=relaxed/simple;
	bh=t+I9dFrTuVQsV4QFf1vrLxyzuCL+RE6tC08kV7wDJKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qMEqfLsBkcV/Ybm7HbSo2nxADNh/9OHAAaA7DMxyYO4xbeYmw1m5BmZnoiwm/bCpG3727iNbOA8NclYQC7RWVYX+ooaxxcKCYVGRfUaoJ/5NhfLWxKUQk4ifT+fWPq/oa+XNiHPwD2k89h0mdKlyEwOJb6cauliMGCgHGnGDQv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 57A8A604C6; Fri, 11 Jul 2025 12:27:45 +0200 (CEST)
Date: Fri, 11 Jul 2025 12:27:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Feedback on variable sized set elements
Message-ID: <aHDnIS1iaBKtxove@strlen.de>
References: <aHCFaArfREnXjy5Y@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHCFaArfREnXjy5Y@fedora>

Shaun Brady <brady.1345@gmail.com> wrote:
> I'm sure I bit off more than I could chew, but I attempted to write a proof of
> concept patch to add a new set type, inet_addr, which would allow elements of
> both ipv4_addr and ipv6_addr types.

Why?  This is hard, the kernel has no notion of data types.

> Something to the tune of:
> 
> nft add set inet filter set_inet {type inet_addr\;}
> nft add element inet filter set_inet { 10.0.1.195, 10.0.1.200, 10.0.1.201, 2001:db8::8a2e:370:7334 }

How would this work with ranges or concatenations?

> Figuring most of this would be implemented in the nft userland, I started
> there, and was able to successfully get a new set type that allowed v4
> addresses OR v6 addresses, depending on how I defined the datasize of
> inet_addr (4 bytes or 16 bytes).
> 
> When leaving inet_addr size at the required (for both v4 and v6) 16 bytes
> netlink would return EINVAL when adding v4 addresses to the set. We found in
> nft_value_init:
> 
>                 if (len != desc->len)
>                         return -EINVAL;
> 
> with len being the nlattr (the v4 address) and desc being the nft_set_desc. 4 != 16.
> My questions:
> 
> 1) Is this feature interesting enough to pursue (given what would have to be
> done to make it work (see next question))?  The set type only makes sense in
> inet tables (I think...) and even then, would roughly be syntactic sugar for
> what could be done (more efficiently) with two sets of the base protocols. But
> hey, nice things make nice tools?

I don't see how its doable.  The lookup key fed to the set lookup
function via nft_lookup.c has a fixed size.

From kernel point of view, its an array of u32 of a given size dictated
by the sets key length.

> 2) (assuming #1) I believe we would have to put a condition to check the set
> type versus the nlattr type, and allow a size difference on
> set(inet_addr)/set_elem(ipv4_addr) (I don't know if that has any
> ramifications).

The kernel doesn't know what an ipv4 or ipv6 address is.
It only knows the total key size.  In case of nft_set_pipapo.c its also
told the sizes of the individual subkeys. (e.g. ipv4_addr .
inet_service -> 4 . 4, ipv6_addr . ip_protocol -> 16 . 4).

Maybe it would be possble to xlate ipv4 addresses to ipv6 mapped
addresses, but that would still require expansion in userland, because

ip saddr @foo
ip6 saddr @foo

cannot work.  We'd need to rewrite it to something like
meta nfproto ipv4 {
	reg32_1 = 0xffffffff
	reg32_2 = 0xffffffff
	reg32_3 = 0xffffffff
	reg32_4 = ip saddr
	lookup @foo sreg32_1
}
meta nfproto ipv6 ip6 saddr @foo

I don't think its worth the pain.  Also because then ipv4 becomes
indistinguishable from on-wire mapped addresses.

> Another possible approach would be to create an API to transmit valid size
> types for a set type from userland. We would still need to ID the set type,
> and that has the above problems of set.ktype.

There are different sets, yes, but none of these sets support a
particular data type.  They don't know what that is, the datatype is a
userspace thing and its only stored in the kernel so that 'nft list
ruleset' and friends know how to pretty-print the octet soups stored in
the set.  Its not related to matching.
