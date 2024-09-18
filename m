Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705C17BB25;
	Wed, 18 Sep 2024 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726660344; cv=none; b=Nbx2KeBPP7w0p7ouzH1JHqbCL/kBTEFCSya9Y/504Yu6Zu8D5yhWO6lTWn6AAJ+km1EZufeeickQmBlbw4AZPwnrxGgWljOl0Uq45+6kJLJKO3Z49rAAUOc744Vfu/lKUfJk0we4sACjdA/tudVhRvoWABlPIYAFEBF/yoKkv/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726660344; c=relaxed/simple;
	bh=AS1gcqTHE5f8s3YJuUZa1haqIDZZeit0ifPsAvI7HXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcYcw83yEnXQSaWXpW/k/i0c0YqlYqUp35+KW/xWeGesmlgAkwmjcCQK/tVU4QLDPp6u1aVjCSQ7fC+SN/nROufsPvVknsC3RPgy5UwmQxfGDbSWQRrQ2z8k/bQX6jmnsAbhsCY+eU0ugM8x30plQ3eU834nW5ANZa0NusM6fm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36828 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqtEF-001Mkz-J8; Wed, 18 Sep 2024 13:52:17 +0200
Date: Wed, 18 Sep 2024 13:52:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
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
Message-ID: <Zuq-7kULeAMPRmFg@calendula>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
X-Spam-Score: -1.9 (-)

On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> Hi,
> 
> This short series updates conditional compilation of label helpers to:
> 
> 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
>    or not. It is safe to do so as the functions will always return 0 if
>    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
>    optimise waway the code.  Which is the desired behaviour.
> 
> 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
>    enabled.  This addresses a warning about this function being unused
>    in this case.

Patch 1)

-#ifdef CONFIG_NF_CONNTRACK_LABELS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)

Patch 2)

+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)

They both refer to ctnetlink_label_size(), #ifdef check is not
correct.

Would you mind if I collapsed these two patches before applying?

Thanks Simon.
