Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF88E19AD7D
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726747728; cv=none; b=uy+uJBOoJgfggRG7w3qd84Gdky07Qn8/7MexSBX3hDKtQXWR6YE8iAjE3zXUiAdYGoqxRwLCNFi3MoX+9gTYM6OW2tUEsNrtWevkqLX0Xk5Wlh9Ozq/08qkgJFfHJx2LkkCddB8rQfT13D6sFpxtcPj4rIybO10fEpXNygcYAXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726747728; c=relaxed/simple;
	bh=tPDnMEaKyj6b3Va2IjdSBmexmqzczqFm15g6kaksI24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=of53ZHfLtiNF4UbBsYN+ddsHQq5uOA9KpmkG5Szgme+zMX254ERTuAvpAFy/EjApKP7J87CfBaxVlWVYWtIW5SzYyND3UYhGzFj+bE2c7EbnyqJ7zLfQCotdDjUUSqlU6z0WLG5xVNV6VSqJ/vntpBMCaTWi1J5C8z8tENlV710=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60514 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srFxi-003JMn-S8; Thu, 19 Sep 2024 14:08:44 +0200
Date: Thu, 19 Sep 2024 14:08:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] selftests: netfilter: Avoid hanging ipvs.sh
Message-ID: <ZuwUSgiqE0-mYChs@calendula>
References: <20240919104356.20298-1-phil@nwl.cc>
 <ZuwS6KD5ObBEaNY6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuwS6KD5ObBEaNY6@calendula>
X-Spam-Score: -1.9 (-)

On Thu, Sep 19, 2024 at 02:02:51PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 19, 2024 at 12:43:56PM +0200, Phil Sutter wrote:
> > If the client can't reach the server, the latter remains listening
> > forever. Kill it after 3s of waiting.
> 
> Applied to nf.git, thanks

Too fast. One of my test machine has not waitpid, there is no usage of
waitpid in other existing selftest scripts?

What am I missing here? :)
