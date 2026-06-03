Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AD2383C9D
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780526002; cv=none; b=fvPydsATWk8IabXCQ67oPifRH8GdkWo8Ns5q4U1H9FMRubK7sNlq3WvWVtVJoLPfr8NY3IV7oGBuHjcepVobJD1x56jGrW6wqU/HF1nQjImnfI4K3RKP1h/EVpSji0Tmx1jCwNZN/UVDcg9aDtObViRNb1kIr01Vr/ExHg3uZhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780526002; c=relaxed/simple;
	bh=n3PNT04QMZJktCyJHpyoY+9ZW262s2pdon5I/AavEks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LteizLizH3FpKH+YI4eYBBV4e5EQtHQtJzJErIu8Xkhy/+Yd64pDYdwwZORUDMwU//HsZr2DpKX+lw1gRbwmkHYypPbTsaxiYpYT3TqoOb5qEKDsa6LqzlE1To+PgboIejYby85TlBNGoWJ7hsJBgmxQS7R62Z6GYYqLZ8WfVg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MuJvDJgP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MuJvDJgP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BA08D6017D;
	Thu,  4 Jun 2026 00:33:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780525992;
	bh=hlGQ/0yhioZn/Fed/5iaD+GvwjKSmWPOSuo4mzwfj+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MuJvDJgPfYbO1ilkOmFiHXrV7a1ac2A5vIPmkq5uua2pTtToalss8KGFFjpl7DbTM
	 sioas55BVsQnhmsDaEeJVjv1IxK1UKPsSnwIebY2neU1tgpxSP4cBdKvtaql4jKcwN
	 GDe4zL/ZZ7F52o048PqNyKHytNfQ89j6sQsr5CVmmyPH6ALBDMjt7KWnnFyHapIwNt
	 XWbaH5LVylvraEg2l/ySbKLcEhSaUpXndDFvoSiQqSygWyWQOILycNKobqh1bBURlS
	 hbwaZl6XxsaOqeI+4dl0VZY4xMczI809Ubil1mh/avpGSEAWqAddIesM2Z17Mw5ZdO
	 3/5EbBg97c+5A==
Date: Thu, 4 Jun 2026 00:33:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf 0/2] netfilter: add restrictions/validations for packet
 rewrites
Message-ID: <aiCrpdgRNCC7LkaA@chamomile>
References: <20260527121147.22076-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260527121147.22076-1-fw@strlen.de>

Hi Florian,

On Wed, May 27, 2026 at 02:11:42PM +0200, Florian Westphal wrote:
> This is a followup to the recent patch that disabled packet manipulation
> via nfqueue or nft_payload in user namespaces.
> 
> This adds additional *restrictions*.
> For nfqueue, do minimal header checks in case userspace provides payload
> replacement data.
> 
> For nft_payload, restrict the offset/length combinations.
> 
> Several of these checks could be done at rule insertion time (i.e.
> control plane).
> Risk is that this may cause ruleset load failures for existing rulesets.
> With this change such writes are silently skipped and packet passes
> unchanged.
> 
> Restriction is added for link and network bases only.
> 
> Open questions:
> - target tree: nf or nf-next?
>
> - should there be an immediate followup ('patch 3') that reverts
>   the userns restrictions again?
>
> - should nft_payload reject those requests it can validate there from
>   the control plane?

Ideally, better from control plane.

If anyone is breaking with ilegals field, they should come here to
explain? Data plane validation might look safer ... but it will just
drop packets and it will take a bit more time to the user to debug.

But your approach is more conservative, it just leave the packet
untouch, so it is basically ignoring the invalid mangling.

Your call.

Maybe I would like to see the commit description a bit more expanded
to describe what it is intentionally allowed on top of what you
already describe.

> I would propose to target nf-next for now and leave the userns
> restrictions in place to see what relevant use-cases exist.

OK, let's do that.

Thanks.

> Florian Westphal (2):
>   netfilter: nfnetlink_queue: restrict writes to network header
>   netfilter: nftables: restrict linklayer and network header writes
> 
>  net/netfilter/nfnetlink_queue.c | 103 +++++++++++++++++++-
>  net/netfilter/nft_payload.c     | 166 ++++++++++++++++++++++++++++++++
>  2 files changed, 268 insertions(+), 1 deletion(-)
> 
> -- 
> 2.53.0
> 
> 
