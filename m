Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359C32BE647;
	Tue, 16 Sep 2025 22:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758062387; cv=none; b=OJZuxEVxebDuodtR2u6+i+Psl1rmsmaUZsKnKxeoKllYYIAkGznCqNPlNX3so3pvplvdscBrs4rVMRzMEOma6WsDK4gS/fY8YMCI57toUwNFuNkXYVKEIZZjdKmULhAneseXBBvRs3c7JyoFXeFRI63nSzInf87r7TwBS56NElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758062387; c=relaxed/simple;
	bh=DTj+rpK7YKaRjpCjv8Y1UDvAhYegvGxlCwQxz84dYZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYIm/JTPQNB6Dk9DpmyJADqnh9I6cn1toAOi31TI5iK72ScGGGw8ThgAm23xk1E32vVamKauhlqMPD+dXu4gBS7MTz73dVMx0uG/Q9jd9JzQV1uuORTTDL+3b3W6nkJGB6ZSv0PBTLc07CQHf2ZfoasA+r/l3pGi7LndBeWqUzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c3oPenFr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W9nFgTNo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c3oPenFr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W9nFgTNo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 761056026B; Wed, 17 Sep 2025 00:39:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758062383;
	bh=9ZhYP+GtZzerSLJDFwCvOxGvIp7KTXCxXJzN2snHOuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c3oPenFrOGgqpIgvNYxQpfF6l0dg9sixGhSVpkLkju0usSEW+XlwL4+cD3SJvR84r
	 V/5QrFgeMoy80ubN02bZxVqKgDgNnu696CvSWVzx3HaDc2NTM3zZrtiljGEwjpAfie
	 uAI/OyURswG0HYv95d8Y2+QlWmzBC1lTyGHxMCalm74YGBHBzgiiVsh8swzzmFu3W6
	 t4ks+rKgGs9wVYkorGZHDvwTgEBTqeP2Xool2vkTX1At+YCIEPa6Y3eQ3oBU/gP6k9
	 qdMmw9tap5vPIqBQACI39mV/+Os8wPCGWlgKZCZkwFA35Wftz+YIdkG/1GErVLV+JR
	 yjUEDEgRz0MXQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88F0460254;
	Wed, 17 Sep 2025 00:39:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758062380;
	bh=9ZhYP+GtZzerSLJDFwCvOxGvIp7KTXCxXJzN2snHOuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9nFgTNoBQ452WKh4OVAmLDed56W51i1efNqr2UYGpt5Ec2Qka+VTSGJc379M49Tu
	 IOz6VRG57D2xi4Imwu0SdrDeB6otzBASK3yXtLEKSuzzf1BWYZH8NqMjp6wQ5wxmj4
	 iom8PI7pJOKLylIVkl+thcV30KuAQAJnUBgx0jCKTynSkiW0zIdAwlCU9RNC4SMIHy
	 Fgo+njYD80ovgh6pOj5CAgxzFD3fPkFNK/Jx16ERyUyalYb/wZbBZWMQEOxfxXP8Yb
	 VoUMdSjeoXM4SPkyB8yI7X+fx8D5fluweT6yrZM8xNZK0tVnZotgePQJXZQirA7Qgg
	 gj89eqXd56ODg==
Date: Wed, 17 Sep 2025 00:39:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Elad Yifee <eladwf@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata
 action for nft flowtables
Message-ID: <aMnnKsqCGw5JFVrD@calendula>
References: <20250912163043.329233-1-eladwf@gmail.com>
 <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>

On Tue, Sep 16, 2025 at 07:49:34PM +0300, Elad Yifee wrote:
> Hi all,
> 
> One caveat: this change will cause some existing drivers to start
> returning -EOPNOTSUPP, since they walk the action list and treat any
> unknown action as fatal in their default switch. In other words, adding
> CT metadata unconditionally would break offload in those drivers until
> they are updated.
> 
> Follow-up patches will therefore be needed to make drivers either parse
> or safely ignore FLOW_ACTION_CT_METADATA. Because this action is only
> advisory, it should be harmless for drivers that don’t use it to simply
> accept and no-op it.
> 
> Just flagging this up front: the core patch by itself will break some
> drivers, and additional work is required to make them tolerant of the
> new metadata.

May I ask, where is the software plane extension for this feature?
Will you add it for net/sched/act_ct.c?

Adding the hardware offload feature only is a deal breaker IMO.
