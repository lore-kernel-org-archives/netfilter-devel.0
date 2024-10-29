Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558EF1DC06B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237255; cv=none; b=S9i9/pKjhoUzQ8dIO2AL9NETYHDmWAjHcGo2MfyMnIjGB84WNMVfBsxovPWB/qXhb3GPBuGquqNTAqthE8KQELckVyqNyB7TQIcH29SWMJ/E1amx7fmr91IiB6DEKd6zsInh74Ol1k2+p3invf8HeUzQSypqkooKMm09eWxG6Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237255; c=relaxed/simple;
	bh=+TQ54aqX3L+948xR2/1KogTQ4PF7FXDWqeUB++K4Tog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UecO7MbisAp7msw7XFwdAuibkvuss74TLHO/WFKYs2Afe7U8VQ9ilzKp2bGCWlSILEubOY7r61zgc7SZ/m1RToOf5VST0htqDRpakb0RQNpnR2fnT+hBYjlewMHsgOKf8xcG/Xu/psBReUkuTJx1uRhJiQXrldh+42DCszRWhtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51250 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5tkF-008e3f-NE; Tue, 29 Oct 2024 22:27:21 +0100
Date: Tue, 29 Oct 2024 22:27:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <ZyFTNpldqHmUdQh2@calendula>
References: <20241029201221.17865-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029201221.17865-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

On Tue, Oct 29, 2024 at 09:12:19PM +0100, Florian Westphal wrote:
> Monitor test fails:
> 
> echo: running tests from file set-simple.t
> echo output differs!
> --- /tmp/tmp.FGtiyL99bB/tmp.2QxLSjzQqk  2024-10-29 20:54:41.308293201 +0100
> +++ /tmp/tmp.FGtiyL99bB/tmp.A5rp0Z0dBJ  2024-10-29 20:54:41.317293201 +0100
> @@ -1,2 +1,3 @@
> -add element ip t portrange { 1024-65535 }
>  add element ip t portrange { 100-200 }
> +add element ip t portrange { 1024-65535 }
> +# new generation 510 by process 129009 (nft)
> 
> I also noticed -j mode did not work correctly, add missing json annotations
> in set-concat-interval.t while at it.

Thanks for fixing up tests.
