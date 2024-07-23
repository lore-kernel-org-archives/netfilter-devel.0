Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413AD14EC61
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735812; cv=none; b=DIEDFALDGURdlJ7cJdMKzvOKqWXH4aOJOTZSg1po4ANTWaMO9xatZ1Zl8R9GQSDM0cFU/5Xxjnq+Xu2o884T5eIlVvq8rMdEBw72OXkhH0wpJ3pADHGu79SlAVE95vWjbgtvDJ8lQXlArYBpYOI6Vu7k/Ze8XxVfnCSR9xoUGso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735812; c=relaxed/simple;
	bh=UkWL8KZ7Ab9ZeiwIBF1S4/oYx/sa0T073ZtySrasY+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGoke1iuIDY8L4gvorT6iEQpwsXZNcaYoSpiLwkBJCNvp+3ncEGoNKjWC08CCxhL8FOeZUrWQWqsD8TNLl/FQ5qNnNsH8HwZXLF5zZ/RCs74RHu3Lf13TKWgDpPyHtq5sFNuLHzLahYqBTSk4/3XoJJV2R0b6ZbAXMlOQ/BLnX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=c27maL3h; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="c27maL3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3/f2rKA98q9uZXLIjy1LLQYIo4dycDPAFBZzQ0/gABQ=; b=c27maL3hsXZ2pymhkn/1QmM7d5
	2CuBOJhVfyqoehWehN2i4iCf038WPKzmekiZ4GYDgQ6OB64/fgfd/Vm3cEugWnoj0IShCPdSLd1wR
	z/bHRulB50bzVpIaC4Ix98+aRPqN3D81vGENO/IMkdXjPPc1dNi4svZVn0uyoSJMe3JFaQtpCvIDD
	6SB1cWl6xDmsSjuZVQ53bNU8yO3XQgOEo8DwckDK41sUtdDZPZ2RkQKGZRTaCANNzTsBqIKZ4EYNE
	gWxVU1kbPhRW4I+zXb+AWVFYsbavO3W1ZB/9Uby7J7o80hqju966mI/hgUxJK0HNeQikQ+HGuf2cb
	YPLN2uGA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sWE8M-0000000020z-0ZxU;
	Tue, 23 Jul 2024 13:56:46 +0200
Date: Tue, 23 Jul 2024 13:56:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zp7QSXcMHt9a8Hm7@calendula>

Some digging and lots of printf's later:

On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
[...]
> I can reproduce it:
> 
> # nft -i
> nft> add table inet foo
> nft> add chain inet foo bar { type filter hook input priority filter; }
> nft> add rule inet foo bar accept

This bumps cache->flags from 0 to 0x1f (no cache -> NFT_CACHE_OBJECT).

> nft> insert rule inet foo bar index 0 accept

This adds NFT_CACHE_RULE_BIT and NFT_CACHE_UPDATE, cache is updated (to
fetch rules).

> nft> add rule inet foo bar index 0 accept

No new flags for this one, so the code hits the 'genid == cache->genid +
1' case in nft_cache_is_updated() which bumps the local genid and skips
a cache update. The new rule then references the cached copy of the
previously commited one which still does not have a handle. Therefore
link_rules() does it's thing for references to  uncommitted rules which
later fails.

Pablo: Could you please explain the logic around this cache->genid
increment? Commit e791dbe109b6d ("cache: recycle existing cache with
incremental updates") is not clear to me in this regard. How can the
local process know it doesn't need whatever has changed in the kernel?

> Error: Could not process rule: No such file or directory

BTW: There are surprisingly many spots which emit a "Could not process
rule:" error. I'm sure it may be provoked for non-rule-related commands
(e.g. the calls in nft_netlink()).

> add rule inet foo bar index 0 accept
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Cache woes. Maybe a bug in
> 
> commit e5382c0d08e3c6d8246afa95b7380f0d6b8c1826
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Fri Jun 7 19:21:21 2019 +0200
> 
>     src: Support intra-transaction rule references
> 
> that uncover now that cache is not flushed and sync with kernel so often?

The commit by itself is fine, as long as the cache is up to date. The
problem is we have this previously inserted rule in cache which does not
have a handle although it was committed to kernel already. This is
something I don't see covered by e791dbe109b6d at all.

Cheers, Phil
