Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CF8303C8B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755105710; cv=none; b=nSkvojiqlM5nhAUtO38GMHE3aO/y/W+wkJmCCByF23WsR2go4Hq1k93eH3CccTw1mNd9+yeLuZ4DdqVAKcvBIRXM7FbErPAf9UpF5mj3xck6N1jYvg32RuAFpurYaVy4COSifNoyCPI/dVjFBA/ZGgg3Q93LUOedEGen6TwScTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755105710; c=relaxed/simple;
	bh=nx0vjST3cwfF7M4rUxwTAJ1pL6CxCl1/O3pPZDeMYnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2JJgCWEWl+ff7HoEm61cc2jOvGhzDG5pz/8jd7fuV36v51HYMAH+vn4+EWSIlcv2Q7v6Nb0CWT1Sjet2eHmBrYetL89iIVLcr9mxYao/NHXhiodaMksgvdJg3ZnIK1NsufZVnKnc+XHtQVXaV+SIpECOCrkEM/4et2xT+6hBzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cAKqx6aE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cAKqx6aE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nx0vjST3cwfF7M4rUxwTAJ1pL6CxCl1/O3pPZDeMYnE=; b=cAKqx6aElqTlmlgS0rFbpxi2hx
	rSdKyFC2cJpF13psmXT3gVIV/0pRcI3vG8DhDQd36zdvfTMKfdvAOwVwm05i1s9Z0oZ2gB+yMTxOx
	PCFrOJXXs5TbICizIuPxU8vqJZNllvcPOviu1aab6njYInluqCHwHhgQvTtPgngbzclHj6WDGbQYO
	maq3WbxBrOCFVLUMy3xPu162hR1Ht49w/adeOrzfta89Bvp9eYA0BBO4rHYum2hJvJo0teSWs/el6
	zf0QETsobl8BBl0GFj+nyAhNX2PaMK6YiywqsZ0EBTb5xvN/Y9+KDLqkF1QONuFUaA+h1Mwz3aF/Z
	SmqNlI0w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umFAZ-0000000046H-1xvY;
	Wed, 13 Aug 2025 19:21:47 +0200
Date: Wed, 13 Aug 2025 19:21:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aJzJq66WWfcZpb-3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
References: <20250813170833.28585-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813170833.28585-1-phil@nwl.cc>

On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata

This is actually 'PATCH v2', sorry for the mess.
