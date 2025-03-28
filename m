Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7503214
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743171047; cv=none; b=oj7natHu42oIrj90s1mAqgTmW8vlNIOGALZPwRmA+9piQppckoEyODiq9pNsSZ7j3zR1J7i7LBNibXzdvtiytjvfMEnMm82mGs4v81HStwv+koUTHI/naA3TjlzUnNJpY7xamM6skJwtN2rPXaxZRsCLAok7ocoBhKGlIyAFGwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743171047; c=relaxed/simple;
	bh=YuMVls9gHXgu8Cf/ECqw/ES7LGkrBtoMi9frjRYY/40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivacPt7eLgXPAoz7itE6JfpdjO9/iHVCdffncsoGDissjmY7jjLFoHOZo7VUhNFqHGmy4+/aUZzN4lwSm+2NH0MpbULcqWSZba6Sv8mljSuPLH3td0Rekqdk+rJuqhnxvvzOEDMWfecz2Wb6rr22LczNMLxivQmCeF5fUsLZw3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UbJkFWW2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UbJkFWW2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Wap9V42rtHPBoIy1ZQ2E5+RIWnCOB/Jhz0fkDzpNV2o=; b=UbJkFWW24PruhPQQsUO40/5ceF
	Dal931ewhBVTyIpjAZqAeGa4OyNlIxyhOrXrM+bAViFRu6IbW+nAbjPyt4WRG+eM+CqTgEHvKTd9g
	3XKkBTEPupte+fCfaBdN0NI5A07DTHlx8NlImr3KAJyfyh/DVx5jkF3mpNMPWw1Qvthpy6GmHF19P
	dh7h5pNGcbbDISEL4S2wx6f3Qkv61rAexdVKCd0rpr165AWVV8xUXJAe5US9vFq6Vyvtbjxzlqfx1
	e+K5KqNb3mucrV+TBpFSx8K63g3/lOqPocLGnUgrqialFmHMGkpdS5QgHf+yHV/vVB9NvBhjlxPn1
	Xf29+Uxw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tyAPy-000000007sC-2yOr;
	Fri, 28 Mar 2025 15:10:42 +0100
Date: Fri, 28 Mar 2025 15:10:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Add socat availability feature test
Message-ID: <Z-at4gKDAmg-3_ua@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250328115855.6426-1-phil@nwl.cc>
 <20250328122935.GA24225@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328122935.GA24225@breakpoint.cc>

On Fri, Mar 28, 2025 at 01:29:35PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Several tests did this manually and skipped if unavail, others just
> > implicitly depended on the tool.
> > 
> > Note that for the sake of simplicity, this will skip
> > packetpath/tcp_options test entirely when it did a partial run before.
> 
> I don't mind skipping it entirely.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Thanks, patch applied.
