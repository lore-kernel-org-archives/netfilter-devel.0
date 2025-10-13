Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2F72C0F8C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384830; cv=none; b=XoF18ZxwaJW7Fg1YTWyNCUWuQPGt637l2N0FKaQkyGWX55i10yMjo/wuxVfiBlRkkbPrIHSLiKG0daHx6x5Agpk+wcfqk6OhROh/aO9TDFQJ2CafXjKeLnh3/T3GhJnXGip99/EmPGBni3Z6IogV2lRV0oHnoCbeDquetO6iSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384830; c=relaxed/simple;
	bh=f8Vr4MWkb2UR7SDKXchky5ZEV27ZDbWLUvrx0BUFp3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dElHkxl1IxII1UZS+heNF4Dn4IsV+jxy5LM4iTkHG0HMY54ixXsZfLn44Kkrq7+x89nVjCfc6z16A5Al1zUXG3xcWpO1JqxZlXNQeANV5ErHmNcptMR9dV+lqOffEHFLoVMtGoTLVc9ZZKlKrbU29ggkJ89Lryp2Woh+4siHRaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D5C760F93; Mon, 13 Oct 2025 21:47:06 +0200 (CEST)
Date: Mon, 13 Oct 2025 21:47:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] meta: introduce meta ibrhwdr support
Message-ID: <aO1XOREzSUUgROcy@strlen.de>
References: <20250902113529.5456-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902113529.5456-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Can be used in bridge prerouting hook to redirect the packet to the
> receiving physical device for processing.
> 
> table bridge nat {
>         chain PREROUTING {
>                 type filter hook prerouting priority 0; policy accept;
>                 ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
>         }
> }

Pablo, does the above ok to you?
I am not sure about 'ibrhwdr'.

Will there be an 'obrhwdr'?  Or is it for consistency because
its envisioned to be used in incoming direction?

Patch LGTM, I would apply this and the libnftnl dependency.


