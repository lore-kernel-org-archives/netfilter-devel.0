Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA94192593;
	Thu, 19 Sep 2024 07:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726730383; cv=none; b=nuSkFZSdz19hrPbedooaXZtlnv9qDGB01f96ou6mmMoM9gX3zTLgZwPBGpaW5OucbAAE19fGGJOQZC79Q53sJ2KH6pY8UxycqNY7gYbRl6VFFPmKB7cT9xgcY3CaADiLyhILpUiDElRpiGjIjftL6H4TmGXqA4U2CNuwb5MxF48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726730383; c=relaxed/simple;
	bh=xgA8G3nc0J2EPhpNgAx9tM/joMRB8dT/O5HDpx8HPF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsNdRW6dLOGW9I5mUgwuB3cYMui1+FpjCVy6ZSdSzIFl4oqH296U3vXQxUZ062UgDzzVb5eQeQC+iixXpBSJILIwFLulCNJHHxhVbV4rDU37HB9WTHLzIp9dmzZJOfW7LFJqfRKj40HD2ISr2R8xinsb4udKlJU5WkoHN+AHwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dw7d2xBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dw7d2xBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A2FC4CEC4;
	Thu, 19 Sep 2024 07:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726730383;
	bh=xgA8G3nc0J2EPhpNgAx9tM/joMRB8dT/O5HDpx8HPF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dw7d2xBjuSX4iOelZBZQZmOM4JstPWpzT3oHmacEbGJDdVpncG3rVqW4PFstCQcyt
	 mjisC4T6hhcD67cXSKEc2c3vQeUUykp2fcyEpG/nZXDzWIQ5PCIwYIR4akmHrXxNY9
	 jOJmNLdCm5PWNla7dvswtFqjNSrMhYM/mItZpN86DyVW90JYepGkNVdpjGZyEGHnr7
	 HNi8kBsiGIG0a5n25/Af0HhtpqhietiCu33U+347y47kfiYfb2eSJfPWsi0vuzq6uk
	 n2xt9RTaFdjZ23zbIyx66u/VaBy5pTKBswaSuMSprYvCdH7vTG+40nF1W6119H8Mul
	 e9z9UrZjVFInA==
Date: Thu, 19 Sep 2024 08:19:37 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
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
Message-ID: <20240919071801.GB1044577@kernel.org>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
 <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
 <Zurjur431P7DqifB@calendula>
 <ZusHYUGYPADO1SgY@smile.fi.intel.com>
 <ZutMf_f0tQwQZFzH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZutMf_f0tQwQZFzH@calendula>

On Wed, Sep 18, 2024 at 11:56:24PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 18, 2024 at 08:01:21PM +0300, Andy Shevchenko wrote:
> > On Wed, Sep 18, 2024 at 04:29:14PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Sep 18, 2024 at 04:55:15PM +0300, Andy Shevchenko wrote:
> > > > On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > This short series updates conditional compilation of label helpers to:
> > > > > > 
> > > > > > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> > > > > >    or not. It is safe to do so as the functions will always return 0 if
> > > > > >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> > > > > >    optimise waway the code.  Which is the desired behaviour.
> > > > > > 
> > > > > > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> > > > > >    enabled.  This addresses a warning about this function being unused
> > > > > >    in this case.
> > > > > 
> > > > > Patch 1)
> > > > > 
> > > > > -#ifdef CONFIG_NF_CONNTRACK_LABELS
> > > > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > > > 
> > > > > Patch 2)
> > > > > 
> > > > > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > > > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > > > 
> > > > > They both refer to ctnetlink_label_size(), #ifdef check is not
> > > > > correct.
> > > > 
> > > > But the first one touches more, no?
> > > 
> > > Yes, it also remove a #define ctnetlink_label_size() macro in patch #1.
> > > I am fine with this series as is.
> > 
> > What I meant is that the original patch 1 takes care about definitions of
> > two functions. Not just a single one.
> 
> My understanding is that #ifdef CONFIG_NF_CONNTRACK_LABELS that wraps
> ctnetlink_label_size() is not correct (patch 1), instead
> CONFIG_NF_CONNTRACK_EVENTS should be used (patch 2).
> 
> Then, as a side effect this goes away (patch 1):
> 
> -#else
> -#define ctnetlink_dump_labels(a, b) (0)
> -#define ctnetlink_label_size(a)     (0)
> -#endif
> 
> that is why I am proposing to coaleasce these two patches in one.

Thanks,

Just to clarify. I did think there is value in separating the two changes.
But that was a subjective judgement on my part.

Your understanding of the overall change is correct.
And if it is preferred to have a single patch - as seems to be the case -
then that is fine by me.

Going forward, I'll try to remember not to split-up patches for netfilter
so much.

Kind regards,
Simon
