Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE75263887
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 08:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856041; cv=none; b=YBiJRuonBWoNeMWHFt6tAM/stpKtDklRHMTAtyodCClTpzZ4KE/Orvafo6glnDBd82ZbPyVooJ0pmsQpZ42w6DcncSBs7J8vSMD1371c0DbKASWgwVuuC3+QFY3nr2KiCht2BLHVpQrOc+PX5mLKjZ2d3PJ3nyXTSTpedklwwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856041; c=relaxed/simple;
	bh=IE4k7Ro+fgaM62G4t+rzw59+XkkKeLUVg66dALj6nHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aa+JkiWJVvJ+HcDJdrl9y1vmKyRK84ES3yi41DW96WZhMJOdX3urNZkTDBJ5BluvpBKlfrOFJGejDOONHhfX/d8ZRKHRShw74hUEKknecShEuK/9Yqb9oal6rsQgmdq0lP2pigVFbNODkPELTL+g12NtxkVlxIWMJHfyvrUXPVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K8qOTYYq; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K8qOTYYq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K8qOTYYq";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K8qOTYYq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7876D60298; Thu, 13 Mar 2025 09:53:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741856024;
	bh=MPhiFG9Ydcbp8MbZvmWr9fK6YKp6kmKARDQR4pnFrHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8qOTYYqBa0FaewwCK8JrmElW+8f5DVrGmFDOsbgFBHUvPaAhDY9V4hwl8KtuvcPb
	 nlAgqD9thPgV/GjPHeWfdvRplN19rC4oBRwKDfhmoDG7pZPqM8/hluBMFBEUqIyXxn
	 ecxpTz/9e763a9MRqrhTTvAUuGINX+7dCELgyq+1QG0PduIrVUq10MJTRvskE2550w
	 SyHhqQt+fJoYdkXNIeHbGbnAQdBulJaDALFIYuHZwnKHzsiRj5G3b97PXF286FeVBd
	 1HxeFpqI70jGXKP02TlxFqlwXiUOUSbnLHMjjOgfc0amj/34Dxq+Cx2CeGbjEdv/ao
	 EtJ5+pLyeRCBw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E469060298;
	Thu, 13 Mar 2025 09:53:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741856024;
	bh=MPhiFG9Ydcbp8MbZvmWr9fK6YKp6kmKARDQR4pnFrHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8qOTYYqBa0FaewwCK8JrmElW+8f5DVrGmFDOsbgFBHUvPaAhDY9V4hwl8KtuvcPb
	 nlAgqD9thPgV/GjPHeWfdvRplN19rC4oBRwKDfhmoDG7pZPqM8/hluBMFBEUqIyXxn
	 ecxpTz/9e763a9MRqrhTTvAUuGINX+7dCELgyq+1QG0PduIrVUq10MJTRvskE2550w
	 SyHhqQt+fJoYdkXNIeHbGbnAQdBulJaDALFIYuHZwnKHzsiRj5G3b97PXF286FeVBd
	 1HxeFpqI70jGXKP02TlxFqlwXiUOUSbnLHMjjOgfc0amj/34Dxq+Cx2CeGbjEdv/ao
	 EtJ5+pLyeRCBw==
Date: Thu, 13 Mar 2025 09:53:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [bug] nft asserts with invalid expr_range_value key
Message-ID: <Z9KdFVQxe5xcW0O4@calendula>
References: <20250313084909.GB31269@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250313084909.GB31269@breakpoint.cc>

On Thu, Mar 13, 2025 at 09:49:09AM +0100, Florian Westphal wrote:
> nft -f -<<EOF
> table ip x {
>        map y {
>                type ipv4_addr : ipv4_addr
>                elements = { 1.168.0.4 }
>        }
> 
>         map y {
>                type ipv4_addr : ipv4_addr
>                flags interval
>                elements = { 10.141.3.0/24 : 192.8.0.3 }
>        }
> }
> EOF
> BUG: invalid data expression type range_value
> 
> Q: Whats the intended behaviour here?
> 
> Should this be rejected (first y lacks interval flag)?

Reject because flags interval is lacking.
