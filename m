Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F753AFCE5
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337749; cv=none; b=RWD5QOTL7FZtUnSHulwnIru1RAdhhTTatIbOWw2MNRdu7zQua50lon9mrHKfbp+h7Dvi0lekh8Nng6k8Kx5uGNTou9wK2MGcnnol/QghwFoMghkNXPsMQQFegKYyN9V3kY1cWiyI71Dq1Waq05wqPz5mZqcR9+Ym9GQ4xmswcdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337749; c=relaxed/simple;
	bh=2BEq93IF3/4Ro/l2Vzh9nBjN7tnEPLsMXfcFeShYLO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frZgmJUvgdo9eG9ukI9tTrlVfaERsgbxB3kjhvfBibdDfcKmySpYol6oYbjFpSl33kV8Rxb4RuKioN+zrlL22qxRo8+72v4pkULIrNlZc9aMmjA/C9a1XVL710L7EyMCd/+Aqp+F1XRZK2sKjDO3mqF7yGGD1lRWAnpzprbu7AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F129A60293; Wed, 29 Jul 2026 17:09:03 +0200 (CEST)
Date: Wed, 29 Jul 2026 17:09:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Jianjun Chen <jianjun@tsinghua.edu.cn>
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: use UNACK timeout for
 non-closing RST packets
Message-ID: <amoXj6UGRW8SQXBT@strlen.de>
References: <20260729142802.3572612-1-zhangmh25@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729142802.3572612-1-zhangmh25@mails.tsinghua.edu.cn>

Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn> wrote:
> Commit be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST
> matches exact sequence") keeps an established conntrack entry in
> ESTABLISHED when an in-window RST does not match the expected sequence
> number exactly, so the endpoint can validate the RST with a challenge
> ACK.
> 
> The timeout selection nevertheless uses the CLOSE timeout for every RST
> packet.  The bug is that timeout selection is based on the packet type,
> not on the state transition result: even when RST validation keeps
> new_state in ESTABLISHED, the timeout is still forced to
> TCP_CONNTRACK_CLOSE.
> 
> Linux TCP independently rate limits challenge ACKs per socket.  A second
> non-exact RST can therefore arrive after the first challenge ACK has
> restored the timeout but before the rate limit expires.  The second RST
> lowers the timeout to 10 seconds again while the endpoint suppresses the
> second challenge ACK, allowing the conntrack entry to expire while both
> TCP endpoints remain established.
> 
> Using the ESTABLISHED timeout for non-exact RSTs would avoid this short
> expiration window, but it could also retain stale entries for the
> five-day default because conntrack cannot reliably match the endpoint's
> exact TCP state.
> 
> Use the UNACK timeout for RST packets that do not move the conntrack
> entry to TCP_CONNTRACK_CLOSE.  Exact-match RSTs and accepted RST packet
> trains still use the CLOSE timeout because their state transition result
> is CLOSE.  This avoids the exploitable 10-second expiration window for
> non-exact RSTs while preserving the short timeout for RSTs that
> conntrack accepts as closing the flow.

Hmm.

>  		timeout = timeouts[TCP_CONNTRACK_RETRANS];
> -	else if (unlikely(index == TCP_RST_SET))
> +	else if (unlikely(index == TCP_RST_SET &&
> +			  new_state == TCP_CONNTRACK_CLOSE))
>  		timeout = timeouts[TCP_CONNTRACK_CLOSE];

Is this needed?  If new state is TCP_CONNTRACK_CLOSE, the existing
else branch will:
        else
                timeout = timeouts[new_state];

> +	else if (unlikely(index == TCP_RST_SET))
> +		timeout = timeouts[TCP_CONNTRACK_UNACK];

AFAICS this is enough:
-       else if (unlikely(index == TCP_RST_SET))
-               timeout = timeouts[TCP_CONNTRACK_CLOSE];
+       else if (unlikely(index == TCP_RST_SET && new_state != TCP_CONNTRACK_ESTABLISHED))
+               timeout = timeouts[TCP_CONNTRACK_UNACK];

Could you test this?  Thanks!
