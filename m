Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EB7224DC
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984365; cv=none; b=dmmTVX3OAgFzfhf08agvaT3ZpMesYEhObv6fU+beCk9jTbSEmu4NlJz83qhnTZQ2vvo9Bu3LziwLhi3xjdh2CMbRddjK/qvmM8daLKzDGZJLA5EL68AO0fMRfMQUCG90whtR0ARZtVMq+cH1wl7yyq4XTbt/hwZv7o0dis9KPjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984365; c=relaxed/simple;
	bh=VNfq04Dmp5NyhWgy9604dzEV+UjWognCfwYOmiISKY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jElECoTmrLaZR3Gco0DLOoPD5INc8xanAilP81AQUGp/IPQ3V3skkQKF8Wg+UyqjX8F9NxhIRu9Wr+QhMwykkB7+OYV0mLM1jxWG8hP9giDTPAHSKzDRaXs5WzWLVGHCcTauoPeP9mWTyA6Sg+3iiG2p82VSmaia/FdKTV35TlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riv2u-0006Nq-9t; Sat, 09 Mar 2024 12:39:20 +0100
Date: Sat, 9 Mar 2024 12:39:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 1/7] tests: shell: maps/named_ct_objects: Fix for
 recent kernel
Message-ID: <20240309113920.GP4420@breakpoint.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
 <20240309113527.8723-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309113527.8723-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Since kernel commit 8059918a1377 ("netfilter: nft_ct: sanitize layer 3
> and 4 protocol number in custom expectations"), ct expectations
> specifying an l3proto which does not match the table family are
> rejected.

> -		l3proto ip
> +		l3proto inet
>  	}

This can't be right, the kernel must reject this.

99993789966a ("netfilter: nft_ct: fix l3num expectations with inet pseudo family")

was supposed to fix this up.
