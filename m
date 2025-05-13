Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971B3210F45
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2025 08:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126201; cv=none; b=taH4dFlUUpByjGbT5s/ZNMwseX8jgE7wQCtLpm1xX3LRBVZjoZmAKr4/H43IkUV/Ffv1YdWG+OpyreaZH9YNUcrNwb1l2jUs0QzMrZzFPfXh66Y7aF4I1Fmn+leIQzuZZRC2SHuYHXrxBlxgW+tx+0VsZOpqWXXHQAHtBTGycdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126201; c=relaxed/simple;
	bh=iroJbZLuJ3Ch2wY+OQ1VcYazOeJIghQup7xtQKcPSHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OebbowQNfkwYJtZRWLAPizhqBNglv5DK1xw3D7fyJzN4ppZxqXjZnCrgB9QIl9/9RRC61GhLqmP1szQfaHSSFmvrnea7AmOJC4x9kpMxUNCVsWlXCuz9iRSypt2jlAqhX42bJ4z7IuF+x08qZUvPHkOJz9cN4I50HWrWUEyCBwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=f73zsoAf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="f73zsoAf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1IPmhJGSLDy+7tDoLNoABK2HUB1DUi3B7MK/0PuIZ+o=; b=f73zsoAfq/aXPKSr30abP3PV5p
	mtO90+YDLHv3FPNSmKOOBoCXIKDcofqEQfySlv5sjkWCWkJtoDEd7mBJu5Qa8PL4C5+wRYdNNd/Uk
	ORpMrK/VmVyYm2aRLtDgSezei+2yBCtwYLJOrxpQWWwKjNQ2JvTVpEempJ1GD6cfzXMS/joDyywhe
	j2WTc35jgIA0eciZ4Dmx3HSNJdQzEUKzubUDxotsZvAEdWave6TBmRIJqytuWDysmzQhtC490pHhc
	uPnL+q9pDGxpTrxQVRQUIt39r4f9ZKZidNWYVwoHt4Dp+S1axaDJ2DDHOzx1lCs5W2JjiRW0jIpfG
	zf7bcvVA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uElKm-0000000015s-2Gc1;
	Tue, 13 May 2025 10:49:56 +0200
Date: Tue, 13 May 2025 10:49:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/6] Add test for parse_flags_array()
Message-ID: <aCMHtAiTKRssAn8K@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
 <aCJrwrJVOasoVfC1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCJrwrJVOasoVfC1@calendula>

On Mon, May 12, 2025 at 11:45:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 08, 2025 at 11:47:16PM +0200, Phil Sutter wrote:
> > The function introduced in previous patch relaxes JSON syntax in parsing
> > selected properties which usually contain an array as value to also
> > accept a string representing the only array element.
> > 
> > The test asserting correct parsing of such properties exposed JSON
> > printer's limitation in some properties to not reduce the array value
> > when possible.
> > 
> > To make things consistent, This series enhances the JSON printer by
> > support for array reduction where missing (patches 2-4), then introduces
> > a shared routine to combine the common idiom in patch 5. Patch 6 finally
> > adds the actual shell test case. Patch 1 is merely fallout, a trivial
> > fix identified when working on the test implementation.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Series applied.
