Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332B12FFFA4
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774561795; cv=none; b=elyvwuKZx/aF2d0+O8kSpnSOcTXvmIWHo2qD7XYtO03ADxqh5PzgVldc6HtOLCPJm07upT4B2dQ2/kyqYkZ0GoW6qs9Spydkdi6PzXzdBXOo35Vz58fHuKTLrE3AKJKhAnVsP90mnJbCpqQGbtrPuAZWMvXLWd2Mfq/OOAlzXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774561795; c=relaxed/simple;
	bh=XoZBdsERT/9UIca3qb0ZwBhaKEe6m8oSB08aD3Vt1ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUz70USsCscIhkw2G/dZ+uDfCOfu7M1bPs8/bEltnKUXO8PeoO6af9auJp1x5cFV7noKQ+A2RT8All+nsMdQOKrzvqkbCej/cdcXoTbpUpi8GFarh5TkpZsRlgfcJPQz41Z+m2ALdAGYn/lc+o8cq+37b2NiLYhdbPbC+ikgLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UtkIrd84; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UtkIrd84"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DF890600B5;
	Thu, 26 Mar 2026 22:49:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774561790;
	bh=ZjL3l2xJ2jUBKp4CxO7jPABE4lAjECANivTqF2jjdbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UtkIrd84Q86TXZpu709y1ZDo8CsF2lz1haJGyNwGP4FuEYLqrA3p9LMLVD5flAFzZ
	 +RV145FnBwzSTMIXYrIC9YWykagfBnBuAv9m9qpoRpN5z067sN3J6gRIZrAw4wW72H
	 1Dfodvtg0JpjzzVT33S3mlWkJ5cLBNcGhCgBDuU7hjUkBNJIbzjpA7Iq/DtS0k2Suj
	 zrGNjho410xYtQ7BTnysYQgsu+2vV+KbkVwFsRV2b3ep6fxq6kwzRSIkdvgzJZsj28
	 XxKAb24XZ6Q26ewDXYj+5kTTyA5nehgwnop3VPlGEVDWfyrhPY07xxhpNbnO2uPFAM
	 fMQBVRWCST2og==
Date: Thu, 26 Mar 2026 22:49:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: reject requests exceeding
 NF_FLOW_RULE_ACTION_MAX actions
Message-ID: <acWp-3wao3d7MNNK@chamomile>
References: <20260325164130.29060-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260325164130.29060-1-fw@strlen.de>

On Wed, Mar 25, 2026 at 05:41:27PM +0100, Florian Westphal wrote:
> nf_flow_offload_rule_alloc() allocates space for NF_FLOW_RULE_ACTION_MAX
> entries.  Make sure userspace passes more entries to us.

While the flowtable hardware offload uses a fixed maximum number of
actions NF_FLOW_RULE_ACTION_MAX for simplicity.

But nf_tables hardware offload allocates the number of actions
dynamically from nft_flow_rule_create(), such function iterates to
check if there is .offload_action is true, the increments the array of
actions by one for each.

Possible actions (note payload mangling is currently not supported
in nf_tables hardware offload).

This is fragile, because advancing the action array is opencoded:

        entry = &flow->rule->action.entries[ctx->num_actions++];

I can make a patch for nf-next to add a helper, but I don't see any
issue on nf_tables_offload at this stage. There are three actions only
and they add one single entry to the array.

As for the flowtable hardware offload (different infrastructure)
I proposed a different approach:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260326200935.729750-1-pablo@netfilter.org/
