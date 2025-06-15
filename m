Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9EB45C0B
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981973; cv=none; b=gBQxUeNTz6XlDPebeACV2Yy5j3lBtKew4G6DD8UwcLFYvSJFrx43sVjCLPV/cmNQJdy7D95mU+toPpMLValFpyL6wBrQ6q4R122gGTgekSNxQwntHKnTj1zRe1IYlZasnYBjVJblsPyWPZKnNVT4hb3FObuPOJRIb2VlmYDikN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981973; c=relaxed/simple;
	bh=k3jAyjqJD40435H/5ipguD0x9ngftQrQS1xxgVCTfNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbUApvER2Z4QVW9WTgA4z1NbRKiJ/D+ll3ghVhUUs1OhpkgzEIcTpDtcbkcZi1p/CnhE1BQi//PEjuOrr6FKSD4b6GjADDxEvhbnlsQ2qt1zcdThft7L5MfROx5mVj6l+xejHl9PLZWX1fpCGLxxOhsWZsEwlUWjxAL/CYm3DzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g8tT/0fa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g8tT/0fa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g8tT/0fa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g8tT/0fa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A792B60254; Sun, 15 Jun 2025 12:06:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981969;
	bh=VGcidfyxh0jWh9TqgVuF6CsPw02z9FITw4MGTudEseM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8tT/0faFqBVOe0j6tyRgfR3DXWj4AuMJ5Kg0ZA2ELOfJ+sqtaG8uuAL9k3Fg4oLO
	 RXMw0qootLlHSct1bujf+Z8gZNwYZL1p8nJAvYx67priAGmquUXU9qtKIglIYbeUe/
	 rFCTQ6MZuhW7BPLzKfATsWkvvg2RNiFJR814yIz4hh4PhHHnCNEniDzWbyY+vbv30t
	 3M0feUV4GZoqdOQ386L2CUE6CQoWMIg3dceRS0rkl7tBYgz1/CrSX0ovwNllISDsuN
	 HQhYK3Zwy3hguG742ZmHq9Zgw+vOR42luYkEbsS6WdBUcHo1ffOCcWBZSQOczVd79I
	 c5OUk/YKIW+Gw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A91160254;
	Sun, 15 Jun 2025 12:06:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981969;
	bh=VGcidfyxh0jWh9TqgVuF6CsPw02z9FITw4MGTudEseM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8tT/0faFqBVOe0j6tyRgfR3DXWj4AuMJ5Kg0ZA2ELOfJ+sqtaG8uuAL9k3Fg4oLO
	 RXMw0qootLlHSct1bujf+Z8gZNwYZL1p8nJAvYx67priAGmquUXU9qtKIglIYbeUe/
	 rFCTQ6MZuhW7BPLzKfATsWkvvg2RNiFJR814yIz4hh4PhHHnCNEniDzWbyY+vbv30t
	 3M0feUV4GZoqdOQ386L2CUE6CQoWMIg3dceRS0rkl7tBYgz1/CrSX0ovwNllISDsuN
	 HQhYK3Zwy3hguG742ZmHq9Zgw+vOR42luYkEbsS6WdBUcHo1ffOCcWBZSQOczVd79I
	 c5OUk/YKIW+Gw==
Date: Sun, 15 Jun 2025 12:06:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix crash when set name is null
Message-ID: <aE6bDvhyhpIz3paL@calendula>
References: <20250606104152.7742-1-fw@strlen.de>
 <aEoRbjDUWw6lRyRy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aEoRbjDUWw6lRyRy@calendula>

On Thu, Jun 12, 2025 at 01:29:50AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 06, 2025 at 12:41:49PM +0200, Florian Westphal wrote:
> > Bogon provides a handle but not a name.
> 
> No handle for delete map command:
> 
>                         |       SET             set_or_id_spec
>                         {
>                                 $$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
>                         }
>                         |       MAP             set_spec
>                                                 ^^^^^^^^
> 
> This is incomplete:
> 
> f4a34d25f6d5 ("src: list set handle and delete set via set handle")
> 
> but this is also lacking handle support:
> 
> 745e51d0b8f0 ("evaluate: remove set from cache on delete set command")
> 
> Then, reset command parser looks consistent:
> 
> 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
> 
> but cmd_evaluate_reset() calls cmd_evaluate_list() which cannot deal
> with the handle.
> 
> Looking at delete command for other objects, same issue, eg.
> chain_del_cache() also does not deal with this handle.
> 
> I think the way to go is to add another hashtable to look up for
> object handles, I can post a patch for this purpose.

I started extending userspace to improve support for handles but it
turns out that kernel is missing a few bits for lookup by handle in
get/reset commands.

So I am only fixing this in a series by now.
