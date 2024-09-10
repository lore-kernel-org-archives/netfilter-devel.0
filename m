Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F791922DC;
	Tue, 10 Sep 2024 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961528; cv=none; b=ToStFUZpGgmErQKN2Xz2NYx8xnWeILqN76w7T+Rfq2a69AU+ws5zJ3zEOYxif6EVVEeSj7E1jBTlwaqA7QI9stH+7B5djz4XNM6aT+rNq0UjIjFf3/YUmnB6IdWLdHcqnO6jmKKSZI/miD11AqLue2SjmA2tKsROd9/pX94JGjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961528; c=relaxed/simple;
	bh=mUwcbGf/PrVLiBb/CZMhJO26havoL/aQzBE+UZNQRSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9okCNXzvbqysrPzmAYqJjdaRD2p1eDsdCqRTBK7NOfNatFOwIJcNWGNrGDYZtzY1xoFd92ntS3VUPgfZFfpYlJ01XCk3awHfZGzx4JNvRL7zRTAM5VRbPdKKr4PB76NffXuJMuBnOvgCF9rSa/IgqPcoTaSEvRTvA4vFZK0m6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahSwlzOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahSwlzOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EBFC4CEC3;
	Tue, 10 Sep 2024 09:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725961527;
	bh=mUwcbGf/PrVLiBb/CZMhJO26havoL/aQzBE+UZNQRSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ahSwlzOOWVOaP5Aoy0ZJcmx9+6f4az5fmllN7YayFCAU32zZllqfMTyYu9U3ScDMT
	 81wsX67+mkAqRMSko5uRChz2/bShvt1mB9P5H15S5eghFp5pNh3RAYz+D4i1jTZVw/
	 dSdXpbKD96f378NlRFm3EQjpJMAjTSGGMOhjamI7MJ8p6ut/1zlJ2zJJzqpS8HLeKz
	 /dUvLQBG4ln17ZEbtG++d/R1iIpwNOhjKhEbLH8rQqC5QburdbYSaP5F6sCidGa3e9
	 iaH6gzE9CX8VWShZT9nKl5EW4v2zEszrX8j41NHvgC7bPzX2f9679fg9l9AVvm1v4F
	 eOetchbKBdKQg==
Date: Tue, 10 Sep 2024 10:45:20 +0100
From: Simon Horman <horms@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused
 functions
Message-ID: <20240910094520.GB572255@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
 <20240909151712.GZ2097826@kernel.org>
 <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>
 <20240909183043.GE2097826@kernel.org>
 <Zt__ZT-P0kUY909z@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zt__ZT-P0kUY909z@smile.fi.intel.com>

On Tue, Sep 10, 2024 at 11:12:21AM +0300, Andy Shevchenko wrote:
> On Mon, Sep 09, 2024 at 07:30:43PM +0100, Simon Horman wrote:
> > On Mon, Sep 09, 2024 at 06:36:07PM +0300, Andy Shevchenko wrote:
> > > On Mon, Sep 09, 2024 at 04:17:12PM +0100, Simon Horman wrote:
> > > > On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> > > > > On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > > > > > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > > > > 
> > > > > > Local testing seems to show that the warning is still emitted
> > > > > > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> > > 
> > > Hold on, this is not related to the patch.
> > > It might be another issue.
> > 
> > Yes, sorry, I see that now too.
> > 
> > Perhaps it can be fixed separately, something like this:
> 
> If you make a patch, it will help somebody who has that in their configuration
> files enabled (with the other one being disabled). Note, I use x86_64_defconfig
> which doesn't have this specific issue to be occurred.

Thanks, I'll plan to submit a patch.
