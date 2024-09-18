Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309919D8B2;
	Wed, 18 Sep 2024 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726669764; cv=none; b=aP4rYe7hoxlVPXTzQVikEJHOm56guO6oFiKGRGnICO9ltrkdVtxVq5F6sceIXCUNb6sgZ1fUFAF1HtgenrWJVrrJnXuDph6f4RpbDODN3hVKCOKel7TM1pkxlXvs0MKgfmsERWT62NeCGKEHklNgVh88vHZpXY/ixSsSvrpi2YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726669764; c=relaxed/simple;
	bh=OV+BGuzKd24izlGLvFu+9XnPG8CfLYl3FdCzCe6uEq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDCp4u6fea7f2c/GNTUsvbFG2iEfIfdc76diqL2nKPT0Z/gMzNXKLDLOEa04YV0dnQyAFK1CBnf8NaNFbrXdMp5lP+JorFFGHGDmjsOjxfHvmuteFe/Bp407Fy2i073iPilZ81Pw+EVOAFdzGjRNZnZTXda/CWc8TCSVLBf046g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43820 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqvgC-001WOX-7I; Wed, 18 Sep 2024 16:29:18 +0200
Date: Wed, 18 Sep 2024 16:29:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Simon Horman <horms@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH nf-next 0/2] netfilter: conntrack: label helpers
 conditional compilation updates
Message-ID: <Zurjur431P7DqifB@calendula>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
 <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
X-Spam-Score: -1.9 (-)

On Wed, Sep 18, 2024 at 04:55:15PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > > Hi,
> > > 
> > > This short series updates conditional compilation of label helpers to:
> > > 
> > > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> > >    or not. It is safe to do so as the functions will always return 0 if
> > >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> > >    optimise waway the code.  Which is the desired behaviour.
> > > 
> > > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> > >    enabled.  This addresses a warning about this function being unused
> > >    in this case.
> > 
> > Patch 1)
> > 
> > -#ifdef CONFIG_NF_CONNTRACK_LABELS
> >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > 
> > Patch 2)
> > 
> > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > 
> > They both refer to ctnetlink_label_size(), #ifdef check is not
> > correct.
> 
> But the first one touches more, no?

Yes, it also remove a #define ctnetlink_label_size() macro in patch #1.
I am fine with this series as is.
