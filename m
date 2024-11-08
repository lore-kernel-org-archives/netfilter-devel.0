Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180B1F7568
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 22:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105923; cv=none; b=urw9PcTduu4U2q1nuKo/vE+8abO9AWX/kmJZJPGmpLMyRgxkKpd14HfMtHVjPkeUoWy2RF0rq/fF+Z1muBaPgsJTAp4O5jJUzrdSXCGhkScGjuXAhrI3cLfDEdGiGmsqsFTi/h4ik+rmH4/gfA+NpEPwSdZr2wAASyvrXYS1NJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105923; c=relaxed/simple;
	bh=wjt+uXnzZWaIOgH7xAk81gZ3bSOEZZsR9cMYmDJnQGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRBJMCgZ8dWHKkcYuys6968XstxGbc+SrgNqBqGYCf3Jggg4ZWOCMBmMsGmqHz+Za45nCpXNrDVapvcvjsmCmntt3kAF7CV+5dT240TcM5oD4cxlLmbnunJ+unlOpkiVF4BSn0Y+7CXbLnrAuTuLuLI3c2QAriV5zcN+fzXezJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=glO3fqeh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="glO3fqeh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uFpPnR33SXn3sZPNGFqB/vJvkyDCgzjg34LE75uLXdY=; b=glO3fqehqBlFZ9q+JQm8NCZ0AB
	KedWmFtXYgwF+euz6ynBOt2t9cLJwnrnnzWtZp8sU0SxrdOp8QJaR6WjdMglQiXoVmIZ4A53ex85A
	FO9w6At4X4+x5dN7F6GUu+qxJDycFOw4+TcqecxAZA2uSx7KTMy4k8QIm9aog4ZyhRSWgCP75G7H5
	b7HxuJ4kQb/LRqa66BO5dWAnAoMu2ay4lePD90c5fiFIyH3H2mWYg/I8l0WzKRdX9Kc9bLyEII/WT
	Ra6Z1qilgyLFqcRGKTgRpcoLE10YPS+OjNfpA4cgfjd5jqj2C06mub6mpe+OI11mRjvdqzOQQnv/Y
	PztztykA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t9Xj5-000000002mL-2LOK;
	Fri, 08 Nov 2024 23:45:11 +0100
Date: Fri, 8 Nov 2024 23:45:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] ip[6]tables-translate: fix test failures when
 WESP is defined
Message-ID: <Zy6Ud5mcWI0v3kvF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20241108173443.4146022-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108173443.4146022-1-jeremy@azazel.net>

Hi Jeremy,

On Fri, Nov 08, 2024 at 05:34:43PM +0000, Jeremy Sowden wrote:
> Protocol number 141 is assigned to a real protocol: Wrapped Encapsulating
> Security Payload.  This is listed in Debian's /etc/protocols, which leads to
> test failures:
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol != 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol != wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto != wesp counter'
> 
> Replace it with 253, which IANA reserves for testing and experimentation.

An interesting solution, thanks!

We noticed the problem while preparing for the release already. It
should have been clear that people integrating the new release will run
the testsuite and require a solution, therefore working around it
locally wasn't a feasible way to deal with the situation.

Some other options which came up:

* Make xtables-translate behave like xtables-save, i.e. avoid
  /etc/protocol lookups altogether and print names only if known
  internally (iptables needs some for automatic "protocol extension"
  lookup, like with e.g. '-p 6 --dport 23').

* Print whatever the user specified (we store the -p argument and only
  make it all lower-case). so '-p 6' remains 'ip protocol 6' and '-p
  tcp' remains 'ip protocol tcp'.

* Support --numeric option in iptables-translate to make behaviour
  configurable. Needs quite some hacking as the option is only allowed
  with iptables --list.

What's your take on this?

Thanks, Phil
