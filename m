Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC89FA2D;
	Wed, 18 Sep 2024 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726684635; cv=none; b=cm1jwsz2xSWA9KCEirm5d56/gXX4yXWcPFB8Vrj7/fmXo0nub9sfgDxhf/rb47PBLrvtIfC09Qr5hBYHqvSR7X5WdZtQkcLOjvICwDJXVj4UOhxNFNOE/hPlyK2PAZPyXVDJizpyvCGqIGQJbW1hKBwlCxMfZaY4uz662h9w+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726684635; c=relaxed/simple;
	bh=vHAKeMZriZJd1KYaL8J6jKhxsVaMeJ0wXYKgXB+ExEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzcmCm1efEoHFXOjWLpkdeoGYtSMQJz1QPNoFiKpCw5bxjjU37doOXv7oauxhXrNH02NO0aEI+kTLPZkTbNXjQuz24PajCdbL1fJoQYD33udm6cTwD1W2uMj49n8qFbJUtP7RTRIvr25qDYRAYWJgGaIC0KpC38qtOmwnrpjwjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obR71EGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obR71EGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B41C4CEC2;
	Wed, 18 Sep 2024 18:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726684634;
	bh=vHAKeMZriZJd1KYaL8J6jKhxsVaMeJ0wXYKgXB+ExEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obR71EGDoYPGQCBIs0oypyXpZSDKuS+sPw8E7gGHD9DZ9NqqJcD6+nHUFRJTHJpbt
	 Bs+M698kLfMeryZjehN4qUVXVJevBMyyUMULHFJXBo9BOLmfnVdXhAFGBu8c+0KBH8
	 CwrTQGzHgWCbYX4GctbOFsAzLehwXzLAVZ7VrzNhRugTsvkg3qe5mO6Sm3ki/Q/7vf
	 jgD3KDBQnBgDbIJ+1/ST9/c7rHXs08EHZcBHrzk8VpIIWaxhtKjioSw44SFnkRrzha
	 pV3wt0lyPA/5R2KAPGDlpkxbxJ1oGajS8HiPkkGaq8ZlXL843QP91Dkigvhaa3ceya
	 DqA5eoHgvtDXA==
Date: Wed, 18 Sep 2024 19:37:08 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <20240918183708.GA1044577@kernel.org>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuq-7kULeAMPRmFg@calendula>

On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > Hi,
> > 
> > This short series updates conditional compilation of label helpers to:
> > 
> > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> >    or not. It is safe to do so as the functions will always return 0 if
> >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> >    optimise waway the code.  Which is the desired behaviour.
> > 
> > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> >    enabled.  This addresses a warning about this function being unused
> >    in this case.
> 
> Patch 1)
> 
> -#ifdef CONFIG_NF_CONNTRACK_LABELS
>  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> 
> Patch 2)
> 
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
>  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> 
> They both refer to ctnetlink_label_size(), #ifdef check is not
> correct.
> 
> Would you mind if I collapsed these two patches before applying?

Sure, no problem.
