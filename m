Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E62751C04D;
	Tue, 29 Sep 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790692596; cv=none; b=dtYaUwyh43IifeBPpOO1SO1pif2AB9IyCISVGphFgRATiQ3fkQZWyS5Ig8/jXRZ5JPoZFfwprD/3KrHPQbjYArF7gxW8D16SfC831tg4uROPxJQO2m5dxPBGmJOqjPGFWq1mOqN9msgIPfJYMGA1o5ZlPhfF9IGetGjoEAA/GVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790692596; c=relaxed/simple;
	bh=41OyKo8AA7bmoCoxHe40VGXLS46yixBA+0eQ9aV4r94=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ceLpSGE9H3yj5f8kQWcQ+xrXT+bm3xbml6ouLFox59VS8R22PP4iaZx6NOTj8oU/qtESRo5jXy8S0L6IPowoe9NxZQBE7aLyuc64vOehego18fN+s8LSZXOy9Aksn9eat/A3HS2GtOFmFUru70pIshFJj5FW8h3ObCvq0VvbIhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=MytAsbfq; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="MytAsbfq"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 6529F213E8;
	Tue, 29 Sep 2026 17:36:23 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=EFJRJAmInJbL42OH66AUdL96HXKJcoSU80nlGp+WbKU=; b=MytAsbfqtEKX
	w2/DaNrFpgcJTC5FIpsAQAd4/UvKx4RoSCTbUU2kZ6EJlVYPW3pgfuIrNL390jAQ
	mKU1LIXqJrTp9QO0g4CA8CF2wwGQGbQsdV6/fZgWqLj5cxPYJj1HjYvAbWO1yiks
	yOBfSu88alxbrD2SqlPuz1zI0jBa6U6ZZl1UhUaHnj3kP57BmJgQ1VAzxtCtn6sz
	oxRF0w9ruNvg2vH1Yh/OlrY/QGyIowRHaG9U+R3cqUEcWSmo9kUUqp/H3wDgddX3
	m6I8bkUxpF9Dlf6dWp4r6xXXd+YHYFD9ZNEw8j4Ma08Qx7DL/XwgNsXH/x5ChycE
	ZSaqL/d7MeDmSsZWMYLdN0/5FmOwGz1gGJHv+fX2vDBZ8Y1MO3AW9ZzWjc3GZwcN
	52eILAiBJCvyX7/LyzKI62VcotGPhyZodmf+8B8apnwrz2y5fas+3tqbxguSDnLl
	U4kd3jZ3KGWjNyCwcKhZHAYo5yzYRS65IqgsERl0d5ePxzr4GIxfZ2lCiPsj4r1h
	/MQaj4NSm3qRTfiocFxT7XkrLN1h/cpS3phlx7tjqSF/Uh0n1+6BY1emoZ6VFa/O
	636YY4PnIcN/h+PfSopgBDa+mkIt7V/eNIHYv2/ZP/ajQ/LMFI7VdZa4Ril1k4GN
	QpU9bJC7OGH5xiFx0gahXaFQ9d4+M5c=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 29 Sep 2026 17:36:23 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id B1510604D4;
	Tue, 29 Sep 2026 17:36:25 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68TEaKQt060712;
	Tue, 29 Sep 2026 17:36:21 +0300
Date: Tue, 29 Sep 2026 17:36:20 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 00/11] Netfilter/IPVS fixes for net
In-Reply-To: <aruH1faUO3GEZvcM@chamomile>
Message-ID: <5d761dbe-b74c-4ebc-116b-34f2b60a69c9@ssi.bg>
References: <20260927220816.268206-1-pablo@netfilter.org> <20260928191120.28c28fdb@kernel.org> <aruH1faUO3GEZvcM@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Tue, 29 Sep 2026, Pablo Neira Ayuso wrote:

> Hi Jakub, Paolo,
> 
> On Mon, Sep 28, 2026 at 07:11:20PM -0700, Jakub Kicinski wrote:
> > On Mon, 28 Sep 2026 00:08:05 +0200 Pablo Neira Ayuso wrote:
> > > The following batch contains Netfilter fixes for net:
> > 
> > I didn't spot anything obviously needing a respin in the AI feedback,
> > could you confirm that it's good as is? If you have to respin it'd be
> > good to remove the claim that patch 2 is a nop, Linus is onto us for
> > sending too many LLM-induced, low impact fixes.
> 
> I would say yes too. LLM comments say:
> 
> - Patch 2/11 (ipvs): commit description could be improved (yes, there
>   is always room for improvement in that regard but I think description
>   is fair fine enough). There is a report on a pre-existing issue, but
>   I think that can be addressed as a follow up.

	I already have v2 for 2/11, now as 2 patches:

https://sashiko.dev/#/patchset/20260929113436.44306-1-ja%40ssi.bg

	But better to leave it for next week, it is a low
priority fix. As usually, if we stop 1 patch, it is replaced
by 2 for the next round :)

> - Patch 3/11 (netfilter): commit description could be improved again,
>   but patch is good IMO.
> 
> - Patch 7/11 (ipvs): there's seem to be another path to abuse this
>   code LLM found, I would address this as a follow up.
> 
> - Patch 8/11 (netfilter): refers to a pre-existing issue.
>   It also refers to issues with reordering elements of the range,
>   but this API really need elements in order to work fine, otherwise
>   overlap detection will likely fire.
> 
> - Patch 10/11 (netfilter): refers to a pre-existing issues.
>   nf_flow_offload_refresh() also needs to be disabled in pending
>   work is enqueued. Also disable stats fetching for dying hw entries.
> 
> In particular, I am observing IPVS patches are getting stuck because
> of reports of pre-existing issues. Sometimes you find two or three
> things that need an adjustment, and you can start tackling one of the
> aspects at a time (because addressing them all at once it not easy).
> I think it will help Julian if he has a chance to address issues as
> follow up, unless LLM reports something really sound and compelling
> that can be classified as a blocker.

	I don't find the LLM reviews wrong, so I don't
complain :) I'll note if a followup is preferred but in
most of the time the patches need to be corrected. I try
to post different patches for the different problems but
this is also a load for the other maintainers. I hope
I'll improve with the time but it is true that we are
overloaded. The only hope is that the bug-report rate will
slowdown with the time...

Regards

--
Julian Anastasov <ja@ssi.bg>

