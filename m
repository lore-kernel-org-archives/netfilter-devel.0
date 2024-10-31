Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0B41B6541
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730391892; cv=none; b=es2lCAwJlXNSaq4jRslZQchHsG3owjrOnb04LIVHpVVmX86TVQU9Lsg2ie1f72CjKZIav+RMiEIX9cmnifKzuMr+DZaHgKDfyhyNWrZld2coImX9SO3OkwHTmdZBoPx76FDpDzTAGQAV290LmKgIbAfGeBd1D95UjkimOmHW0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730391892; c=relaxed/simple;
	bh=KKWRqTWoN3uezWCdeTkTwKQDyx8IOtSiFzm4/dX9yRA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxzJMF259QrRTNMcsx4uFoJmJsvPjOEYS3tDgnwkYEchglXO07OyEB3wLxdBuDw2LesYyD03R31cjxoYA5UDuquvTHbGjK/AZdgm0Ckl6GCfufQAthtN0P7rsPhZfP4ICytpiQkifMGZ/A3VzDLylCyDkjYcKOWlEt/GJb/hhuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33320 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6XyU-00G74q-Ba; Thu, 31 Oct 2024 17:24:45 +0100
Date: Thu, 31 Oct 2024 17:24:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: collapse set element commands from parser
Message-ID: <ZyOvSRL5pZPySPIq@calendula>
References: <20241023133440.527984-1-pablo@netfilter.org>
 <ZyOe7fOjPZExHJFm@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyOe7fOjPZExHJFm@egarver-mac>
X-Spam-Score: -1.9 (-)

Hi Eric,

On Thu, Oct 31, 2024 at 11:14:53AM -0400, Eric Garver wrote:
> On Wed, Oct 23, 2024 at 03:34:40PM +0200, Pablo Neira Ayuso wrote:
> > 498a5f0c219d ("rule: collapse set element commands") does not help to
> > reduce memory consumption in the case of large sets defined by one
> > element per line:
> > 
> >  add element ip x y { 1.1.1.1 }
> >  add element ip x y { 1.1.1.2 }
> >  ...
> > 
> > This patch collapses set element whenver possible to reduce the number
> > of cmd objects, this reduces memory consumption by ~75%.
> > 
> > This patch also adds a special case for variables for sets similar to:
> > 
> >   be055af5c58d ("cmd: skip variable set elements when collapsing commands")
> > 
> > This patch requires this small kernel fix:
> > 
> >  commit b53c116642502b0c85ecef78bff4f826a7dd4145
> >  Author: Pablo Neira Ayuso <pablo@netfilter.org>
> >  Date:   Fri May 20 00:02:06 2022 +0200
> > 
> >     netfilter: nf_tables: set element extended ACK reporting support
> > 
> > which is included in recent -stable kernels:
> > 
> >  # cat ruleset.nft
> >  add table ip x
> >  add chain ip x y
> >  add set ip x y { type ipv4_addr; }
> >  create element ip x y { 1.1.1.1 }
> >  create element ip x y { 1.1.1.1 }
> > 
> >  # nft -f ruleset.nft
> >  ruleset.nft:5:25-31: Error: Could not process rule: File exists
> >  create element ip x y { 1.1.1.1 }
> >                          ^^^^^^^
> > 
> > there is no need to relate commands via sequence number, this allows to
> > remove the uncollapse step too.
> > 
> > Fixes: 498a5f0c219d ("rule: collapse set element commands")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Pablo,
> 
> This patch appears to introduce a performance regression for set entries
> in the JSON interface. AFAICS, the collapse code is only called from the
> CLI parser now.

Indeed, I am working on a fix for the JSON parser.

Thanks for early reporting this issue!
