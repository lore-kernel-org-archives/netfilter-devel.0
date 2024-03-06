Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDE81DA53
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736216; cv=none; b=L+PeneOBsDKvT5eWC/iiShzTObD6MZQNsBDtTzrDc183s2zP2/ofUC8voBiKwKQiDfT4LluemeZNhzNShHXbBVF0EHPZV7rX9X3Fefw5IX53AUS5cGfup+YeMzSCSnvskXjaprH+D/CRXUerBoKoqpgiF9v8dI05G7hczUwErVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736216; c=relaxed/simple;
	bh=zYhDYI6NL04e3O3ARaBOJPqLj0vevRCNu9IUAG1xujY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okgZAXMpcIvwl7Iip34D1QeBWihKhiXP/MwUZhR0mz5jG/EnCeoffYbqLQM4/kdEeUkwuAcGhPfaDsbDWOdYZMyUvXQ3EeQtkHAezVrOSu/NYXL5eGx2TsXOxhaqZpgNpb3VDkS5cJroYJ4fu0PAESK/YGyieOtmrqN0wv5NlNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jnNVvwnR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jnNVvwnR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eIJTPT/OHv3pV6jqkQ82VrPkQiyavd2GwxpKG9UxiyE=; b=jnNVvwnRFB4lMxGP99CydslSnI
	+2auPTOs4I6VQGQfNh+zLi8tQ+WWMzkCdAnmHEZ9rk+Sa71p+EsLQ0YiWiqu/vBIL36zLiSo9TtE+
	wXfdrJwr+VOP5BbmnlAKRgr5GqO1wos4p3r9mismRA4wUBuvEsWD2lRPt6uVSDoK2yF14B4dIuHx4
	o0NHh+PCkBTKB7wo7qBm85sw3HP6olems56lqP21+BmChiR5SZo4BDYC/dYJApW1V7FuUYYjU2uZ/
	vYAyAY5U+QRkMQmnFdC/oLRrYjOn9f9gYY4JDygjwBFWklZ+MpRnBmyxsDMLDvLuosY0xr7SbbYG1
	27GSiXHQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhsUV-000000006L9-1u4w;
	Wed, 06 Mar 2024 15:43:31 +0100
Date: Wed, 6 Mar 2024 15:43:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH 0/6] Attribute policies for expressions
Message-ID: <ZeiBExEY08CTbvEI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>

On Fri, Dec 15, 2023 at 10:53:44PM +0100, Phil Sutter wrote:
> This is the former RFC turned into a complete implementation including
> Florian's suggested improvements.
> 
> Patch 1 is fallout, took me a while debugging the segfaulting test case
> until I noticed it wasn't my fault! :)
> 
> Patch 2 is the same as in the RFC.
> 
> Patch 3 separates the type value checking from patch 2 and drops
> expressions' default switch cases where all possible values are handled.
> 
> Patch 4 is prep work for patch 5.
> 
> Patch 5 adds the new struct expr_ops field and defines policies for all
> expressions.
> 
> Patch 6 then enables policy checking.
> 
> Some remarks for consideration:
> 
> * This adds kernel-internal knowledge to libnftnl, namely in max name
>   lengths. Maybe not ideal, but I found it more sensible than Florian's
>   suggested alternative of using 65528 to just not exceed netlink
>   limits.
> 
> * nftnl_expr_set_u*() setters start failing when they would happily
>   overstep boundaries before. This is intentional, but getting the
>   policy values right (at first I thought 'sizeof(enum nft_registers)'
>   was a good idea) showed how hard to diagnose bugs in that area are. I
>   think we should make the setters return success/fail like
>   nftnl_expr_set_str does already, even if that breaks ABI (does it?).
>   nftables probably benefits from setter wrappers which call
>   netlink_abi_error() if the setter fails.
> 
> Phil Sutter (6):
>   tests: Fix objref test case
>   expr: Repurpose struct expr_ops::max_attr field
>   expr: Call expr_ops::set with legal types only
>   include: Sync nf_log.h with kernel headers
>   expr: Introduce struct expr_ops::attr_policy
>   expr: Enforce attr_policy compliance in nftnl_expr_set()

Series applied after checking theres no effect on nftables' py testsuite
results in different releases (v0.9.9, v1.0.6, v1.0.9).
