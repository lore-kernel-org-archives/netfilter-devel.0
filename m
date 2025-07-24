Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0D2C15B4;
	Thu, 24 Jul 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753370803; cv=none; b=qkHw6nw35dee06ipOaJKPPLr8GUD5FJc9/Yp7DeCk5+xjiOzhLAUtKBtv9tUVEnVxegt3Y3wfbuSzIqCbZX0wvrXt637YIDrJu3TF6WOQ/HE2+DqHX+K97r2OHcTQvayU2ltKJjQMcXBFr+eqw+JFOMnFI8ajno8qRCpQT259f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753370803; c=relaxed/simple;
	bh=KPoofKIu8ZQ5Tba3M7ex7oVjXffaPCWYYdd/YIvtyfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUr6CVAXo5qteLArWs93FWPNZhxD46Ji5llCELlsp9UWlRhaxPSoeekyxE1FWJqY4W0RMmB+PL64U4/oYOdkdKAnHFijF0/nbazEf1ECPn6w3d5nxGo+u5qQA/6jxFTD6pfce2BjdaFU/4xQjHqLjukSFvlYguz19UQBKK9GqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D3539602B1; Thu, 24 Jul 2025 17:26:38 +0200 (CEST)
Date: Thu, 24 Jul 2025 17:26:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Message-ID: <aIJQqacIH7jAzoEa@strlen.de>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
 <20250522091954.47067-1-xiafei_xupt@163.com>
 <aIA0kYa1oi6YPQX8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIA0kYa1oi6YPQX8@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +				net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
> > +						     net->ns.inum);
> 
> This is slightly better, but it still does not say what packet has
> been dropped, right?
> 
> Probably a similar approach to nf_tcp_log_invalid() would better here.
>
> Thus, nf_log infrastructure could be used as logging hub.
> 
> Logging the packet probably provides more context information than
> simply logging the netns inode number.

Hmm, the conntrack table is full, and packet creates a new flow.
What would logging the packet tell us what the printk message doesn't?
