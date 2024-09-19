Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B74C36134;
	Thu, 19 Sep 2024 08:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726733121; cv=none; b=oN54t+cJAlEod5+dXmQK3hXXbtV0QP6iNGt0B+Szy8IaAB420uuwZrbxZM1IsXfwBuENGAkLfta2CnwWCwEYb7HlADP21rGSXCy+c3t1OajlqHB29Cft9csh/Rcl6jDZS0NO4qqsu29iIl+4iUWhABut9KNxjJcjevYOAkhHj7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726733121; c=relaxed/simple;
	bh=J4/fauLV6t8SnFlTfOhiWZq/Z5FluaUtuMvMOJIrX2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYD4zPW7CVxatFJ65KPkeu1Xz55gH4d1x9lSqrESoV5LHd8RoWJMDAUEhE6c+vHkXcU+G880aXQetuGVgDGOFf4G8ch+Dn0qDzVbVnbL+fxZil1hXQqiTfXdBsMbPlhCvjHHqHcTKpL4/n8oQm3b3ZXNuiGgEWBi3k8Ka+p/MAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39738 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srC9x-002slU-Db; Thu, 19 Sep 2024 10:05:07 +0200
Date: Thu, 19 Sep 2024 10:05:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <ZuvbMF_1cX16GDoz@calendula>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
 <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
 <Zurjur431P7DqifB@calendula>
 <ZusHYUGYPADO1SgY@smile.fi.intel.com>
 <ZutMf_f0tQwQZFzH@calendula>
 <20240919071801.GB1044577@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240919071801.GB1044577@kernel.org>
X-Spam-Score: -1.9 (-)

On Thu, Sep 19, 2024 at 08:19:37AM +0100, Simon Horman wrote:
> On Wed, Sep 18, 2024 at 11:56:24PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 18, 2024 at 08:01:21PM +0300, Andy Shevchenko wrote:
> > > On Wed, Sep 18, 2024 at 04:29:14PM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Sep 18, 2024 at 04:55:15PM +0300, Andy Shevchenko wrote:
> > > > > On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> > > > > > On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > This short series updates conditional compilation of label helpers to:
> > > > > > > 
> > > > > > > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> > > > > > >    or not. It is safe to do so as the functions will always return 0 if
> > > > > > >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> > > > > > >    optimise waway the code.  Which is the desired behaviour.
> > > > > > > 
> > > > > > > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> > > > > > >    enabled.  This addresses a warning about this function being unused
> > > > > > >    in this case.
> > > > > > 
> > > > > > Patch 1)
> > > > > > 
> > > > > > -#ifdef CONFIG_NF_CONNTRACK_LABELS
> > > > > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > > > > 
> > > > > > Patch 2)
> > > > > > 
> > > > > > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > > > > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > > > > 
> > > > > > They both refer to ctnetlink_label_size(), #ifdef check is not
> > > > > > correct.
> > > > > 
> > > > > But the first one touches more, no?
> > > > 
> > > > Yes, it also remove a #define ctnetlink_label_size() macro in patch #1.
> > > > I am fine with this series as is.
> > > 
> > > What I meant is that the original patch 1 takes care about definitions of
> > > two functions. Not just a single one.
> > 
> > My understanding is that #ifdef CONFIG_NF_CONNTRACK_LABELS that wraps
> > ctnetlink_label_size() is not correct (patch 1), instead
> > CONFIG_NF_CONNTRACK_EVENTS should be used (patch 2).
> > 
> > Then, as a side effect this goes away (patch 1):
> > 
> > -#else
> > -#define ctnetlink_dump_labels(a, b) (0)
> > -#define ctnetlink_label_size(a)     (0)
> > -#endif
> > 
> > that is why I am proposing to coaleasce these two patches in one.
> 
> Thanks,
> 
> Just to clarify. I did think there is value in separating the two changes.
> But that was a subjective judgement on my part.
> 
> Your understanding of the overall change is correct.
> And if it is preferred to have a single patch - as seems to be the case -
> then that is fine by me.
> 
> Going forward, I'll try to remember not to split-up patches for netfilter
> so much.

Never mind too much, your splitting helps for reviewing.

This is also subjective judgement on my side.
