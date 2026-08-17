Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42032B113;
	Mon, 17 Aug 2026 09:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786958125; cv=none; b=UbShf5uSyXk4fJwMHwVFRWtw9qEkTwz3sd0U+932haVbleNAKVObIlVcE6mwY8yY9eBLVe8vyV+1WDBPyUJMyp/UTFDq3KQr9F+sBzqylQkywss4gNbrFqkxn1fWs7jYKwqh/ndLGmOhppEUUmlVy9QaXjKID5zvauurGu+ugqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786958125; c=relaxed/simple;
	bh=FDGEN4iV+UEKSotouAQnbXmBPyOwUX1/NjjaE9/PvFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQQs5erIqMU33/Ij/Krg7ajS9EqxLF+MkUo0tjFe7CCcEo06kKCK9OJHnV00ggJ0eUwiLows9uIWrLpKPgIZ3Hyyp0kXdpgJOcH3fNyBHr4CBWkc+5LUlsKnw4flLlHQRD1u+Pq9A1MwHimIT3zEOfn2S1NNKSB04JKDMgqx0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w8JUuvzt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w8JUuvzt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y8ZCz0G/UYGDXBAh1IiS9FfjPRg9X/r3V5g+G/4a7y8=; b=w8JUuvzt2s3EWa5VdygLO6Zwm5
	U7uf0InUdyiKkLLNYzu3bCb+ETP8kpiLZZySfAC9S/U6oHhBIBMSzBLDZrbe8SHqHtH1W3+VHXlse
	hDJ3yPzrnR1ud4O0yJ/RaEDF6LONGXn5MqJ3wMOAAB0UQ4wbw29u7H+TIvR5++znDdV1WAf7fUMXZ
	Gj7pG1oVxQ88vCBYlSPBslT20VOXnJgONnatWfRHmOXNi3ZlLg7Oxs5pT+R0oHZFdjdntc7WkOvbx
	d8Ygo/BbTuGjkRjn/2DzEnIcJPxUjb+PsMSsdgvbsAt7C7mvJs2drIxEBiiaFZhcmUES2Qtm1aozN
	CmVD1AHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvtR9-00000005n1m-48o5;
	Mon, 17 Aug 2026 09:15:20 +0000
Date: Mon, 17 Aug 2026 02:15:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <aoLRJ7igR5GTMfuO@infradead.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260816161450.05fd24f2@pumpkin>
 <20260816173159.GB2013@sol>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816173159.GB2013@sol>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Aug 16, 2026 at 10:31:59AM -0700, Eric Biggers wrote:
> As for kernel_fpu_begin(), no, it doesn't do vzeroupper.
> 
> I do think that some years down the line, we'll drop the use of SSE in
> the kernel entirely.  At that point, vzeroupper in kernel_fpu_end()
> would make sense.

Or add kernel_avx_{begin,end} wrappers that include the vzeroupper
in kernel_avx_end.  That would be a lot easier to use than the manual
vzeroupper in every modern user of in-kernel AVX.

