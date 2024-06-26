Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA23192B6E
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 23:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719445191; cv=none; b=pPb6HzuRIdtRsOcMqunGhKG6VjVI7BLQT4YGH9EE+CAWLGMOc/jKLWHm9YF6bCzT+4GN7wTBIuWUfNfH8WSLNLnrbZNjih1RHv2m6R5zaxP4twGIU8LvXFe9NX544OCOnfXltIVCow0+XTdglCCtOEearvksBg9LBn3NahuNdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719445191; c=relaxed/simple;
	bh=3qGey6uN1TyJa1bFYIxhy1R2qevK7SFhXhR+RMlH45Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBHLTtwqKv6YtdEtXiJxRHn/LsOiN+krWPFpX/q0eCMVcGCKplcluhHexFRF/EUu5cYkqi7lJlsSWH/+gHrGdRrPbt9zAaW3cpRXHMatyY21AFbBg/x5kxr0Aj3hh1chr+LO+OqISKVDlykhEP/HwS++wrzhzMV7F6GN0qOAcQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44556 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMcEq-008kAW-8i; Thu, 27 Jun 2024 01:39:46 +0200
Date: Thu, 27 Jun 2024 01:39:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org, Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH v2 1/2] netfilter: xt_recent: Reduce size of
 struct recent_entry::nstamps
Message-ID: <Znymv6czZP4M4zuc@calendula>
References: <20240614151641.28885-1-phil@nwl.cc>
 <20240614151641.28885-2-phil@nwl.cc>
 <Znw9-9hAxauzr2Ie@calendula>
 <ZnyY-j4pqHjflOnb@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnyY-j4pqHjflOnb@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Jun 27, 2024 at 12:40:58AM +0200, Phil Sutter wrote:
> On Wed, Jun 26, 2024 at 06:12:43PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, Jun 14, 2024 at 05:16:40PM +0200, Phil Sutter wrote:
> > > There is no point in this change besides presenting its possibility
> > > separate from a follow-up patch extending the size of both 'index' and
> > > 'nstamps' fields.
> > > 
> > > The value of 'nstamps' is initialized to 1 in recent_entry_init() and
> > > adjusted in recent_entry_update() to match that of 'index' if it becomes
> > > larger after being incremented. Since 'index' is of type u8, it will at
> > > max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
> > > also never exceed the value 255.
> > 
> > Series LGTM.
> 
> Thanks for your review.
> 
> > I'd suggest you collapse these two patches while keeping the
> > description above, because nstamps is shrinked here in 1/2 then it
> > gets back to original u16 in 2/2.
> 
> ACK, that was the plan right from the start. :)

Thanks, I have to admit splitting the patch in two helped me
understand a lot better when reviewing.

> > Maybe something like:
> 
> I composed a new note to add to the second patch. Please review and let
> me know if it's unclear or misleading.

LGTM, thanks
