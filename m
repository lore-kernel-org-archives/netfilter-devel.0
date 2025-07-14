Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77124E4C6;
	Mon, 14 Jul 2025 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752499842; cv=none; b=ghzXg0Z1VuurkSU1HL/1Xlsa8VQJXG9vXJEoLXUzR+QTpw7skbviSjn9OgMF+HIm5iQ0JahJ3rRzUQwS2nuqUwGoWDqeYev+iAiN5zhquSnVlAuEQmmrugwZlJorSeSjEyULuX+x6A4iCPJlt3MjUrdZr2eDp9tByTYP/7WsBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752499842; c=relaxed/simple;
	bh=EM19l6HbE2bY5sLDkmljRRJiM+qzhyfBbeg5zGea7z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkPpQiOhtdrNk9j/DlshssHupj5icN+hm5hLuulyTEkjrhrfk8P1q2o4vKFCHbsohbRa6Fc9JNB5rLjQJ0TDHPoR59/n/BfMDLiqNrxEZtVr0IPWnQ941jKj5GEjl9wjIuvgkO7A5k2xLML8tOyduDJcrPVrKOb7qlx4LJCBrmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cM8zkV6r; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hTj0YU13; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cM8zkV6r";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hTj0YU13"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 30F3160293; Mon, 14 Jul 2025 15:30:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752499831;
	bh=EM19l6HbE2bY5sLDkmljRRJiM+qzhyfBbeg5zGea7z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cM8zkV6r+91jw3hUrH9/hwtnZmjoS1Ej7CXg9UKiDEtW++kDVHb+1I1zPS0nReTkS
	 QlacZ5TsH9nVne8nblthHd4bixhK05oxVSJRNK2BUiKYg+NDRxKiiC3T1uyYADtkI6
	 KFifGU6eiXDJbjG6+eeVBBWaOimssboLOQSaiaRVi56v/Y0MoEFtDoB3CRKd5zeGwf
	 msW5Xcexh+2vHsRw2DBFFBGoZGnGx269h1Cota/gmffFrg7BMq8fh0V0Whx0MXoboW
	 R7UsP+bLAfQo7Jya+U4NYPXXxblpWTsgeRQn7gppfYueJWPvD/KmHUX6SH9KA5w6cC
	 hV1wD1+lgCK9w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B27F6028E;
	Mon, 14 Jul 2025 15:30:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752499830;
	bh=EM19l6HbE2bY5sLDkmljRRJiM+qzhyfBbeg5zGea7z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTj0YU13NB/SwNmTdqitX8duRqsG/FGuF4LrmN0CpA8qESZttVyoxMgyC7396Nevb
	 oKhevpTbhEPDAzbSN0PXmRNUEap3eqPsKlFSiZe992yQIrENbOpQhGfjJ/gGaSC89r
	 D5fHgWG7DEUoh2v9qISFDloE49gR6gGmueidcbcSILKlrERXOzxkgV85mkmaDHDQAO
	 RoeTOLvgGvvCPj5anql2P74ZaVxRrh+C+5t1ks68gKDgMYVNt0qQxAOa0gQamxb+At
	 17QJhkD4f3oOpTLnEi4PfxIt+faw2SBWzpsFQGh5ulJCA54V9N5CSb7k+vlnKbZ1sa
	 hJm61J02CB9bQ==
Date: Mon, 14 Jul 2025 15:30:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	pavelpribylov01@gmail.com
Subject: Re: [PATCH nft] doc: expand on gc-interval, size and a few other
 set/map keywords
Message-ID: <aHUGc_B7aUnrbv_m@calendula>
References: <CANnZF1bKkHctvnpG6JnhtMpUzj6FC5crn1bDqt+eq-G_+mR_Eg@mail.gmail.com>
 <20250709230800.30997-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250709230800.30997-1-fw@strlen.de>

On Thu, Jul 10, 2025 at 01:07:52AM +0200, Florian Westphal wrote:
> Reported-by: <pavelpribylov01@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
