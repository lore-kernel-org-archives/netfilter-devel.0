Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B7F1805E
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748392761; cv=none; b=iMFjclHvyT1T57rri17IkYMjYej1M0+XHw8M7bAbOjcCOS750iGJT9Duo+4P/I2WsLtgbslsrS8i69XlBZHbVENjISETj+GhhXEeiIb/wW8X5k0WY+kugcDyb6Ewmrdr0fHEs3UUfqWXwqHPTygVrwSHXb/LA75OEnNu2TAqYWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748392761; c=relaxed/simple;
	bh=gSG4WW4QnFNxDNOlr5wZQHPk1OIqSIAWgOMKzL9w7C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elUKKKAZAP37wqpw+X9fY9AL2b4dzDL0lEt0qfRmc+KKXADyET+LwW34wU/UMgSzw9ycP62UNaSVfim1XgWDvkxR3w6la+8/duorPh+xL+D6XAsGrQP12A5ixUsHPt6HZZhR3UQCMbDujUKftYI2zXxxZotMldy/oA8yCH7MdP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C82F860368; Wed, 28 May 2025 02:39:16 +0200 (CEST)
Date: Wed, 28 May 2025 02:38:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7 nft] src: add tunnel template support
Message-ID: <aDZbDhRCtJ-On6Jr@strlen.de>
References: <cover.1748374810.git.fmancera@suse.de>
 <6a6bd36db43a444ca12bdcb46977d2361f914a9d.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a6bd36db43a444ca12bdcb46977d2361f914a9d.1748374810.git.fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch adds tunnel template support, this allows to attach a
> metadata template that provides the configuration for the tunnel driver.
> 
> Example of generic tunnel configuration:
> 
>  table netdev x {
>         tunnel y {
>                 id 10
>                 ip saddr 192.168.2.10
>                 ip daddr 192.168.2.11
>                 sport 10
>                 dport 20
>                 ttl 10
>         }
>  }

Dumb question, how would such a 'generic' tunnel be used?
Or is this just an intermediate step that adds the common code?
