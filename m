Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A871C84CE
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2025 15:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749657067; cv=none; b=dXear6gcMq1dOwYvlrBL4fTNUaFYMmBbJ0EbpvOD5utvuVOCn2jCS0yC7leioLyaFjYAuQUHH79c1XzMZEK0ZeRMU05ZEjrJqRbNt/PYTJeBj6vBHSdrKSuwwt8rw+xZ0dIQurl6nBnNGy82WP4XkR2Cf6U9u3Hr4wkuD9SkWNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749657067; c=relaxed/simple;
	bh=XU7xmaCzeyctnQh1rs8yaCkWhsm1PrYqB+Mz8moMqd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQkHTKqsSnvrOVjlxqQpIV1GERRpgRVZXq+eSc/V8ULRZrJfKeHqbp+4EUaNyj1AajqE0v2rD+eABEM0tGX73ZWgy/tnP+45yVHZyVtKXoJRUxwBMGMRQ7qakHgBVoVcXKqJHig0C33eSZLfxXBLK03YA/xzaalbgcSMj79WYEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dSdTUYjj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dSdTUYjj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MRqJ45W4BzrhusnVRFkf2gYBYc9dq6dcJgwxSjgcQ/M=; b=dSdTUYjjIjpAZmrp5iV/lVyAvw
	aFQHDj5EQgyMwbYFvoOLfviwefhVDEz3AebjIwK3bXHTOSzvGq81yd8eBivGnO+d63UukYCZC/VrZ
	bXi0QrAFnqbADY/wCB9Sxz4WawgN2fIAPJcSVpRMy56NOCTTJqxSPs78atiWweKauD029L4TW+iFP
	8nt72eGT0qmsGkfG/+DoZHBXRe0G/2LAM1HXYCYReQ70wbhfZ9Y55KakJQMMTXMfbVYsvRRoPnkt5
	HWUoYuPtzQx9lDCADAsLwLfRmXpHZ3sfphJLJDK6qNqvyHs8BaypkdKPTYCM5LF5UYa2Jmwt7Qs28
	04toOnOQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPNj3-000000001br-30ba;
	Wed, 11 Jun 2025 17:50:53 +0200
Date: Wed, 11 Jun 2025 17:50:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Folsk Pratima <folsk0pratima@cock.li>
Subject: Re: [nft PATCH] doc: Basic documentation of anonymous chains
Message-ID: <aEml3Rygg412w0hJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Folsk Pratima <folsk0pratima@cock.li>
References: <20250604175628.19062-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604175628.19062-1-phil@nwl.cc>

On Wed, Jun 04, 2025 at 07:56:28PM +0200, Phil Sutter wrote:
> Joint work with Folsk Pratima.
> 
> Signed-off-by: Folsk Pratima <folsk0pratima@cock.li>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
