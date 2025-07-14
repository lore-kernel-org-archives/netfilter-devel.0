Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67744131E2D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501204; cv=none; b=OdY3uTcnF8L8FDzaNkRIewKNBgKI34XmnMhC3dBkOWEmPQDF8gtH7nwaC++OFamiiLv0pm7E51Cvbsca7ikJKs/0AycBP32jQxskGHQz+jTjITcKGuyGBIyzUfaaMmF8vmEudmQXlKqpAoghLh9hV0+bnDeUwiq3fbIg96Qa70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501204; c=relaxed/simple;
	bh=aiEsCaIR9rDb/zvzkXqBRjYn8EFBIm1RgnS95vVuQts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMCK3W8e+ITmlVoJRAWdBK/cZHTy+hL62773PUmTFlXD3Ega1gz2Rd8aNJe3/5CApfzRMp3m9n61IC9A0ZKV43awAKxP6YFuyutZvVpMfImotUa4FAsKDKkBY2EBAA/EwbWyuIGc4Onz0KDYOKNdoux3xdNAJM2qg6u8RmjrAhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CpFA/4J4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CpFA/4J4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CpFA/4J4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CpFA/4J4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E21626026F; Mon, 14 Jul 2025 15:53:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501197;
	bh=1vI5q22LD8ou6Ki4rG/IZyO2scUS97j1OKB7c6Sq9WY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CpFA/4J47xdHU9Kek/lRGI+5lbopDn/XWA4tN9PWUwtAUDB4F7fPctdBdiude0xKP
	 2s57hK8tcHy6GwKt+OiellYtyKaUoimWfvC03R0MuKmBObl9X9JS3qh3+2Fe42D610
	 ArHvaRqGC0NYMRdt2avQH0EdXSsXgfJeH7CDyMjPxSzv80ydfUseBnc7QadSBYrfkX
	 rU7SVWQeOoaiWDha1Oxis1vdrLaMHLD/8LKZpWsJ4fLpj+DUogwB7WdDO66m4dAhhh
	 7Rlr0CqqudVSCKyJYC7Lx2qxnGMg75OVvYAGIEg832LX8yu/VHOSCQB78bqL2kvNdk
	 dFRdIWzitFpPg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 13B5960265;
	Mon, 14 Jul 2025 15:53:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501197;
	bh=1vI5q22LD8ou6Ki4rG/IZyO2scUS97j1OKB7c6Sq9WY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CpFA/4J47xdHU9Kek/lRGI+5lbopDn/XWA4tN9PWUwtAUDB4F7fPctdBdiude0xKP
	 2s57hK8tcHy6GwKt+OiellYtyKaUoimWfvC03R0MuKmBObl9X9JS3qh3+2Fe42D610
	 ArHvaRqGC0NYMRdt2avQH0EdXSsXgfJeH7CDyMjPxSzv80ydfUseBnc7QadSBYrfkX
	 rU7SVWQeOoaiWDha1Oxis1vdrLaMHLD/8LKZpWsJ4fLpj+DUogwB7WdDO66m4dAhhh
	 7Rlr0CqqudVSCKyJYC7Lx2qxnGMg75OVvYAGIEg832LX8yu/VHOSCQB78bqL2kvNdk
	 dFRdIWzitFpPg==
Date: Mon, 14 Jul 2025 15:53:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf PATCH] Revert "netfilter: nf_tables: Add notifications for
 hook changes"
Message-ID: <aHULyreZ4KBd_gto@calendula>
References: <20250710164342.29952-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250710164342.29952-1-phil@nwl.cc>

On Thu, Jul 10, 2025 at 06:43:42PM +0200, Phil Sutter wrote:
> This reverts commit 465b9ee0ee7bc268d7f261356afd6c4262e48d82.
> 
> Such notifications fit better into core or nfnetlink_hook code,
> following the NFNL_MSG_HOOK_GET message format.

Applied to nf.git, thanks
