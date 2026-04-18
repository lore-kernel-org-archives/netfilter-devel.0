Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493592459D4
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 08:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499829; cv=none; b=Pa1lhbq2oIOuJiI7c9HzhNXYKphkEJ1GppGx8r3w9m/REDlde6JvAAb2Tp253TkiVdDS5BJkFe9IjTEc2rWwIjpsesaEpv+FYST5tS7Bj6RmcWzU94a76ZEvOtncjQEFH5vULH/MO5X8wUqpLh6aOOCzGJuuVLvuTFOtyYq2GnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499829; c=relaxed/simple;
	bh=0wdDdKJHkWmxxFgFnl9WrzrVLehDxuMRY7UBT5FbG6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9PpIJQfluSxtanfSsgp2gMDKTP42KzK7Cu46zY7v/DGnI15KaypkgdxYc6bz789EiogUWGvP+URROMyQPyD4b2n0aToQiitDotl//r6fXXdiSsDDmOJjq/kTZO2adfjSVLUGx9BijItxv57sBkDDFoWYGzC+95yHFzkJ7cw0Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0561F606C8; Sat, 18 Apr 2026 10:10:24 +0200 (CEST)
Date: Sat, 18 Apr 2026 10:10:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: arp_tables: fix IEEE1394 ARP payload
 mangling
Message-ID: <aeM8cJSTHEt9PRy3@strlen.de>
References: <20260417131910.17932-1-fw@strlen.de>
 <aeMyhUwPwj2kB6Xa@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeMyhUwPwj2kB6Xa@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Apr 17, 2026 at 03:19:05PM +0200, Florian Westphal wrote:
> > sashiko.dev noticed that similar bug pattern exists in arpt_mangle:
> >   "IEEE1394 ARP payloads omit the target hardware address, advancing
> >   arpptr by hln after the source IP address skips over the actual target
> >   IP address."
> > 
> > Apply similar fix: check dev->type.  If we're asked to mangle what
> > doesn't exist, drop the packet.
> 
> I included a fix for this in:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20260417091422.342615-1-pablo@netfilter.org/

I saw that *after* I had made this patch.

> >  Collides with a inflight patch.
> 
> Are you referring to the patch I made?

Yes.
