Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF296156875;
	Wed, 28 Aug 2024 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724881910; cv=none; b=Opl+FsuSZ/boqcCpaoYG+gVl1+JGfE28lKB6UORqi+kPlB38AUz9cHe0U+bhylmDzVRPjOncS2uPg0HlpcV5W+Yd9Rrs1L0/Y75CkNUGwujvx7n8yQDLQddeYajDV0EhUwwmkrSnXZAWx0/8HG27JxCctUKGTxjcJgfb4N1reGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724881910; c=relaxed/simple;
	bh=IHJYq1DKkxhXEmjUeagdG1I0bFvT8KS8Bk135eKr5dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGv1s/XrpFrTYJLmpEChweWPzz0BnDiUqEgT5FLxX6EA08jkDTYrGmOET+RYxGYzdbUUYfmgaWMIKBW26HoQjA/Re2WkBFSu/HgBJfkxiEXSXiEh1NG24/+CRjs+L/f1aq32kQ2QaLDfrnhO5lHrcmPBN741Qn/TlWdfKLXHH9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51254 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjQZi-0023bS-Ob; Wed, 28 Aug 2024 23:51:37 +0200
Date: Wed, 28 Aug 2024 23:51:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add __percpu annotation to *stats
 pointer in nf_tables_updchain()
Message-ID: <Zs-b5dih9hqH1WSV@calendula>
References: <20240806102808.804619-1-ubizjak@gmail.com>
 <Zs8564GQ2c486JVR@calendula>
 <CAFULd4Y8tCUNHJ9vVPKch0sMj31LnF8bVtJRTez5tBV9p5509w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4Y8tCUNHJ9vVPKch0sMj31LnF8bVtJRTez5tBV9p5509w@mail.gmail.com>
X-Spam-Score: -1.8 (-)

On Wed, Aug 28, 2024 at 09:29:14PM +0200, Uros Bizjak wrote:
> On Wed, Aug 28, 2024 at 4:53 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Tue, Aug 06, 2024 at 12:26:58PM +0200, Uros Bizjak wrote:
> > > Compiling nf_tables_api.c results in several sparse warnings:
> > >
> > > nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
> > > nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
> > > nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)
> > >
> > > Add __percpu annotation to *stats pointer to fix these warnings.
> > >
> > > Found by GCC's named address space checks.
> > >
> > > There were no changes in the resulting object files.
> >
> > I never replied to this.
> >
> > I can see this is getting things better, but still more sparse
> > warnings show up related tho nft_stats. I'd prefer those are fixed at
> > ones, would you give it a look?
> 
> Yes, I have a follow-up patch that also fixes the remaining warnings,
> but it depends on a patch [1] that is on the way to mainline through
> the mm tree.
> 
> I can post the complete patch that uses percpu variants of ERR_PTR,
> IS_ERR and PTR_ERR where needed if this dependency can temporarily be
> tolerated.
> 
> [1] https://lore.kernel.org/lkml/20240818210235.33481-1-ubizjak@gmail.com/

Thanks for explaining.

Post the patch to netfilter-devel@vger.kernel.org explaining the
dependency so it sits there and I remember about it while it gets
upstream.

If there is any issue and this patch does not reach mm tree, let me
know.

Thanks
