Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274329;
	b=kenh0VVqIQ5W2JlbXojL81qlLIGMVnp2VcizqybBHoWBfSjCpTYOmvwcYNBnQUa6K1Tq
	 Ho9nFqhnHFv0hvUjRHE83FQcOHKKjWFRWTxomxBf5QGkax9ORniV0/PXu48+KTXBrKsaH
	 D6yrqdb5b03Z/K+cszanvHo6yJjNF50tKrZWQWf9DDIcumQj/l6zoM+Cp6MaIwSbZFqRy
	 AE2UA+EAKYeXWCdlGkJ42736RU6VPugq6KRDtrD12d25bDAYrLiQIkY6ghaNH8QGsq2yK
	 KF7AqbAFfxsReA8/ZiC1nqcnFwG2cYys+BxjM7UCe8habECV/cOjZk/rpolct9W/8FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274329;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=P49yuNL60NR3/BzgJAa/sLPNJK1f5xpi5gVr6DaT8/M=;
	b=fM03iop3gGB1GYHZ9luyl9J7dYynIIEWnXqlcMkK8nBY2vNHqpbdqXucj5lyI4FvG41V
	 Ar5XmzlqnMlzxuSwBCz9IAdG8g/mNec5EHJBSHHEWAIq/avjWJ/nkufeQ6ySSkUy6/KXM
	 P6Gop9h7gLPvudJ5BSS/UQDPz1JvBadSjJDReAfZkNeet6fJSRS1KbN05VHB0xSqU0/nK
	 l3ycjoS1YG5WCevl2p9DeUzUtebD2MgR6UoGkKd06ai2GxQQuSfEcJqkcqTVnZDLgwzt7
	 Va20hLWn1TzbOHYKVkd83m2Ot/JhR8ZN/r7+He8dG61qPtwdmO5wNgX2o/qbv8IqZzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CiB5B2UO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DDFF2606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDFF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CiB5B2UO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793274327;
	bh=P49yuNL60NR3/BzgJAa/sLPNJK1f5xpi5gVr6DaT8/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CiB5B2UOvKNOqsVHpgWOATiZUJBTOFMTY3g2utbB9RrlzjGIy729CMcx/rFqy6DLt
	 j0dkwD6Om/TFJpEdlmTazk/pIz3yR0/g6Wx7IhO8OXXjmIJOcbeEi5TsvKOAW6vlbd
	 8kOmaxsqLYRWOn7rGZkP850cq59QiN2JwTikpM2T09yoO9I+bdEh0hnLuAOo5qRXvE
	 oziXDfpPYN/JoEYCk52bEI5pDh9qsOYsYSk8bbtHgYPne6vrDPfdN/Yt3fHHdysMLX
	 17KmHWOYGMOo68mHxsFYabwZWBMtlChxvcnZD09LKqqftD67K+V04HCRnJtHBQa7JM
	 PY8ZPI6Uml4Aw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2AF4C6007D;
	Thu, 29 Oct 2026 12:45:27 +0100 (CET)
Date: Thu, 29 Oct 2026 12:45:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow
 deletion
Message-ID: <auMx1LbxjrdiVojn@chamomile>
References: <20261029111431.179813-1-pablo@netfilter.org>
 <auMtIQQMWdjm4Bsp@lore-desk>
 <auMwgf0zvDXZ0j1b@chamomile>
 <auMw17-5vPBgaANa@lore-desk>
 <auMxlOnGotXBPVQL@lore-desk>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auMxlOnGotXBPVQL@lore-desk>

On Thu, Oct 29, 2026 at 12:44:20PM +0100, Lorenzo Bianconi wrote:
> off-topic:
> 
> Can I post new revision for flowtable sit support for nf-next even if net-next is
> closed at the moment?

Please, go ahead.
