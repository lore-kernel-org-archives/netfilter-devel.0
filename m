Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9821448EF
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 11:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712833510; cv=none; b=CIGEZoaUDR6XP06/6W4qTg/SfuRkuwvEqVBo/DyeSONmCVOQqVulNdHAVuqfDS4gsYw6LLq5zaklinlc1ocflAXHo7w0xTw82ADYLb79caYciY5pegCAOI888uF1l7OaS5RM1Yy562ZZnLC3HiGyFIZRipsVU1C3FS5JmJubkYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712833510; c=relaxed/simple;
	bh=/BbgFmRIVBwF+INOMP8vq3X6QcYBSw6veYSIUq8J9nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDregX+RiwSu5G8rF5jksj0438AYZ/JItg+zXOQHieJCaQmcPtmx9YRbCfvxE1fSXM8pN8QZoCEfFc8F+rw35gN1tvezohK2HN9cSROHmVZnytqLnam/nTVbV33KnxTYhdXvzZISNpWcue5sFe8UVA6iB+TGG+gNgjK1rA2xTw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rusEq-00041v-Mb; Thu, 11 Apr 2024 13:05:04 +0200
Date: Thu, 11 Apr 2024 13:05:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <20240411110504.GE18399@breakpoint.cc>
References: <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
 <ZhetEIvz_vCB-A5D@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhetEIvz_vCB-A5D@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I can also see IP_CT_TCP_FLAG_CLOSE_INIT is not set on when ct->state
> is adjusted to _FIN_WAIT state in the fixup routine.

Unrelated to this patch, but I think that there is an increasing and
disturbing amount of code that attempts to 'fix' the ct state.

I don't think its right and I intend to remove all of these "fixups"
of the conntrack state from flowtable infra.

I see no reason whatsoever why we need to do this, fin can be passed up
to conntrack and conntrack can and should handle this without any extra
mucking with the nf_conn state fields from flowtable infra.

The only cases where I see why we need to take action from
flowtable layer are:

1. timeout extensions of nf_conn from gc worker to prevent eviction
2. removal of the flowtable entry on RST reception. Don't see why that
   needs state fixup of nf_conn.
3. removal of the flowtable entry on hard failure of
   output routines, e.g. because route is stale.
   Don't see why that needs any nf_conn changes either.

My impression is that all these conditionals paper over some other
bugs, for example gc_worker extending timeout is racing with the
datapath, this needs to be fixed first.

I plan to work on this after the selftest fixups.
