Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26471C243C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726224066; cv=none; b=UZap3LnSs19LEAUvCPHbioaBHzer+NboxnAd47GN/FR0OusCukFVQzAJ63WauP/HRX0ZAJJhhJoQthCXv/uxMV7Nr24w1GbD9lmnusZV/hP5gJyuPjNUBm0nPjjpuZpHFnvTwhvEdGxfJLXf3lCHOBHIs3bacYAVO7xe312KtO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726224066; c=relaxed/simple;
	bh=D3d2phd6PMr1SNm5ThSZRmtZaPaCO4bHloTW12BSzAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zo8f+snOYR7F2gma0NYN/gbG1YJYe47RqEbR2bbkNN1oZRp+GLNj7/VQTQ5qKb0l9oND2+ZUT4ZBODVSmjikZ5nceFlyFDTxgZ9ZxCJA8KeTxHKTyJ5MKEbDNqcW+pmh5eUeGm4daHtS8zyUYCTxe8JtW6taIGY+fiLc/SQEYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sp3ja-0004JI-0J; Fri, 13 Sep 2024 12:41:02 +0200
Date: Fri, 13 Sep 2024 12:41:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	antonio.ojea.garcia@gmail.com, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <20240913104101.GA16472@breakpoint.cc>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuQT60TznuVOHtZg@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > tproxy action must be terminal since the intent of the user to steal the
> > > traffic and redirect to the port.
> > > Align this behaviour to iptables to make it easier to migrate by issuing
> > > NF_ACCEPT for packets that are redirect to userspace process socket.
> > > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> > 
> > The nonterminal behaviour is intentional. This change will likely
> > break existing setups.
> > 
> > nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> > 
> > This is a documented example.
> 
> Ouch. Example could have been:
> 
>   nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080

Yes, but its not the same.

With the statements switched, all tcp dport 80 have the mark set.
With original example, the mark is set only if tproxy found a
transparent sk.
