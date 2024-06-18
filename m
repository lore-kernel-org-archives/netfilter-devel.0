Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F315688E
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718702428; cv=none; b=PQT4IAWKs9gXrtsISY13W1vaItZlhDj7lTzd1duw/DeM34F3aIqwZ1wOCnjPXzyy6mH/6ZpebwoHYvH9orVbr9TrRwQoz/uskVvgbXMx3/xCj/FEgQEmZVOV+GdUO66hdV/FXvLhhhsYR8KJNLt1GdoYGcBgTgvNfKeIIBwuZHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718702428; c=relaxed/simple;
	bh=hF8KrAtVgAu5BjriFNG5no+D/AB5bkVdpxswH0vzux4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EifG52hGzKfpoOfoEzfw1Eb9QLUZNkv2y3vals9RDAsmEeqkPdfH+jJfHHIzlUNaqo1UKRpopGJYY8iyEbRIdiQJyX373EI5X6mwi67S/kQ7H/5ppQWSeU4rx32lSE++KX20kYwJrc2j/YvboE3FnGSoQPKBUAhgLgmZJY0+SsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sJV0j-0002Fb-N6; Tue, 18 Jun 2024 11:20:17 +0200
Date: Tue, 18 Jun 2024 11:20:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 01/11] netfilter: nf_tables: make struct
 nft_trans first member of derived subtypes
Message-ID: <20240618092017.GA12262@breakpoint.cc>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-2-fw@strlen.de>
 <ZnFFHIcI1HRIDzbh@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnFFHIcI1HRIDzbh@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Maybe I can get this series slightly smaller if
> 
>         nft_trans_rule_container
> 
> is added here and use it, instead of the opencoded container_of.

Sure, no objections.
