Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702131CF96;
	Mon, 16 Sep 2024 15:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726499835; cv=none; b=K1pfPrrsPpYvqCEWRsgj2MPhpzTi6DBmymJ2AX8pFT3S6QwTcKm0MFkjkwlReCAV2yYxGx8MVOpgXIdX5xU8c/z3nWHUJMBb6OOFd9GxgUKdCtVqXokJYYksXjoRKZ/+CXN+8yXeoGl1Vjk7K0SMDJaICsFZsHx1PHVVew2VBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726499835; c=relaxed/simple;
	bh=Txos53pr9kE2IW0nRmQNNcz3mfPHCrcGkTRcAyiWRcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Unf5BKmWCUA+Ne1tpBxqTFshfnlgOgAbEbDdK1+gAXG+W2wMDPlwpBS4IqG9wzH/UnQJ53+xChilExIMoFYk1ZQpg4CwO7bHINKG79NePMwXwmPPhaMT0F16I+8AVfjCJUtLDWRoHsfuoYAHysycFft1ugyJBFOZ4odPJ2GN1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7e/1De9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7e/1De9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F8FC4CEC4;
	Mon, 16 Sep 2024 15:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726499835;
	bh=Txos53pr9kE2IW0nRmQNNcz3mfPHCrcGkTRcAyiWRcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t7e/1De98VNxJR837qITwW4ItAVFGPYHwxe6UyjVUKlUfyGkIpMngPdz4AaTBhUyp
	 ADTt8UJCYPVEkrc08tttOOZbSQeva8aCQjVwyvEarbjjL0egjDad6wjyV1/jPJOMfC
	 9PL5ZIj4B/Q1LmxPjqUX8ZLpoTYovcbQB0sZZRnUehHqybUXErHq6e+M5nWJsNClh0
	 0iMCJqgwfV2qWvtjr19bE8VtnnetRcQu9o5CLOAvldj31krDUE2ISkdWS2YGzp11gZ
	 p3HZBtmvpOeM1aQadmgvMdlJsMylKxUqyLRHw+6CmHDJAj4/OAZdStnA7FXC1nV01S
	 TsHgAABn1PG2A==
Date: Mon, 16 Sep 2024 16:17:09 +0100
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
Message-ID: <20240916151709.GA396300@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
 <20240909151712.GZ2097826@kernel.org>
 <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>
 <20240909183043.GE2097826@kernel.org>
 <Zt__ZT-P0kUY909z@smile.fi.intel.com>
 <20240910094520.GB572255@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910094520.GB572255@kernel.org>

On Tue, Sep 10, 2024 at 10:45:20AM +0100, Simon Horman wrote:
> On Tue, Sep 10, 2024 at 11:12:21AM +0300, Andy Shevchenko wrote:
> > On Mon, Sep 09, 2024 at 07:30:43PM +0100, Simon Horman wrote:
> > > On Mon, Sep 09, 2024 at 06:36:07PM +0300, Andy Shevchenko wrote:
> > > > On Mon, Sep 09, 2024 at 04:17:12PM +0100, Simon Horman wrote:
> > > > > On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> > > > > > On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > > > > > > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > > > > > 
> > > > > > > Local testing seems to show that the warning is still emitted
> > > > > > > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> > > > 
> > > > Hold on, this is not related to the patch.
> > > > It might be another issue.
> > > 
> > > Yes, sorry, I see that now too.
> > > 
> > > Perhaps it can be fixed separately, something like this:
> > 
> > If you make a patch, it will help somebody who has that in their configuration
> > files enabled (with the other one being disabled). Note, I use x86_64_defconfig
> > which doesn't have this specific issue to be occurred.
> 
> Thanks, I'll plan to submit a patch.

The patch grew into two, I've posted them here:

- [PATCH nf-next 0/2] netfilter: conntrack: label helpers conditional compilation updates
  https://lore.kernel.org/netfilter-devel/20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org/

