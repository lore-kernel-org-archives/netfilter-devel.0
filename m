Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3903F30ACE8
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418425; cv=none; b=p2W5U6EOMtifaXIrdyvQcdviZpsDFv4UbxRdOjB1xPfh4lZ+JlWLL+CKVStVTsWjYDm3z+8z9fMFgVJOfM5W2LG5V6jf9cC/ZmrS1R2qgJSeB5ce0qykAKN5y2H/HgKas6cMvQdAIYUAw1NLsz9OvdSxfnqqQB0ht+W6mRyygck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418425; c=relaxed/simple;
	bh=L99noga8wN34OMDBea3kQBSemBsVZoplncWoHkiKHGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDIcQWk0EPVKU8I1haj4DHhsI7YnXWJjf/ikDywbG8ygDz8wmeCBdmMj8VvPOkrKmNHbUDeONKspv/mbrvJ1n0mHhSxVc1I88kHdkEXa1Vd1A/3N1R9EB4xmwEscUbQmkari7tXs1HYvGegNyBezSq/gsjhkNfP031q3tNIpNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nFAtYmRM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nFAtYmRM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OhhualfRQQ74Ub0lczXcEGKUFNslZ7CEJzWfkZrw5yQ=; b=nFAtYmRMLEoBBR20Z/cB95PVeR
	UvJYP0OOpFlq28kZK4eFbcdZOPE38JVRj/LOK6BGBrgLLrP84BfDzMfJkeD+bb89Ie554PB7e/bZ8
	ZR5eiuSTPkicBNVQxESiCF7UKNbWhFxA3EcDncryEnri/s7ioSNIIEuRVZ2mUZMsheopKwX0aCtTl
	u6tA0EvPRkD7WPBFBq2Zwt2jQmyuHcsYtBhl6pbtbOBPvIfRE5N65817+qj7WwfnS+zhTbGGmbZQz
	l75xG6sBkOreOFi6GXFAK4uHikIj1p+NdJWT+xi4B/daSIa50D5N7zIZLCJcIbikKQ87np0MWF/w0
	p58a9/pA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uvwoN-000000006NR-1MDp;
	Tue, 09 Sep 2025 13:46:59 +0200
Date: Tue, 9 Sep 2025 13:46:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] monitor: Inform JSON printer when reporting an
 object delete event
Message-ID: <aMATst54n_1U8DYc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-5-phil@nwl.cc>
 <aL6wLZRvbubwsBdh@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL6wLZRvbubwsBdh@calendula>

On Mon, Sep 08, 2025 at 12:30:05PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 29, 2025 at 04:25:12PM +0200, Phil Sutter wrote:
> > Since kernel commit a1050dd07168 ("netfilter: nf_tables: Reintroduce
> > shortened deletion notifications"), type-specific data is no longer
> > dumped when notifying for a deleted object. JSON output was not aware of
> > this and tried to print bogus data.
> 
> Fixes: e70354f53e9f ("libnftables: Implement JSON output support")

A Fixes: tag is fine with me, although one could argue that output was
fine before said kernel change. I'd rather refer to 9e88aae28e9f4
("monitor: Use libnftables JSON output") instead as this introduced the
relevant code in src/monitor.c.

> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks, Phil
