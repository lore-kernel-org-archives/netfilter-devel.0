Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED54F60B87
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708604999; cv=none; b=BGQtRk5mcVC1K6/JxkbviX7mxn031lcFnSxdOW7xatzrRlR9ZXzbzh9U2N3aV/nNjvsPYLV3YSLJAXbIwp8ZCrIPWtOTmGjBHQUa9HW50/4jAzXXshIUkwT5mhm10P2J2rBIZVgo5bB3IblGXE6kbWmHAKYHEPcDcpu05SyG8sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708604999; c=relaxed/simple;
	bh=QAr412J9wjqdF1YGFMLCWKSHXodrJXFE+JsnNxRoNRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUQ6VX37kMPNaGD4aCyPPKHq0BWVRcQzZbbyHTLpET+fYiUhi8dhuumPUvbmCiy/OMvg7wswt1ajq8rtDnnpufz4+XjCTaPDueAzO6+vUk8yoFUmQSjircZAE9UCJZxUIiQi2/oCes0ylFcqDIJyTMWHussjhejzcRzu7cts6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=52024 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rd8D0-00CtxC-3o; Thu, 22 Feb 2024 13:29:52 +0100
Date: Thu, 22 Feb 2024 13:29:49 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kernel-team@cloudflare.com,
	jgriege@cloudflare.com
Subject: Re: [PATCH v3] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
Message-ID: <Zdc+PRCdULl3v7Uj@calendula>
References: <20240222103308.7910-1-ignat@cloudflare.com>
 <ZdcnfnoEE10cV7gL@calendula>
 <CALrw=nE4SY2iZkW9wtYMUwcA=p0wSOzOmSqRF3i_4p4sAnEKUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALrw=nE4SY2iZkW9wtYMUwcA=p0wSOzOmSqRF3i_4p4sAnEKUg@mail.gmail.com>
X-Spam-Score: -1.7 (-)

On Thu, Feb 22, 2024 at 11:49:32AM +0000, Ignat Korchagin wrote:
> Hi Pablo,
> 
> On Thu, Feb 22, 2024 at 10:52 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Ignat,
> >
> > On Thu, Feb 22, 2024 at 10:33:08AM +0000, Ignat Korchagin wrote:
> > > Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
> > > some validation of NFPROTO_* families in the nft_compat module, but it broke
> > > the ability to use legacy iptables modules in dual-stack nftables.
> > >
> > > While with legacy iptables one had to independently manage IPv4 and IPv6
> > > tables, with nftables it is possible to have dual-stack tables sharing the
> > > rules. Moreover, it was possible to use rules based on legacy iptables
> > > match/target modules in dual-stack nftables.
> > >
> > > As an example, the program from [2] creates an INET dual-stack family table
> > > using an xt_bpf based rule, which looks like the following (the actual output
> > > was generated with a patched nft tool as the current nft tool does not parse
> > > dual stack tables with legacy match rules, so consider it for illustrative
> > > purposes only):
> > >
> > > table inet testfw {
> > >   chain input {
> > >     type filter hook prerouting priority filter; policy accept;
> > >     bytecode counter packets 0 bytes 0 accept
> > >   }
> > > }
> >
> > This nft command does not exist in tree, this does not restores fine
> > with nft -f. It provides a misleading hint to the reader.
> 
> I tried to clarify above that this is for illustrative purposes only -
> just to give context about what we are trying to do, but do let me
> know if you prefer a v4 with this completely removed.

Thanks for clarifying.

> > I am fine with restoring this because you use it, but you have to find
> > a better interface than using nft_compat to achieve this IMO.
> 
> We're actually looking to restore the effort in [1] so some support
> would be appreciated.
>
> > The upstream consensus this far is not to expose nft_compat features
> > through userspace nft. But as said, I understand and I am fine with
> > restoring kernel behaviour so you can keep going with your out-of-tree
> > patch.
> 
> Understood. There is no expectation from us that upstream userspace
> nft should natively support this (as it didn't before d0009effa886),
> but we can send the patch if consensus changes.

Thanks for explaining.
