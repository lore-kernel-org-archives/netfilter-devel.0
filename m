Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EC5538D68;
	Tue,  8 Sep 2026 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788871207; cv=none; b=CEUor2odbPnHPVN+qrXBOJQJeEy0KuytfcKqmkIh98d9EbDzDggRS0qEjAn3kM/GDX3yK34JbIyNX70FlR+4PSky16b6jzMRROKGkVPXRPYEEFlaSPCS0YYHGG2oI/vDZalSyeWDzfojK/ndHL4CmE+qu2oaFG798mA0axsCvgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788871207; c=relaxed/simple;
	bh=/JXhB81t4vh165IPnOGrXiPDLavFd40GSsb8yFVj8Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUPG643HMNms8L7xmVtXqKqkT6iujkjMGqyU7JmWk4c1hXQ7qc6r6cLUsv9x0lS6JwuEnguigXfiXxXWMEa1Sf5XsV/fywwhu6igBCZVdGFj3F606F1MEkzYGjtoSZNJROwD58ULjcQoPAW6KyFXGh5XGiHhLUl4dk2lnmwQ2/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MSoNjosy; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MSoNjosy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dEiRV/rRc+sTuGxfDNPLfPu+P8vNEri9cYQaNM8FeaE=; 
	b=MSoNjosyxyqLFRrh43m0rX9qZ2MUF0CkaWUJXnlAeoxUwMkZntjr4gopVUsnpcxUPyKgYUr1ECL
	2Np0kHaaNYJmompzNuYKWE8geRaKXb82iuCAh7YgHh2f/FXNsdKNnEMLm5gTCPVaI4kELVYewmyBd
	r9LVukqv8aL6lSmcZ4Dk6/HF5IIlnXqLLZf35Wsq4WxFzDZH9vnF9mcpjtNyW0xlA+umCa9dp+myN
	P+uM/jfONFPjNjf3aZFmDFHb+zScxFvpEg15r41uMYDn4FvXOcnoiRxmdwcpfO/na6VFEuBfiXgCO
	/rMgT8KhfdFcmPU/nJbLHj5/Y+cRWrxheVfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3v7H-0000000Bs5u-2BX7;
	Tue, 08 Sep 2026 20:40:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 22:39:59 +1000
Date: Tue, 8 Sep 2026 22:39:59 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqACH2VVNGmgW-5B@gondor.apana.org.au>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
 <ap-dYotn2QqdTVqf@strlen.de>
 <ap_PlDqTNOnB0Y83@gondor.apana.org.au>
 <ap_budC8D-k4k67v@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_budC8D-k4k67v@strlen.de>

On Tue, Sep 08, 2026 at 11:56:09AM +0200, Florian Westphal wrote:
>
> > So you want to free the entire table, right?
> 
> No, remove all elements. Concurrent insertion is not disabled.

So what's the desired semantics for insertions that occur while
you're flushing the table?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
