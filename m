Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A019247B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626744; cv=none; b=IauxQe44O2NM5wVgxEuPwxYIVp1GxBgrv4sxWL2OS9ND2ZCK/pfEv4OHtZ+W9eqAHCSOfku8K3p5PgcI5D5se39Okg7VGWGdSsORz1jXJOQl8zaeATbOUnOogDreIu8rFvIaOdhN9Ni9VS+mwg5bOw7YEgLbGyGojxkCpd9a92Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626744; c=relaxed/simple;
	bh=MJ7qil/QyMuo6tsGv3ze8qePYLHG+x4U1nlSjZlmCSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPViGjBALJ5F4bcBkYW0jsPTQqTTceq6u5CoStJejEqGIDsA7n4fa1nAUmTUDSpgNPD1rb8VfQGOaKZv3Iez1n0uuKnumObl9TJE7Umx/mGq8OH+9LUjJxF7lpcK8Mes8PdrmOaOYzRU9HhYV5AR+l+iBZDqwDGQSKDUuw5E2Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b95G98rE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b95G98rE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=akL4IqCgqKKAZdzmqb2cg/aFCtm73ZvshsmapPm6TmE=; b=b95G98rEoHmrltpggd1XezSEoS
	RxIdZkQ35CZhIQtMc4zjXtP1haQwMVVAFH8WSCrAcIvAF5yi1niHEDOyfoAYnkte+Lvx6y0X/SOeP
	jC6YRqfLYESX4AvFKb8OgFzCRCSttAw+iyjuN+RsE9PXnZPu1sxpg1y80/hhCJqw9izZP4gHp3R+M
	BFN9HbkX9buYm4N/DDgBHcfScbm3pV8mTHXYIIFBOQHZWDsnbneSc6xQnEIFXa2XsOopg6TVPGDf9
	l0TsCbPQnb2kgf/gxNj51nkxkXVhlDxvMfzJXqMdp6o5DzNj87af4lsB2JTBr36aRFps5jYBpwQnF
	TX9+liDg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRZcD-000000001YW-0CG4;
	Wed, 10 Jul 2024 17:52:21 +0200
Date: Wed, 10 Jul 2024 17:52:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, thaller@redhat.com,
	jami.maenpaa@wapice.com
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6uNc9oxoqMTwmU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, thaller@redhat.com,
	jami.maenpaa@wapice.com
References: <20240710152004.11526-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710152004.11526-1-pablo@netfilter.org>

On Wed, Jul 10, 2024 at 05:20:03PM +0200, Pablo Neira Ayuso wrote:
> Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> stdin is stored in a buffer, update json support to use it instead of
> reading from /dev/stdin.
> 
> Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> according to reporter (that mentions Yocto Linux as example).
> 
> Fixes: 935f82e7dd49 ("Support 'nft -f -' to read from stdin")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: remove check for nft_output_json() in nft_run_cmd_from_filename()
>     as suggested by Phil Sutter, so JSON support does not really use
>     /dev/stdin.

Series:
Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
