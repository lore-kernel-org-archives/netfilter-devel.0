Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FA51CCCA8
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718702470; cv=none; b=D0nI3dL6RiomBJHESbns8KZN3yiNUu1r8Vtsoax3kUSB+TBCuwTFfDO4VlscEynHMLm2cuDXX7RzIpoiPoloAc2ucGfkm1XgInZx8Vp146gRIjY1A06O7WhfswDI4n6wEiGZeOCO/FzHNerXQjF7nQRhz8tBBPiwDoBlVbGJBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718702470; c=relaxed/simple;
	bh=mLOFSjq93y/9ptCTaVoRS0u22qAvaAkxgNBaNUze7B4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hq1dToAvuZrENBHJFXNjrbBXA+Qj9eu2K3okeJRRGXJjAm2P0fwdLkLPgzcK7u8w8hAbmmOK7l6vXiT2FnCv21MlH8Q1vEIZM9q4lR7ALrSEJrYUQoTn4kbtJR0aSTt84aBkW+1fV8yEuHCfMsIpj26hkZVJSt//F2kadtCPJEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sJV1U-0002G0-Ss; Tue, 18 Jun 2024 11:21:04 +0200
Date: Tue, 18 Jun 2024 11:21:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <20240618092104.GB12262@breakpoint.cc>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-3-fw@strlen.de>
 <ZnFENEs7ESGSM2Ub@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnFENEs7ESGSM2Ub@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> May I mangle this to do here:
> 
>         if (!trans)
>                 return NULL;

Sure.
