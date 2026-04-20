Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12696383C82
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776712027; cv=none; b=gXsaeIs9bo/dUG+GcmaifvaBzJQlpOaFcZEVC8kvAlP9TVxjqY08G5ayFAE/ABtoT5fube2YshvT8+otVPztF+m9MMUhIM94vyf5Gyb8T6qtz5XhoRtQSq46trzSi63lQu2g1iXESXA+REeeTFrCnyHyk6XeSwRRCN+giAQ3FKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776712027; c=relaxed/simple;
	bh=F9+dTYu+EazAQoSXhVZH7rj/z/CisEZPiNZKW0e7iG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtnOgTGT7H9fYWEqRn3caqMFJ+xw82T82PKFrjCub0yDSBdtveqJlxIjAMm20uqfJiYhx6Wz2x4qBBDY3xWrdZdGsBjBOFCehie1KUgLOd/jszOive4ndBQdJzzRDLq1xpNA67riUzZGMqTtpE0mxs0N8WJpL+AbEa93062bwCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E/Y8YaMa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E/Y8YaMa"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1635460180;
	Mon, 20 Apr 2026 21:07:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776712024;
	bh=jmhkzg2lAwutHpq2MKp5lP2mADtXf+Px4I5BolkCzog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E/Y8YaMaHLyiOHBZpbNnuyC0QVQ6zxcsgM8Bk0tDZgcwmdcZeNLUS1Ixv76Ghr5Q9
	 lvJ+5qXy9fBLpkygKZtvl+sxOmj8ZxKxvmofo73tnY27C1U4vFZNv87zzRZMQo8RH1
	 p6qi20ldbYAqxPUs4oO6YlQdTXqmSherk+MlzDZjiyRe4Hgay2kQ3kiXujVXBQnVV4
	 3BcTXCU7oYkXOWCXNvOO3Iy6CuEpKsXYtkiacf4QoQ+kDZFt/fPMC3q3C9xd4hioRi
	 hPV+FlPlj/JhlOH89loJHY8QlmUVecXRdMpzZ/FCAzpxy0Vxb8UTZxgiiRe1RySWtr
	 ROUGR9/PhMkOQ==
Date: Mon, 20 Apr 2026 21:07:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Message-ID: <aeZ5VYC0cxxVYQ4_@chamomile>
References: <20260420174227.13087-1-pablo@netfilter.org>
 <aeZoiqyPFP0NJkz9@strlen.de>
 <aeZpj9r368paudyZ@chamomile>
 <aeZunt0QSt2EdFdF@strlen.de>
 <aeZ0_GvXUnOJPSJ3@chamomile>
 <aeZ2H8ghe3Ddcn9u@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aeZ2H8ghe3Ddcn9u@strlen.de>

On Mon, Apr 20, 2026 at 08:53:19PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Your approach duplicates .checkentry in some way, you have to make
> > sure what your .validate and .checkentry perform the same check, ie.
> > they are in sync.
> 
> Thats why I updated the affected .checkentry functions to use
> the validate functions internally -- to make sure the code is called
> even for classic iptables.
> 
> > If this needs to be generalized further, maybe checkentry() needs to
> > extended to improve integration with nftables.
> 
> I hope not.  But I don't care, if you prefer your patch then so be it.

I can toss this patch if you prefer, I will post it complete then
decide what to do.

> I just find it sad we duplicate efforts all the time.

I thought I could provide a more self-contained approach for this
nft_compat specific bug.
