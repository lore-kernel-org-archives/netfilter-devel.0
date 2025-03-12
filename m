Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0451A253F05;
	Wed, 12 Mar 2025 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741793925; cv=none; b=oe5PtaS70J4pxcmXpPPHElk1KXnsWPsV7O5+2iIBLm8Ku4fv7C7OaHBxnEp/PpQ1lCQwxTR6C16dcheyb0qzAzf+CC7utyWyLuP4FwR0UsUPzZrIgy8ZI9CvqWMEcFRpLskGAHZZqpUF3N7YnRO0Pb/ABbc6GEeb4JWzus9Y6Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741793925; c=relaxed/simple;
	bh=2Z0v32n+22n+JQBW/HI68GTmS5BWGoT1dycaIbpjgTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4QLE2gPZbAe45mGvnD4tdPIN6YCgdrW76Hp/aRZ4ovCh9LwSp/CTADdm8ebGYoj62Ecuqp+hVWlebC9L8zljeu054BWbBDYo2V7JuXQ+nshDSps7xg5NVc6e4GdF8NHjGbocu78yBsNdP0XsdbO4l5DaacPSTsw1DQo4ReIgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CvuPBdHX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CvuPBdHX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CvuPBdHX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CvuPBdHX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5AD2F6029F; Wed, 12 Mar 2025 16:38:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741793921;
	bh=2Z0v32n+22n+JQBW/HI68GTmS5BWGoT1dycaIbpjgTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvuPBdHXNBWN1XAq/+LmaZDQ62mpXjUsr/5bsuP7hDmCN0F2Su4gyklZU0+GAdR5c
	 ti0dBbWIFsivGs6PcsV2LcmWVuILuPI9oXt8GzsAxLtd3gIByi6YP5TcpaVcvTbJNl
	 O457WQ1YTxxgxOM5S6dcUno45c+WEzWIxu05EALNhMYRyebe8paZ77rT7ZAwDCNStO
	 97QJZV9tRcgd39yG014M2xAJHwuifjvZuhS4MtegcbdIdKGeEGn+y/8KqleKKHtgZi
	 Du/mmJo4XSqzo9CwWnbQypvm4UyxZlLDdMweVkwzx5NL8kg/18dg4lALfXWo8R9DC6
	 adddYcT13WHVA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D8BFC60297;
	Wed, 12 Mar 2025 16:38:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741793921;
	bh=2Z0v32n+22n+JQBW/HI68GTmS5BWGoT1dycaIbpjgTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvuPBdHXNBWN1XAq/+LmaZDQ62mpXjUsr/5bsuP7hDmCN0F2Su4gyklZU0+GAdR5c
	 ti0dBbWIFsivGs6PcsV2LcmWVuILuPI9oXt8GzsAxLtd3gIByi6YP5TcpaVcvTbJNl
	 O457WQ1YTxxgxOM5S6dcUno45c+WEzWIxu05EALNhMYRyebe8paZ77rT7ZAwDCNStO
	 97QJZV9tRcgd39yG014M2xAJHwuifjvZuhS4MtegcbdIdKGeEGn+y/8KqleKKHtgZi
	 Du/mmJo4XSqzo9CwWnbQypvm4UyxZlLDdMweVkwzx5NL8kg/18dg4lALfXWo8R9DC6
	 adddYcT13WHVA==
Date: Wed, 12 Mar 2025 16:38:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: kadlec@netfilter.org, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: xt_hashlimit: replace vmalloc calls
 with kvmalloc
Message-ID: <Z9Gqfaq3MENHviYG@calendula>
References: <20250126131924.2656-1-kirjanov@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250126131924.2656-1-kirjanov@gmail.com>

On Sun, Jan 26, 2025 at 08:19:24AM -0500, Denis Kirjanov wrote:
> Replace vmalloc allocations with kvmalloc since
> kvmalloc is more flexible in memory allocation

this is applied to nf-next
