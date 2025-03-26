Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23A2188587
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 20:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743021215; cv=none; b=YbR2wTyzXUi0KYV1oWkg7w5CSrHEV4YqJEq4+D9fVE/esstHNWjgpIfc9WGXqpFBvvac8XFSAhw74LCibMo+55Lo9NNqqjfK5uDR936PPJNmx5j9KAPwf4UGOogDNfahNQE/6UOP9vDR2MQRKPoPLFQ2ARC1t329y11JSC23llQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743021215; c=relaxed/simple;
	bh=zbjWlX7WEKG/e4iZqmQmgpUTIB4WaXKTHRFs+N/vYWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iszCQjbh3AvfVJ743ho+1OEVrNBU/qWHTTw4qJ48u/6x79ABDpwcLEgJ/AdPNN6zQN5/sQiDiRXnkZQJbMYUrG03lw3vEMQPlfiGd+8KY4/90ieJ1RRvFg4fAZW70HNVJB4RO8YLiBVRaod39myIC61BbXlo2Q04JgW8oTBeKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txXRF-00018H-1d; Wed, 26 Mar 2025 21:33:25 +0100
Date: Wed, 26 Mar 2025 21:33:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 4/4] src: remove flagcmp expression
Message-ID: <20250326203325.GC2205@breakpoint.cc>
References: <20250326202303.20396-1-pablo@netfilter.org>
 <20250326202303.20396-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326202303.20396-4-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>  	EXPR_SET_ELEM_CATCHALL,
> -	EXPR_FLAGCMP,
>  	EXPR_RANGE_VALUE,
>  	EXPR_RANGE_SYMBOL,
>  
> -	EXPR_MAX = EXPR_FLAGCMP
> +	EXPR_MAX = EXPR_SET_ELEM_CATCHALL
>  };

This is strange, why is EXPR_MAX not set to last expression?

Perhaps this should be changed to __EXPR_MAX
#define EXPR_MAX (__EXPR_MAX-1)

like we do elsewhere so this doesn't have to be
updated all the time?
