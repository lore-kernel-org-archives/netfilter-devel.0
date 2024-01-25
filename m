Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857AC1B948;
	Thu, 25 Jan 2024 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706172738; cv=none; b=tFCXsypiXjrW2HnPUwjb/DBgBOXgWr+Tk9835AXENwsL478I4aJfqi9CB8bv8NmR+MLI80pLIrkdFbrA7x28mE3TsKJkBXc0yCRQvnWXcygvIv7nEdqGIllz3ap8Q4PFB3BhWVAENHDRs+a3u1oBCss+V19vwvsOKXxZNMXy610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706172738; c=relaxed/simple;
	bh=TRrpOceO1ObHuQDpipuLsskP8G7fTPallXu16th2v2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTzAJjq/BkCq8mBy+763jvJOnuVLjbr2Z+Wtg4caSvKMz6E8xwz0ACDIunw8szJUine7RT0hpg2jXvvXtoOSbPb/xKQKPKdTwlEeZsiBJ3WHv/wh/Vc9diwZbWTqDR+tyET7yd5ItcV1D2cCfHCDvV94mNdStwIabJvUifAGz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rSvT1-0006uz-Mm; Thu, 25 Jan 2024 09:52:11 +0100
Date: Thu, 25 Jan 2024 09:52:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	David Ahern <dsahern@kernel.org>, coreteam@netfilter.org,
	"netdev-driver-reviewers@vger.kernel.org" <netdev-driver-reviewers@vger.kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240125085211.GE31645@breakpoint.cc>
References: <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <ZbFiF2HzyWHAyH00@calendula>
 <20240124114057.1ca95198@kernel.org>
 <ZbFsyEfMRt8S+ef1@calendula>
 <20240124121343.6ce76eff@kernel.org>
 <20240124210724.2b0e08ff@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124210724.2b0e08ff@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 24 Jan 2024 12:13:43 -0800 Jakub Kicinski wrote:
> > > if that is the nftables backend, it might be also that .config is
> > > missing CONFIG_NF_TABLES and CONFIG_NFT_COMPAT there, among other
> > > options.  
> > 
> > FWIW full config:
> > 
> > https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435321/config
> > 
> > CONFIG_NFT_COMPAT was indeed missing! Let's see how it fares with it enabled.
> 
> NFT_COMPAT fixed a lot! One remaining warning comes from using 
> -m length. Which NFT config do we need for that one?

CONFIG_NETFILTER_XT_MATCH_LENGTH=m|y
