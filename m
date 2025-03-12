Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2511F12F2;
	Wed, 12 Mar 2025 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821111; cv=none; b=LuUhJaOlSwNUUbGATgWg/gv+ISDxS9HxK33L4wQpm0DyhYH38icTWmaiqjRrH42D+D3siSMpcyQgzhnWjhnLHkFJMpdeDbAluDOFf9W0MQr2TUZoD228yGq167b70+q1Kztg08fyMNNMeDcIMMV2HpE026nOREJtiE3XtK0OQ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821111; c=relaxed/simple;
	bh=2W3aVFmGwvClwVTmM7aCRx2KgO4A4R1U0tJDkBzH+nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyUcKwlaqXv7zMtQADwTmZmLwCo+AjDdPFl7/K/LDa2gFn38Dq5Zva412OIT2DztPDa0NQ3d/Y1C0pUMWJb0biIcn8hMlKUNdK3Wp03o+T4O/Onnhm86pLP56JjjhhtG44JO4OAqh3EepHR2kwZon+XKYqKRCg284l+yMygib2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t0qJL/2b; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qbeolRdz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t0qJL/2b";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qbeolRdz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EC09C602BB; Thu, 13 Mar 2025 00:11:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821107;
	bh=PQSKrOlMPfzl9nwDmSr8qh4iamX82LLyOlMFMg/9c7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t0qJL/2bU8GPh32cdA69JdoMZVh7TSHGCLtgmOuIXAHN5T4eCT+YGrfUtcdLc6w+H
	 wBBFOYHJGgv4OwC9drZb/SBxoeodBTIhuHSuKLTgwzxJP1oKP+FkzrL4MghCg4YOP9
	 /oT591oO5UG7EmDyYrM22yxzBY4bgwlvZLjRZkYGRWS61A52Yyp0C1TPy5uZ1ntRqz
	 pjqhRrBlNu9dCHr4EiGmpfrW5KjQLI9BSXXrfrqvle9U6Ua/ut73znipRs/3NmHf4P
	 Y1kr3PP1yTEQ0T2sj/JmgDVGyL71KEnhVue+A8agztNv6lH/wDkMfRSrUjBBnzjue4
	 p2eP3mU7YW7OQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 49BB3602A4;
	Thu, 13 Mar 2025 00:11:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821102;
	bh=PQSKrOlMPfzl9nwDmSr8qh4iamX82LLyOlMFMg/9c7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qbeolRdzmWfAU19cU0ccSVcMVP9Fk4SSQN9BVqHZ8FLRhk39ZK03WcEJ+WQOmOxZF
	 cy23JB5bF5+aVpudZJXvgQrTaeLjetLivZIvhEEDf9Re9Itl0VnGNk2tB0s4w2+kXT
	 talIeV1XAVKL25ykSMxM5fUeXwDlOLPo7r2V1/53tyLuKpyHDKpWW+c4oRWWG6CHax
	 4zIHURnVcKBNHgV75Bd3agsDnngcIvT3lvGyOfj2Ddp/CejMNpCEnvtz+qkgNMldVY
	 o5hT/rRHam+N+4/Lhradu4N5nlIXFhpj14jDpnuYxuEfASgXrzhghIOpCK4MXyAr4O
	 CBArB71yfg7xQ==
Date: Thu, 13 Mar 2025 00:11:40 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Roopa Prabhu <roopa@nvidia.com>, Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
Message-ID: <Z9IUrL0IHTKQMUvC@calendula>
References: <20250305102949.16370-1-ericwouds@gmail.com>
 <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com>
 <Z9DKxOnxr1fSv0On@calendula>
 <58cbe875-80e7-4a44-950b-b836b97f3259@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <58cbe875-80e7-4a44-950b-b836b97f3259@gmail.com>

On Wed, Mar 12, 2025 at 05:21:29PM +0100, Eric Woudstra wrote:
> 
> 
> On 3/12/25 12:44 AM, Pablo Neira Ayuso wrote:
> > Therefore, I suggest you start with a much smaller series with a
> > carefully selected subset including preparatory patches. I suggest you
> > start with the software enhancements only. Please, add datapath tests.
> 
> Then I will split it in:
> 1. Separate preparatory patches and small patch-sets that apply
>      to the forward-fastpath already.
> 2. One patch-set that brings the bridge-fastpath with datapath tests.
> 
> > P.S: You work is important, very important, but maybe there is no need
> > to Cc so many mailing lists and people, maybe netdev@,
> > netfilter-devel@ and bridge@ is sufficient.
> 
> Ok, but my main question then is which tree should I work in, and
> therefore which tag should I give my patches, [nf] or [net-next].
> I think it will get more complicated if I split my patch-set and half of
> the patches go to [nf] and another half to [net-next].

Use [nf-next].

> What do you suggest?

Probably I can collect 4/15 and 5/15 from this series to be included
in the next pull request, let me take a look. But it would be good to
have tests for these two patches.

I would suggest you continue by making a series to add bridge support
for the flowtable, software only, including tests.

Once this gets merged, then follow up with the hardware offload code.

Thanks.
