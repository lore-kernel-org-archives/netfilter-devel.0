Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2211DC077
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223401; cv=none; b=MbmmVgmctIubhOLUqA2Dd7eRbxO2+5wXtmnht+CbW8X7WJDzEthvvi8hWXndkejVex0cJsfLvYJWtC11ONwpa6ItEZSSzv7XDgEYu3v4cVmwRo7OguAkZrsUrK9Znd/wI6aybX40UfCPlruazGfvPNfPHca0GMiWfJSzWuZ/QZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223401; c=relaxed/simple;
	bh=NuIy6ecKZ6gItKCz1OJ0jCYzH8VTtEUBJGyZcpjgVng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srNjuL6tuNMbiDlVzwARN4Kz6bqZzFZBn0dxosFyoeqZkKhPGOnd4F6gD9shQBguEhjk8mkRfVUA5WlxiVE3UUkt059USyg2GNypG8DRW0SjBJCLYbHX3vvnonXwXe0I/IAWUfwpQx1BDtkNzh43C6iqHKw0sZbYP/Hntg3ZHl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33734 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sp3Yl-00AETZ-9e; Fri, 13 Sep 2024 12:29:53 +0200
Date: Fri, 13 Sep 2024 12:29:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, antonio.ojea.garcia@gmail.com,
	phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuQUHuwfJw-_8OXh@calendula>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuQT60TznuVOHtZg@calendula>
X-Spam-Score: -1.9 (-)

On Fri, Sep 13, 2024 at 12:29:02PM +0200, Pablo Neira Ayuso wrote:
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
> 
> but it is too late.
> 
> Quick idea: extend tproxy extension to add a flag to consume it:
> 
>   tproxy to :50080 flags consume

Scratch that, this is very silly: it is not different than just adding
'accept' after it...
