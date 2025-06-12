Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB245948
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749755920; cv=none; b=nObnME9mQ8I9JRKCtLLLW5n4AGHGELBGF3N3Bh4pA3qbH75SQTj2bjUufZI7u6WbEIe5Hg5nd9ntr/X11q5wfWCU7cPz37A00z30+XZw/f1MG1idjirGLe095VKriywDqA1dy14tiHGYqIqdjs+3q9wuvvNekGvVJiHz9st4OiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749755920; c=relaxed/simple;
	bh=uiQofhG6LIpxIxfSeb2MzUaD3FGzlfIuX+dh3G4y2DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o31HtbHwdLrflL0PBPiWv3UdNqtgftsK7LS0ddbgqE9MvctefhXhaPmd9r/6BIDVMDrOSstr3Q7sG8I5QRs+TyrFE+H1YnqmfKl1TpwxaHrnGzxrwmF0bXquB+m65Vopqtp8b6qEEwhQhmnwjexoNvRv5lP2JHOyOnzmeVOJ36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d5sqqMUR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZM/Z45RN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d5sqqMUR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZM/Z45RN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3BEEA60377; Thu, 12 Jun 2025 21:18:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749755913;
	bh=PrOq2nhzyVMBjxPT71BLqQY5xSmN1K/ooOjTTOI6DUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5sqqMURNcSQyqcWJYEHQPbXnS9Fe2c37cXrYk2JshVjHbvvfej7xblH11pZd0ze7
	 A8mcCuje6CuVaqKk3rwSPJB90JiZIUSgzXzMJ/ukdNIyUAF+RNtaS5zRqdZRP8wDWe
	 TNQR4Tkn7h5bI2W9JhIzebLolq56F3MZXK5yaA8WbVInsFJu/gzwVtX+i1I84Fowl+
	 uk8+sOLbt11SCtRRFGTakV15CP0nXmCfQyUKrncvWztHcYceZd3ZL7GhYAmo6aIfny
	 fNVaYMVDfcwGjurXu9idXd70+psQO4EkZobcGQCA8i5vQLazKod5xIud0LW4VoeySv
	 BdFfivQfDjwDg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBC766031B;
	Thu, 12 Jun 2025 21:18:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749755912;
	bh=PrOq2nhzyVMBjxPT71BLqQY5xSmN1K/ooOjTTOI6DUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZM/Z45RNwIx9WRO07l/zIP9aPo4rtSBSnIrs7oXdaBddgDgpbRP/wBvI7Qu1M5+Xq
	 aKg4fdwseWlUPjWcsgKrGxZQe586+Egs2q2bMV4eXuT3tZispyXhf+1sJTWFZJpK/d
	 E3G7/buCb6x3t648aUmMl0VPjkLZX3I8Bdp+JOf/z1kCgqKTCmaWSzXylGd7P571Wp
	 d4Z4tf9Z9EYiRCAfvPxGR6gBv9Fa6MKz3+VL0TimTMEkhBKhr1rSD+WMJaSndMDT4E
	 TeSfQR0Qkslphe9gjMfgiWoXMnqa/kXMKBsL0cK0UdYYaqe8mm8FLJcVuV2VVllevw
	 fwn9uv4u4v60g==
Date: Thu, 12 Jun 2025 21:18:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aEsoBdN0IEMPQC4_@calendula>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
 <aDZaAl1r0iWkAePn@strlen.de>
 <aEd8Nfv5Zce1p0FD@calendula>
 <aEfKRbJehyaq1p8S@strlen.de>
 <aEf_LPJT1cFjYknu@calendula>
 <952e3323-8dcb-4275-888a-15909b5c72f4@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <952e3323-8dcb-4275-888a-15909b5c72f4@suse.de>

On Thu, Jun 12, 2025 at 03:01:44PM +0200, Fernando Fernandez Mancera wrote:
> 
> 
> On 6/10/25 11:47 AM, Pablo Neira Ayuso wrote:
> > On Tue, Jun 10, 2025 at 08:01:41AM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > Hmm, this looks like the API leaks internal data layout from nftables to
> > > > > libnftnl and vice versa?  IMO thats a non-starter, sorry.
> > > > > 
> > > > > I see that options are essentially unlimited values, so perhaps nftables
> > > > > should build the netlink blob(s) directly, similar to nftnl_udata()?
> > > > > 
> > > > > Pablo, any better idea?
> > > > 
> > > > Maybe this API for tunnel options are proposed in this patch?
> > > 
> > > Looks good, thanks Pablo!
> > > 
> > > > Consider this a sketch/proposal, this is compiled tested only.
> > > > 
> > > > struct obj_ops also needs a .free interface to release the tunnel
> > > > options object.
> > > 
> > > nftnl_tunnel_opts_set() seems to be useable for erspan and vxlan.
> > > 
> > > Do you have a suggestion for the geneve case where 'infinite' options
> > > get added?
> > > 
> > > Maybe add nftnl_tunnel_opts_append() ? Or nftnl_tunnel_opts_add(), so
> > > api user can push multiple option objects to a tunnel, similar to how
> > > rules get added to chains?
> > 
> > nftnl_tunnel_opts_add() sounds good.
> > 
> > It should be possible to replace nftnl_tunnel_opts_set() by
> > nftnl_tunnel_opts_add(), then a single function for this purpose is
> > provided. As for vxlan and erpan, allow only one single call to
> > nftnl_tunnel_opts_add().
> > 
> > See attachment, compile tested only.
> > 
> 
> This looks good to me. Let me include it on my series and extend the free
> interface.

Sure, go ahead, thanks.
