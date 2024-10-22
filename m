Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550F2BCF8
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602446; cv=none; b=DlQUwUqMnv5TqN4Jes/s99YKWnU5dPwivABRB8xQVPe7l6zOt9+KM7i0rMX4fWOi3OxUT66dpiDpdZz4asuR2UATCv7pUTBy7QIwjz5/5+bfuMcr1xFT9HOJKn8WIeD75RFc5QbipGUlJyIaR53dPsQ+64tfXL5vrl9e0RRfUyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602446; c=relaxed/simple;
	bh=+PTQfl7TaoEaTuQFMZH1MzK0E2/8OslZ25hxt5bTVc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnvndXYmEg1cCJOpWMbNohQhfxAcvbPoI0SBrUogQsGK3orcmj6b9JSe7tt/hJ317ffZ/BKyes2nO1MCSY3j8MGUkzDuT9xwfLhrWObZks94KNhl7r3FeFojpjNIyfx9rLGS2SCJT7VVwU1Cy652QG4FF+D/woGM0MXcKy8t6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56652 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t3EbY-00DlKR-Fg; Tue, 22 Oct 2024 15:07:22 +0200
Date: Tue, 22 Oct 2024 15:07:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH] src/utils: Add a common dev_array parser
Message-ID: <Zxejh_KRhd81uWSC@calendula>
References: <20241016164223.21280-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241016164223.21280-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Oct 16, 2024 at 06:42:23PM +0200, Phil Sutter wrote:
> Parsing of dev_array fields in flowtable and chain are identical, merge
> them into a shared function nftnl_parse_devs() which does a quick scan
> through the nested attributes to check validity and calculate required
> array size instead of calling realloc() as needed.
> 
> This required to align structs nftnl_chain and nftnl_flowtable field
> dev_array_len types, though uint32_t should match the size of int on
> both 32 and 64 bit architectures.

Maybe go the extra mile and add an internal object for string arrays:

struct nftnl_str_array {
        const char      **array;
        uint32_t        len;
};

and use it in chain and flowtable?
