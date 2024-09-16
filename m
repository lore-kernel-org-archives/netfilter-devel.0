Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A0B2D627;
	Mon, 16 Sep 2024 07:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726471928; cv=none; b=OCit58+O9aYoQ9GySKzXsNRRd38BNI+BWG2cOUprvFBisQMsrMtxAgPePnGeTjQjxmZQzlBFPd43lmykGdTJJIar3b+cuFjX5zYZii3e3W1cil21KbsB9+hHL1pycovGQpbYugeupWK0G3/TkRZOQtKDSPYwyB6JOIkwclfFCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726471928; c=relaxed/simple;
	bh=rawwK73KHc+Hi4MZM8n0Sa9rcbQdT3NEsFA0l6DTseE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sh7Xnv8ZJPmayqP1467pDPJleRf16pkWcd/JPoCKng04PUf6+tkX2UbT+Yz6OadsGRGFgKZHWIa9vMGhnrZaNe8RiFABbLtHZXHAPS+yV/qhDMgojiM4pp5NX7mNGMwKVxijFczYIggbyjAHLR/Ls3yazGE0qXWU+yWggGxK5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQSvmJtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQSvmJtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D447C4CECD;
	Mon, 16 Sep 2024 07:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726471927;
	bh=rawwK73KHc+Hi4MZM8n0Sa9rcbQdT3NEsFA0l6DTseE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IQSvmJtXjehuA2jjX3qvcicIwhLgMnYqCl7I7rnBlog4aOWSufBy4l46xx6zofryF
	 R2n1E7NKwEYF99xQC3kJrG1eFa4ZWEYvusKHMk8FgeP7BKUXkr/NuOqGJkhPM4AAeQ
	 QHXvKIzlFo+nOk7mN4WFs+G8WNDLP+ISNh1ew8t1hF2xqfsUoZclfTc+MnR/HDYiil
	 K8ET215/Tl/PGv0cJcC7D4ZoVcU7bm7dZOgzjsFJ9Rlc/Nb4PKomXXbeTkGuPqCi7i
	 B7yhfhg0Cozm+uOuOTDSkud2qjZSWbIBin2+HHnIsyCJ4PF7/SK8sT3xzyRij1uhPN
	 J80nJjHBqGmPQ==
Date: Mon, 16 Sep 2024 08:32:01 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when
 CONFIG_BRIDGE_NETFILTER=n
Message-ID: <20240916073201.GF167971@kernel.org>
References: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
 <20240907134837.GP2097826@kernel.org>
 <ZudP-mkhquCJJPXv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZudP-mkhquCJJPXv@calendula>

On Sun, Sep 15, 2024 at 11:22:02PM +0200, Pablo Neira Ayuso wrote:
> Hi Simon,
> 
> This proposed update to address this compile time warning LGTM.
> 
> Would you submit it?

Hi Pablo,

Yes, it is on my todo list for today.
Sorry for not getting to it sooner.

I plan to post a patch for this to nf-next.
But let me know if you prefer a patch for nf, net,
or some other course of action.
