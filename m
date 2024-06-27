Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80BA17F8
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 00:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719446774; cv=none; b=qfAYGHSDog5Q3CWSp0+zE13G3trfl8g8icBJPBFsWfdrmdLe1Cf1U0pL1PJ1h1Q5IoeZ7IelyHrCI/HdaES6G1s0EP6esv4eK8RfbxNPy/YsfG/cUp33Q0B8XHc9waXKExJVUugyQXBo1pqDi5aYoIERQ60IMxqS2C9l3cvMp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719446774; c=relaxed/simple;
	bh=TC05Rdd9SgEkhowh2mB2qtCmkOxwi6HZz7MOhWj0+a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIs/w9Pos8/eo42ehAz5PYrfiNQwExXE0UYI1B4M6HroMD6TkEEbjHqKYpyFe5/qd6WHKfwPKXbqYHMzg5dF4lQyleTWi2u974a0G/Y6nB/Emsft+QUj1hXUHS1gQLS7zucnJaRIzatRK9qjiM2dL5RkrI22XYFokeLy04EdkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bUe55i+z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bUe55i+z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZcuO77HTGWXpP7fR+Z+cMxKBnuQ4T87YFnztuwwMSuQ=; b=bUe55i+zJfP/NhnXJsydt1xObN
	KbYGvfhPUPR7mqlfQg6PpjtKwpgJvQc7F2aCiiG6jLiEMRvrRKDXeKJseaKdWA5Bh0E93/5x9wXbg
	YVZu7/A98/XEsLUSvWYEu1j6PTc0u6sdptfbrBp1LkWiAiU6hYEMwgNDGZFDaSVLap/CxWwXsp40N
	KSjmMjGEF7OCGkPbnM6j/QM0K2/8DiOqukd3un4rQe97gqqAFr4J8TMCDYLZCVodmxv4UTEBMNQyE
	eucVfTLOhlqyqZHbBnL5XBL79vYdA4+Hphzg9Y8qxTeoWHh3PNnsJMAKuQwQ/0r5eogqMbMVxTxht
	4fl5ZaCQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMceP-000000003Ez-1pAA;
	Thu, 27 Jun 2024 02:06:09 +0200
Date: Thu, 27 Jun 2024 02:06:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH v2 1/2] netfilter: xt_recent: Reduce size of
 struct recent_entry::nstamps
Message-ID: <Znys8VUURMRnUfxd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
References: <20240614151641.28885-1-phil@nwl.cc>
 <20240614151641.28885-2-phil@nwl.cc>
 <Znw9-9hAxauzr2Ie@calendula>
 <ZnyY-j4pqHjflOnb@orbyte.nwl.cc>
 <Znymv6czZP4M4zuc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znymv6czZP4M4zuc@calendula>

On Thu, Jun 27, 2024 at 01:39:43AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 27, 2024 at 12:40:58AM +0200, Phil Sutter wrote:
> > On Wed, Jun 26, 2024 at 06:12:43PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Fri, Jun 14, 2024 at 05:16:40PM +0200, Phil Sutter wrote:
> > > > There is no point in this change besides presenting its possibility
> > > > separate from a follow-up patch extending the size of both 'index' and
> > > > 'nstamps' fields.
> > > > 
> > > > The value of 'nstamps' is initialized to 1 in recent_entry_init() and
> > > > adjusted in recent_entry_update() to match that of 'index' if it becomes
> > > > larger after being incremented. Since 'index' is of type u8, it will at
> > > > max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
> > > > also never exceed the value 255.
> > > 
> > > Series LGTM.
> > 
> > Thanks for your review.
> > 
> > > I'd suggest you collapse these two patches while keeping the
> > > description above, because nstamps is shrinked here in 1/2 then it
> > > gets back to original u16 in 2/2.
> > 
> > ACK, that was the plan right from the start. :)
> 
> Thanks, I have to admit splitting the patch in two helped me
> understand a lot better when reviewing.

Cool! When restructuring patches for netfilter, I noticed a few times
how I suddenly was able to split things into surprisingly small sets
of changes which were much easier to explain in the commit message. So
we both benefit from this practice. :)

Cheers, Phil
