Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319FB3451BF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 23:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755559507; cv=none; b=VM2LW9JyhC8Xfb5FNgsP0BlJF9NeQOXoIjIWi2H+DFo/lU7qg4fy5Op82LYwmnE83glif8AM6ZF7wK+lS6mMjmSoF/sdOc/KYxibDTWJCnPlBH5yF7XqsGt1dRAJkm9lAv73rajuy8doWhcJQuCjx07metBXzgbhT2sM7b1kC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755559507; c=relaxed/simple;
	bh=RLJ8wqFT7E9TMPcZ5MY0l0SfbKhOuUhlfqvrljOeV3s=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGH0ZPo9kagSFfRLhtGYpXhdfphsmUuRLMUigIcOR+n0QkoescNDIYk9S/9WdcuVLtY8nF5LlecnBVnVzs2JePfP5YE7pIf56DBF15jf8S2r72R9/hbSbzQFSuihcwmFU4y5sPf0EasDRLRPc+RD99HpaCIlZB11ZGUr5JceN3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G7ABA06Y; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G7ABA06Y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G7ABA06Y";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G7ABA06Y"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9335E6029E; Tue, 19 Aug 2025 01:24:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755559495;
	bh=OQ/oyJgR1xxZbTEGPLZh4TVtNSbmNBf/juS6/xa1occ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=G7ABA06YSV+40EhnDFzoQmlz2gQBg4OYcgSn/cTYzu/WJbpYQOTesfF9hbvNaiewk
	 cNEK/V2l7cVxujvrH+3Vbqbdv0khNY2TY2zTyyq/DQKLafGkI0KOAyKiB8kYxCZilW
	 42sv0s9VtiKueRG7DDV+Zt7L+owDdGxLORi3EaPxvfKAf5E6+Ocr4S63DTFzm3SgJj
	 UKvBx5KYyhOWiXlb6zZMEdCyMXDmpR+fMb1jHptPxTF1YGOXDsO3x6IKSP/T6/tAbQ
	 busWGOh4i24ZSrl+ufs0cz/Hlsaz7jeRK+3FiAtBMa9ARelDfeHnG/MrMzjHigBn+E
	 xB3NLwvQyf66A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DC9256029B;
	Tue, 19 Aug 2025 01:24:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755559495;
	bh=OQ/oyJgR1xxZbTEGPLZh4TVtNSbmNBf/juS6/xa1occ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=G7ABA06YSV+40EhnDFzoQmlz2gQBg4OYcgSn/cTYzu/WJbpYQOTesfF9hbvNaiewk
	 cNEK/V2l7cVxujvrH+3Vbqbdv0khNY2TY2zTyyq/DQKLafGkI0KOAyKiB8kYxCZilW
	 42sv0s9VtiKueRG7DDV+Zt7L+owDdGxLORi3EaPxvfKAf5E6+Ocr4S63DTFzm3SgJj
	 UKvBx5KYyhOWiXlb6zZMEdCyMXDmpR+fMb1jHptPxTF1YGOXDsO3x6IKSP/T6/tAbQ
	 busWGOh4i24ZSrl+ufs0cz/Hlsaz7jeRK+3FiAtBMa9ARelDfeHnG/MrMzjHigBn+E
	 xB3NLwvQyf66A==
Date: Tue, 19 Aug 2025 01:24:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/14] json: Do not reduce single-item arrays on
 output
Message-ID: <aKO2RJbE_3GdtwNH@calendula>
References: <20250813170549.27880-1-phil@nwl.cc>
 <aKM1tbmVvbzoDUqx@calendula>
 <aKOWFj5sjJNySsde@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKOWFj5sjJNySsde@orbyte.nwl.cc>

On Mon, Aug 18, 2025 at 11:07:34PM +0200, Phil Sutter wrote:
> On Mon, Aug 18, 2025 at 04:16:21PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Aug 13, 2025 at 07:05:35PM +0200, Phil Sutter wrote:
> > > This series consists of noise (patches 1-13 and most of patch 14) with a
> > > bit of signal in patch 14. This is because the relatively simple
> > > adjustment to JSON output requires minor adjustments to many stored JSON
> > > dumps in shell test suite and stored JSON output in py test suite. While
> > > doing this, I noticed some dups and stale entries in py test suite. To
> > > clean things up first, I ran tests/py/tools/test-sanitizer.sh, fixed the
> > > warnings and sorted the changes into fixes for the respective commits.
> > 
> > Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Series applied, thanks!
> 
> > I will follow up with a patch to partially revert the fib check change
> > for JSON too.
> 
> Hmm. That one seems like a sensible change and not just a simplification
> of output.

Actually, I don't find an easy way to retain backward compatibility in
the JSON output for fib without reverting:

commit 525b58568dca5ab9998595fc45313eac2764b6b1
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jun 24 18:11:10 2025 +0200

    fib: allow to use it in set statements

commit f4b646032acff4d743ad4f734aaca68e9264bdbb
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jun 24 18:11:06 2025 +0200

    fib: allow to check if route exists in maps

I am not sure I want to do that, because then the fib expression
cannot be used with sets/maps.

The "check" trick was a "smart" workaround, I don't have a way to know
if you want to check for the presence of the real oif, without peeking
on the relational right hand side, which only works for rules without
set/map.

Peeking on the right hand side does not work to decide the semantics
of the right hand side for relationals, but not for set and maps,
because those could be empty, hence this "check" field.

Maybe, simply retain backward compatibility for the fib check with
relational expression would do the trick? But I am not sure the JSON
parser provides context on whether the expression is being used in a
relational.

> I guess if we take this approach seriously, we should agree
> on (and communicate) an upgrade path for JSON output. In detail (from
> the top of my head):
> 
> 1) What changes are considered compatible (and which not)
> 2) In which situations are incompatible changes acceptable
> 3) How to inform users of the incompatible change
> 
> I'd suggest something like:
> 
> 1) Additions only, no changes of property values or names
> 2) Critical bug fixes or new (major?) versions
> 3) Bump JSON_SCHEMA_VERSION? Or is the "version" property in "metainfo"
>    sufficient if bumped anyway?

This was going to be an issue sooner or later.

Updating the JSON representation would require to maintain backward
compatibility, changes would need to happen in a less incremental way
because you don't want to change the schema so often.

And this would also require to extend tests/ to deal with the
different versions? Which is going to be very tricky, it sounds like a
no-go.

Then all this means that everything is set in stone for third party
parsers, and that we have to forget the idea the JSON representation
can be incrementally refined, and simply add more stuff on top of it
as you suggest.
