Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972950;
	b=wj2QkVLk/fDROVSr3I1nqfHgpBhL+y5uMp2R8x+OY7G2kcPIePfAMfZ6B8dRigvEdCN1
	 pUL8E9EYULn0soMyvshJmfYiFY3H2icxY6Zkz4HJqk0q2Yc4xBpZ3uKztjwFtgthupdaD
	 DvrVOI9LIGppSn6hupyQ8E7JGwLvOq2UEu6wGp/+stCz5hojgCj6rIioKvmQolvS0mkjf
	 74HR1oRHlIc224dlbIzr1b3iwvG8X1uDXDIC62xRBp9SQfFPC3SxZdXtvAhrCXDFbUgeE
	 wSWb5EJ1aFh3LPRviqNvYY11RtWw4iahfzBlXzBR0xY4fZnYfbBvXzpLgvhz3ES6Rqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972950;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=wJrRTV2WP+PyilWZ3qWgVYDSsFcLDu9uXhwWtnsEHxk=;
	b=JXvNV67hA2JImk1bfpwpzus12PMyF0gwxc8UWWHzY1PjDXRDsRnQdM7wua+z3xgnt0yt
	 JwfUxdF9wLPZUxHWPsgINq16EoiNIFjPEXGf4VffQatxOP1YWVf7qBDpFw2Yy/0Ojhk5b
	 0fM8fgmQ+ECp/HbJCkBk0nQc0CWHjq3k1HUDbZSAQHzjLTF/fN1+H2nZOyGxYRzdmNq7h
	 xLAtjRNJoRU/TjWmCXosTGt6sLNmj1yWrsiHXv2dJTyL3u0nSWtTF+S5TEx/2bJX4Q533
	 o4k60hvxHXU+bbLZxZDxDdPI6ovUAz5zbtwnty/pQcv0LxNe8CbYvWhmmdqRNITFXMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=hyAjI5Ve;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3EB606A32D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 13:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED3EB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=hyAjI5Ve
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wJrRTV2WP+PyilWZ3qWgVYDSsFcLDu9uXhwWtnsEHxk=; b=hyAjI5Vek60C+3peAXKrXRPidm
	+Fi+tshsu3iB/43a6Tx27veSKbsA65/ruv6SZxTLQg1sox9Cwfgc4rPwh0ogOlwOBiZBDRSO6O/lg
	LPzUPzbhpTT+Obfxw+prXjeYpo9p6Ee5PIUxZtRGQc9hvwj95eE5TlaDHdJT5j0xtVLvwp+PJt+r8
	CM9H5zDNHm4NV6xYDnr0IeX0K20lveYmmXamSLoWmeakDSoDHHKjjhxOvuXdavB1fE6JL5ZSsPB+L
	dH9TVj50/gkDNNpVrYrQbg25ZzXSqfkGbz7zovD2DiByFIBZoZEnYZbcKo6yO1ApxDU5lU0MGyHMO
	g1w4jkEw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xPKJW-000000004Mq-2CwJ;
	Fri, 06 Nov 2026 14:49:06 +0100
Date: Fri, 6 Nov 2026 14:49:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	xelra <xelra@protonmail.com>
Subject: Re: [nft PATCH 0/3] Fix for exclusive start cond corner cases
Message-ID: <au3a0smZCC0nPSw3@orbyte.nwl.cc>
References: <20261105173713.72238-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105173713.72238-1-phil@nwl.cc>

On Thu, Nov 05, 2026 at 06:37:10PM +0100, Phil Sutter wrote:
> Patch 2 fixes the issue xelra reported in [1], patch 1 fixes a related
> issue and patch 3 extends scanner debugging output a bit which helped
> when analyzing the bug.
> 
> [1] https://lore.kernel.org/netfilter-devel/VPAY0CnKhCaOKYE6oo_AU7sR5MaGIGzyPkXi00RlaucbyN78KYBqK73XfyJ-yyXQENIvvXeFJq_fNrYbJuW8LcqZvZyf4J3kr66jvsojxCU=@protonmail.com/
> 
> Phil Sutter (3):
>   parser_bison: Fix for comment following exclusive start cond
>   scanner: Fix delayed start condition pop logic
>   scanner: Add start condition debugging

Series applied.
