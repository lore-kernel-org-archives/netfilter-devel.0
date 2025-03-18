Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23A20FAAB;
	Tue, 18 Mar 2025 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328850; cv=none; b=CwNIDdQJl4zJnxnrH54tzrRxDyJcJBagEnPcW0ssyGZsW34uGlCJ7HlS1sHbarCiyo2lj5aluSOB2QrOskNvXa0qHQrvFUdIXgueNIghkYNs/nSLUXho1rv7SF0qTPzGEMSrc0tZv+sXM3VHRuMHSBtzny3c0gF9MK6TP1VI54k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328850; c=relaxed/simple;
	bh=sOR3ILGnU0s3k+wPH2xKjH4UB7SzLYV9vaR877gPDC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3R7JcJBkGlMAmWXW9yAunj7QcrB7euy1VG34d5w4racxjs+H25fElPP0ioq8kQXeZ5PhGvhf9c17EtHCZxEFiJd8uuXMsjTDRrELizvawjkSLYYaOQsXksmthWXAVsJ36qZHAE4SFsGthNSdBMjTRMZq+fp/BcNaVISuEFmSfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tudK3-0000dC-PI; Tue, 18 Mar 2025 21:13:59 +0100
Date: Tue, 18 Mar 2025 21:13:59 +0100
From: Florian Westphal <fw@strlen.de>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: xtables: Use strscpy() instead of
 strscpy_pad()
Message-ID: <20250318201359.GC840@breakpoint.cc>
References: <20250318185519.107323-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318185519.107323-2-thorsten.blum@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Thorsten Blum <thorsten.blum@linux.dev> wrote:
> kzalloc() already zero-initializes the destination buffer, making
> strscpy() sufficient for safely copying the name. The additional NUL-
> padding performed by strscpy_pad() is unnecessary.
> 
> The size parameter is optional, and strscpy() automatically determines
> the size of the destination buffer using sizeof() if the argument is
> omitted. This makes the explicit sizeof() call unnecessary; remove it.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Florian Westphal <fw@strlen.de>
