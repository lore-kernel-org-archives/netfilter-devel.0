Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C69312832;
	Mon, 22 Dec 2025 11:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766402568; cv=none; b=mXPY2KYMXpKMeOXwVZPpJVHk6vbI8Zp1m/1z3xJmzqKzL8wIU6wtoGViXyIgAU0Kmv5ds273gjFOdMbzuJ3/KNHRRjgF+GBdf2lbX7BT9atLMcwrEzcZ09aALFhjbV/WgwEIh4iuxoX28Gun42/nskreJygyNSK6qZYkfipocvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766402568; c=relaxed/simple;
	bh=gyqlSYdaz6rIfPq5gTF5YTqMjNJVtGuX8pdAzsvvyJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6b82qJ6Ka4qlij6T8zgKLAaIbEUY4VwqSsav+/ZLtr4RkUWwqtxm37PcpZEb2/hIN0Zr/Qz4px2R/C60t6FVNhJ/sjxiEc5EIq9fgq3JIaqsdabvyZ8WaBmSkEaDWWXd3qMJmXcpeNzzcW5rAI8Se1P/85aQrEoerdZ2K2T2Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E593F60298; Mon, 22 Dec 2025 12:22:43 +0100 (CET)
Date: Mon, 22 Dec 2025 12:22:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Yuto Hamaguchi <Hamaguchi.Yuto@da.mitsubishielectric.co.jp>,
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack: Add allow_clash to generic
 protocol handler
Message-ID: <aUkqA6m1C74T6cvA@strlen.de>
References: <20251219115351.5662-1-Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
 <aUcBp4VuHTPqCdEt@strlen.de>
 <aUkeP0xzUcPjWwX-@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUkeP0xzUcPjWwX-@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Dec 20, 2025 at 09:05:59PM +0100, Florian Westphal wrote:
> > Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp> wrote:
> > > The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
> > >  ("netfilter: conntrack: introduce clash resolution on insertion race"),
> > > sets allow_clash=true in the UDP/UDPLITE protocol handler
> > > but does not set it in the generic protocol handler.
> > > 
> > > As a result, packets composed of connectionless protocols at each layer,
> > > such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.
> > > 
> > > To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.
> > 
> > Makes sense to me, thanks.
> 
> Would it be possible to follow a more conservative approach?
> ie. restrict this to protocols where we know clashes are possible
> such as IPIP.

I don't think there is a need to be more conservative here.

If we have to fallback to the generic tracker that means we don't have a
L4 aware tracker for the protocol, so we can always merge entries instead
of dropping them.

Whats the concern?
