Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C593E143757
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710282246; cv=none; b=mvETYNArSCvAXrgQ5JfmgtPl44+D1a+3sDu/sE5jXD7GLSgfSx5OMHWyHlO+ZOhiAFUPYaIsCtCjkvydL5/crdK3nWlezDxBuaWaAulfTNWQ/XrpA5PVD1Qr+uNn/p+6eytC/4hSSPXUyjGFQf8vbjIFAyvXv3Qu5epRCdxKZ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710282246; c=relaxed/simple;
	bh=Adj2SddylpyVvw6ntypCENiTMzQRaAarc51rViXTGpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoWU63mVHyQLBik2BwBon1Vir9d70HP45BdtqUeM4+3Ad/CljSiDJ1ZkIzN6bsNRxgFu4n9ircZ78Ff4xvP1TP8VgtgMJkDqhjv0DIoLQegzaOXKyBexIXYYbqoUIQip4KzxZe7TmjITXHGDviyMPvxcYoBN1UIhZVpEPnTyw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 12 Mar 2024 23:23:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Quan Tian <tianquan23@gmail.com>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfDV_AedKO-Si4-_@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
 <20240312143300.GF1529@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240312143300.GF1529@breakpoint.cc>

On Tue, Mar 12, 2024 at 03:33:00PM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> > In nf_tables_commit():
> > The 1st trans swaps old udata with 1st new udata;
> > The 2nd trans swaps 1st new udata with 2nd new udata.
> > 
> > In nft_commit_release():
> > The 1st trans frees old udata;
> > The 2nd trans frees 1st new udata.
> > 
> > So multiple udata requests in a batch could work?
> 
> Yes, it could work indeed but we got bitten by
> subtle bugs with back-to-back updates.

yes, we have seen subtle bugs recently. As for the table flags, the
dormant flag has been particularly a problem, it is tricky one because
it registers hooks from preparation step (which might fail) but it
cannot register hooks because abort path might need undo things, and
re-register the hooks could lead to failures from a later path which
does not admit failures. For the dormant flag, another possibility
would be to handle this from the core, so there is no need to register
and unregister hooks, instead simply set them as inactive.

The dormant flag use case is rather corner case, but hardware offload
will require sooner or later a mode to run in _hardware mode only_
(currently it is both hardware and software for nftables) and
considering the hardware offload API has been designed for packet
classifiers from the late 90s (that is, very strictly express your
policy in a linear ruleset) that means dropping packets early is fine,
but wanted traffic gets evaluated in a linear list.

> If there is a simple way to detect and reject
> this then I believe its better to disallow it.

That requires to iterate over the list of transaction, or add some
kind of flag to reject this.

> Unless you come up with a use-case where such back-to-back
> udate updates make sense of course.

I don't have a use-case for this table userdata myself, this is
currently only used to store comments by userspace, why someone would
be willing to update such comment associated to a table, I don't know.

I would like to know if there are plans to submit similar patches for
other objects. As for sets, this needs to be careful because userdata
contains the set description.
