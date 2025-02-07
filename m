Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241281DF260
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929604; cv=none; b=b1+c5BJmvpyfGFx95FRBX644FbuHCbY1YoGlnNHVd8dRQ7Tg6B4WPB2A74Ha5ziJSM7mDXgV+UT0/M4TxXk+5pdfb1p986Oi5f8Oifs0My+y63SaBy6eB7kyBMcd6bvq/ZYMI3PdeeD/tK9KB6/4W4P2d7gy3UXDZMGdtJOztH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929604; c=relaxed/simple;
	bh=zeTPd/m6P+LLrYOKLD/nW3syw9UZ/V8xIn8ePNR0+0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGZRNbsAqoJmah+potPFj8DK5FEcHEsjOfsHbjejSNUgYvmC0tg3f+r+bYoZKR+fiLR+XoyLzvsAyqZG0b+6nqg5kF+M8NFjXpI7DIDvMDmlzZorXURPFCCQTsSB/04IRlvTEK5ZmGJZUrUcj5bPwRSLUIqdSrjIxKGJ18OWBoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JV21aIhP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rrr+U6Uz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JV21aIhP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rrr+U6Uz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 54C0D6037C; Fri,  7 Feb 2025 12:59:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738929599;
	bh=ZXW7QVQE5ofSYMw5pLGPtAUpfYL/7qcKvEjME/osF/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JV21aIhPtZECzqKxQ+hnjwNGP4kokBaTLLObF/1o9b8JUeQjV3mfNhXjbqS0yJQgv
	 r0HpGPR+fU834CN1ELrfv/RtnrXRno5zIYOK49FhZcIlF/L/KPun+6VKvI5Tm22zd9
	 19odgwhWEaqMdzdvhu5GK6R4tTytm9k6cctLO7NdXcU1RXCnZWrkZFiTK4ZzoKsZ6Y
	 2rcJH3llDG/d4Ggv/V7aJfaN7Ln064JKXjC/HaZJU5EWkSQpPXC/O3SfmySSVsQ59E
	 4rJvORCvIaDjwu+nenRORUH2hFPOx+6yQ8EHXA2SwuhaeGq5ZErjKoXNDTrAuO0bsf
	 N/YBIdyAvdwjw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B29CA6037C;
	Fri,  7 Feb 2025 12:59:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738929598;
	bh=ZXW7QVQE5ofSYMw5pLGPtAUpfYL/7qcKvEjME/osF/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rrr+U6UznqARu+2iW3ggMuCbnJtDePtK+rluy1Oh/YCBbSSwfu66ivFHCyHkMeQ7H
	 kOpoqMJb6LZcfh9ircnuCkMaQ8fLSiCv4EHXSa+Cxsss+4Yh9pMlHKVVU+uoH33cqy
	 pP5eAL2/3yrjybBBvmyvEurQ0Ek+2n0qiOHwd/hRW9xUCdRkyWJt9dq1fQ9ScFwNg0
	 1p0l3/N2GJUmnJqdSTreXxf/EG2sTNjfMn6lAgfA33W/hdFigzZKQdzehE3hJeMk8a
	 cOP9tN0pKTEAOssOTfWYMCf/q+IThk/KTHRq0vUtia/pPbRUqXj0mGWzUOkqJZbdg+
	 ArXMF9aaCmpnQ==
Date: Fri, 7 Feb 2025 12:59:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools 2/2] conntrack: prefer kernel-provided
 event timestamp if it is available
Message-ID: <Z6X1vH7JIn0wmYOG@calendula>
References: <20250109131541.5856-1-fw@strlen.de>
 <20250109131541.5856-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109131541.5856-2-fw@strlen.de>

On Thu, Jan 09, 2025 at 02:15:37PM +0100, Florian Westphal wrote:
> If kernel provided the event timestamp, then use it, else fall back
> to gettimeofday.
> 
> This needs a recent kernel with
>     netfilter: conntrack: add conntrack event timestamp
> 
> and net.netfilter.nf_conntrack_timestamp sysctl set to 1.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
