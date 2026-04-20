Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300063921DB
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776710916; cv=none; b=OKV3LhBPssvYCSHp8aVBomisGm+o2mzDviOHYPi0oSFlA7zFz8dRZiFGflF2qX/1EL0ZLywoH6CMyF+6VChR5WQIlKmH2eBA3t1aW+5kFhowPK4mXrx39bC5mMpy7KlO0wEAZnJsADei2cYxwci9HUq+zvQ4aI4ADMBtcdqCSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776710916; c=relaxed/simple;
	bh=ojzYu7rkiLvAJPgxuGTTUiEvcbG5Gey2uNO73L4Wf7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ot4h/6r6IQKPegSOlrSapPLx/YgQSvBzVlcDC4YzOdibHp1UIqo+OYKtIqA33bz656FqUJd23WJvwBoQn3fwbwtAAlK8Q/WsMM2bCPdpwo4GxYeTNXU2geyVD1xGFW0gUQ1MIH1HA4Wy4xrzV0z3WysgXeJs+QyisdVV2d4RdoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=m6+QHDW3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="m6+QHDW3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B28016026D;
	Mon, 20 Apr 2026 20:48:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776710911;
	bh=C8oUBm8Kyh0PQVVuSfwGS+I2OmhSYQC7ihQAZvVh9Dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6+QHDW3RYMPVM1E3bH2eBF0nPy+X+6W2nWcaWOKOw5Y2XBzlC18hilDxho2OUdeG
	 7FBfMt7EoGwo2n04dORdWulqp9cH+DkqIcMHOr1PkSL3o4688jVyuqsADdGrqQZrKG
	 Hr9YMtuVtee9YIqYxB61Xfp6naPZi7m04xGuzkbb6Kb671B6kQ78hb0ERTdLwnzn9m
	 qVQe746rheW4+tID77Wav/9h9YMH8dqjtCC7HwV7KWjSsBNRR2I8p9j4zj9Z74d5TU
	 5ksqfT0+vO0SoITh18OPQOQSjBbE1LA4Ok77i5KAizR4zFzUhaO3HE4X5eWegQhV9Y
	 DGlMNvXW365QQ==
Date: Mon, 20 Apr 2026 20:48:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Message-ID: <aeZ0_GvXUnOJPSJ3@chamomile>
References: <20260420174227.13087-1-pablo@netfilter.org>
 <aeZoiqyPFP0NJkz9@strlen.de>
 <aeZpj9r368paudyZ@chamomile>
 <aeZunt0QSt2EdFdF@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aeZunt0QSt2EdFdF@strlen.de>

On Mon, Apr 20, 2026 at 08:21:18PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Apr 20, 2026 at 07:55:22PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Several matches and one target check that the hook is correct from
> > > > checkentry(), however, the basechain is only available from
> > > > nft_table_validate().
> > > > 
> > > > This patch calls checkentry() for matches and targets from the
> > > > nft_compat expression .validate path for the following matches/target:
> > > 
> > > I worry that this is fragile.  Not all ->checkentry callbacks are pure.
> > > Some create /proc entries or bump reference counts.
> > 
> > xt_set does bump the reference count. This calls xt.destroy to restore it.
> > I am only calling them for the list of expression you mentioned.
> 
> I worry this will lead to trouble later, e.g. info->priv = kmalloc( ...)
> -> memory leak.

If someone needs to cover for more extensions, they will have to
update the list of extensions covered by the strcmp() check on the
extension name.

> But OK, at least there is a test case in iptables.git for this.

Yes.

Your approach duplicates .checkentry in some way, you have to make
sure what your .validate and .checkentry perform the same check, ie.
they are in sync.

The approach proposed in this patch is not universal, because
checkentry() is a place where many things happen as you suggested
(/proc entries being registered, reference count being bumped,i
kmalloc...).

If this needs to be generalized further, maybe checkentry() needs to
extended to improve integration with nftables.
