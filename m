Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817D028C5B1
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751632045; cv=none; b=dHGKPJo+lxpWdtBDNxYS6bhOeOnIDopVH1dcTpUSCTbexvNRC17065OU4LrmvaAE9+B6e1hyctRmAwYIuHhcu/6RX//4n2zux3qMiMIBeBHr2IleyonJL65oyhmHCs+7xA+TQ500pOx8uVG8icVPpoGv3MJyaRHvfit2+H8v67k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751632045; c=relaxed/simple;
	bh=vfyUtZrxNmtih5ymUKtXwAmglSdQ56LBpoyEY0XIVlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cqz7/p7QyRnS3KxgdJx8YhKfMZSSSe9xAwpracM5y54SFlvO/4fNrCPT9xfJkX+ZzXfJp79kvgldMBBJAdiB87oaCIYoLRO5uw46BVTAUC0/KwYzGIDL77DO/tI4CMcpaL16SisWJvGP4/lydiEWn9Qbz6Eo6zcM1PFh1umYFQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D5BE1604A5; Fri,  4 Jul 2025 14:27:21 +0200 (CEST)
Date: Fri, 4 Jul 2025 14:27:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft 1/3] src: make the mss and wscale fields optional for
 synproxy object
Message-ID: <aGfIqX2im5ut1WNn@strlen.de>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
 <20250704113947.676-2-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704113947.676-2-dzq.aishenghu0@gmail.com>

Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
> The mss and wscale fields is optional for synproxy statement, this patch
> to make the same behavior for synproxy object, and also makes the
> timestamp and sack-perm flags no longer order-sensitive.

Whats the use case for omitting the mss field?
It seems this should be made mandatory, no?

Also I think we should reject wscale > 14 from the parsers (can be done
in extra patch).

And also reject it in kernel by updating the nla_policy in
net/netfiler/nft_synproxy.c in the kernel.
