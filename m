Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240913;
	b=vtsPwnJHDwnporNhFsS27aY/XFlUkXfZxDYDK1Eki7EPNGzdYX4m0wxHpeZ0gWJaPQ1y
	 13yEqjuDAlTX2N5kbOcr0Iq/HzC9U6dLbqVDCxhvkAOKNK5YrK9ApiOpifo4gLmMNLi9z
	 mX4OAQUhWsDsL4ejeNqlSJEiwsb25L6HCsNES0hbWd12mJYnL6zjTmrO8SixZVXPhGSrS
	 G3Z9udeUbUBlEzw+nswvzUXW5nTP0l05qA4H//zDs4XlMLPgtzWnuQpnn10MkTjYyOGPi
	 Gb+nA6WnAxF5XfM+oZXKtJpAs6ke0BRHcCDFjgtjK847WJy5ECxQAHfEhI78YMsODqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240913;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yahw4v5Elmvu7L/0JOLznN+YZDJXY7QADRLl/Age+IU=;
	b=ISZAY5bj7btzca3LK0VF9Pvk3czSGdiEtCz4Fa1IbH5Q6jeHBxcvVVcr+Vl5hM3YiQz9
	 Umrzy8uuzPWrRHGUe+NdYl9E9k8MyHUgQgD38sQfTcK+Aeqc94BsNIJ+EbYkeBggXpRKK
	 +tV6AYFYdPB3j2j5p6xApHx88cK7BjJBRlWKYtpFO5U7QemqEEKbShv1L3oJq8mSzWtYM
	 C8+bcdWYzmIcsKAJc08qUDUFNotkJb9+mBA5C+R5dMG+hBntJih3R69wwaugzllvep+lN
	 IHq4Bt8oZr5GD7r+aCf2D/fmzpIsNscqli6cogjaQRXlsN//N3grWQKvzJmKv1qXjIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7356B606A68E
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 06:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7356B606A68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 79DD0601A0; Sat, 21 Nov 2026 07:01:51 +0100 (CET)
Date: Sat, 21 Nov 2026 07:01:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: nft_exthdr: stop the TCP option walk at
 EOL
Message-ID: <awEzz5uD-pHSFgQL@strlen.de>
References: <20261121055253.1801718-1-ryosuke@ikotaslabs.com>
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
In-Reply-To: <20261121055253.1801718-1-ryosuke@ikotaslabs.com>

Ryosuke Iwahashi <ryosuke@ikotaslabs.com> wrote:
> RFC 9293 section 3.1 requires zero padding after the TCP End of Option
> List (EOL). The nftables expressions that read, set or strip TCP options
> keep searching this padding for the target option.
> 
> Stop the search for other option kinds at the first EOL. Keep the
> existing behavior for explicit EOL matches.

Why should this be changed?
