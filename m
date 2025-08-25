Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6505235041;
	Mon, 25 Aug 2025 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756114543; cv=none; b=F68D2wgij1E5W3vX5Rsit6J1hXAo7jRVsS+MChity98DD8hbH7ugAuiuOIlz1A4oJxB7MNN9/2PUoPPcDwea4uwbc6mCOArM//Xe+nPaq2dXB/tnBCKEamO4Tfc6yQW8rxluC94pvKScIYcWmBHAqP1+xtQRVGK8FGcdoi+J1yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756114543; c=relaxed/simple;
	bh=zaL/gEZPUvRkrqggKJeihJBuq6o+SQEEPHjLdF99uko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WAmi1r4njG/U25U8pZO/5cJ7RThJpFF5kmumsR4mUHa2vP3hDdDCmCAqu2bWOttGniThiRYlU2E4TIk0kGn618OXZ3VT52VMLSbi9BcC7ZTucryAr8SJNSE6lPmeUy+G6BgyDPcogokOIKtd+ZqOoJwavw/VoWGODRkeqrJlGMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9BDCF60298; Mon, 25 Aug 2025 11:35:38 +0200 (CEST)
Date: Mon, 25 Aug 2025 11:35:38 +0200
From: Florian Westphal <fw@strlen.de>
To: S Egbert <s.egbert@sbcglobal.net>
Cc: netfilter@vger.kernel.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: repeated 'add chain'/'delete chain' 5x and ...
Message-ID: <aKwuatk_6Ji8VhO-@strlen.de>
References: <14bff92f-ba0f-441b-ad0c-241cb4716c33.ref@sbcglobal.net>
 <14bff92f-ba0f-441b-ad0c-241cb4716c33@sbcglobal.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14bff92f-ba0f-441b-ad0c-241cb4716c33@sbcglobal.net>

S Egbert <s.egbert@sbcglobal.net> wrote:

[ cc -devel ]

> During my vim syntax highlight unit testing... I noticed a behavior of 'nft'
> with regard to repeated adding/deleting same two sets of chains 5x.
> 
> Running latest nft v1.1.4, Debian 13, Linux 6.12.41+deb13-amd64,
> 
>     add table netdev T
> 
>     add    chain netdev T A { type filter hook ingress priority -500; policy
> accept; };
>     delete chain netdev T A { type filter hook ingress priority -500; policy
> accept; };
> 
>     add    chain netdev T A { type filter hook ingress device eno2 priority
> -500; policy accept; };
>     delete chain netdev T A { type filter hook ingress device eno2 priority
> -500; policy accept; };
> 
>     add    chain netdev T A { type filter hook ingress priority -500; policy
> accept; };
>     delete chain netdev T A { type filter hook ingress priority -500; policy
> accept; };

Thats unrelated to the add/del below.

>     add    chain netdev T A { type filter hook egress device eno2 priority
> -500; policy accept; };
>     delete chain netdev T A { type filter hook egress device eno2 priority
> -500; policy accept; };

This adds empty egress chain for egress, not hooked to any device.

>     add    chain netdev T A { type filter hook egress device eno2 priority
> -500; policy accept; };  # ERROR IS HERE

This asks to update the empty egress chain and add "eno2" as new device
hook.

>     delete chain netdev T A { type filter hook egress device eno2 priority
> -500; policy accept; };

This delete will fail because the previous update request (add a hook for
netdev chain for "eno2" device) is still pending and not committed yet, so
the device name isn't found when searching the basechains hook list.

Trying to support "add X/undo X" patterns has led to dozens of bugs
already.

I don't think we should support this, the logic is complicated enough
as-is.
