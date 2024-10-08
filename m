Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC321E0E16
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728405923; cv=none; b=LMFKiIvgu4wWWD6+oooKIvMp8VbI+X4qKQE3a4imPDCj9DEyFLPrRUVxViXUUjTnjdAKs7vlRLI3NV/jP1ComZILUyGvld565JKbHCbq+T7GWBd6OER8zpJedovpzMbSgvYuqLUdL+o5xyKRFY5mYFtRkK7nDwg81ef7bjT6CQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728405923; c=relaxed/simple;
	bh=K62Yu4sXQP+T5MIaotVSjzFN7Ji+nQN97StGGgMxUFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1tPXmSpZgILHrp7sGeOi7k+W7IiU6GPKedvKrdbVrcrC4vNQ+pMSYsFdAV2pIrPE/VCDmq6pJVWC1CFcN9r3e7pUNseWLafI99rXYqt+3QbnWKD9t2ZJjeOFZoosZ4pR6FQzUQZeT4PEVYKtAGZGCrTrX7bQ1ofOsWFrkk6rEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1syDKn-0004D9-KY; Tue, 08 Oct 2024 18:45:17 +0200
Date: Tue, 8 Oct 2024 18:45:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Yadan Fan <ydfan@suse.com>
Cc: Florian Westphal <fw@strlen.de>, Hannes Reinecke <hare@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, Michal Kubecek <mkubecek@suse.de>
Subject: Re: [PATCH] nf_conntrack_proto_udp: do not accept packets with
 IPS_NAT_CLASH
Message-ID: <20241008164517.GA15971@breakpoint.cc>
References: <20240930085326.144396-1-hare@kernel.org>
 <20240930092926.GA13391@breakpoint.cc>
 <776f0b5c-7c2d-4668-a29e-38559fc0ee45@suse.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <776f0b5c-7c2d-4668-a29e-38559fc0ee45@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yadan Fan <ydfan@suse.com> wrote:
> On 9/30/24 17:29, Florian Westphal wrote:
> > Hannes Reinecke <hare@kernel.org> wrote:
> > > Commit c46172147ebb changed the logic when to move to ASSURED if
> > > a NAT CLASH is detected. In particular, it moved to ASSURED even
> > > if a NAT CLASH had been detected,
> >=20
> > I'm not following.  The code you are removing returns early
> > for nat clash case.
> >=20
> > Where does it move to assured if nat clash is detected?
> >=20
> > > However, under high load this caused the timeout to happen too
> > > slow causing an IPVS malfunction.
> >=20
> > Can you elaborate?
>=20
> Hi Florian,
>=20
> We have a customer who encountered an issue that UDP packets kept in
> UNREPLIED in conntrack table when there is large number of UDP packets
> sent from their application, the application send packets through multiple
> threads,
> it caused NAT clash because the same SNATs were used for multiple
> connections setup,
> so that initial packets will be flagged with IPS_NAT_CLASH, and this snip=
pet
> of codes
> just makes IPS_NAT_CLASH flagged packets never be marked as ASSURED, which
> caused
> all subsequent UDP packets got dropped.

I think the only thing remaining is to rewrite the commit message to
say that not setting assured will drop NAT_CLASH replies in case server
is very busy and early_drop logic kicks in.
