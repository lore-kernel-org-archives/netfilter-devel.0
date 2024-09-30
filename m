Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBF4191F92
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727700294; cv=none; b=d0wJNbUh0PRJ/WVDEdrhLpJf6bdGBdFA4Wo3cxWHxVfhtXFQWe874iO8AB2za/ElWbJ8zN2rofSnJiRITq25ERLuR6cR038Ndv+HVG120OHB3ITMB4kWK1giXMiLUvoDYINmIiT11/3MYmyj6fyR9gPOiGMtUvKA1XoEVEABh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727700294; c=relaxed/simple;
	bh=3uDBZtkK9/wGgqAdKKxo0AiAASybcH4f76T0Pq4fXz0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hn3yrN/kBdh8qMANQk3RLaU8/dCFWptAlkZHeyM9iuXtDyOxi0TPki1GOXnMm5AmedIAZ4SSSi41lZloDBF6UsZ/Vzfd9af2PKmJTf74v5j7qZZtlfA05SKc74d5/E4cOPGEqFiwLdi5AdvQ5HTm6hOzRnzxQY+8Z+5yBLPTdWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48382 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svFle-0089PS-U5; Mon, 30 Sep 2024 14:44:48 +0200
Date: Mon, 30 Sep 2024 14:44:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: webmaster@netfilter.org,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: "libmnl" project doxygen-generated documentation
Message-ID: <ZvqdPZVqfvZNGUAL@calendula>
References: <ZufPNH0p/G7IMK1T@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZufPNH0p/G7IMK1T@slk15.local.net>
X-Spam-Score: -1.8 (-)

On Mon, Sep 16, 2024 at 04:24:52PM +1000, Duncan Roe wrote:
> Hi webmaster,
> 
> The documentation on the project website is for libmnl 1.0.4 but the
> current release is 1.0.5.
> 
> This is particularly unfortunate as function documentation is broken (absent)
> in 1.0.4 but fixed in 1.0.5.

Updated.
