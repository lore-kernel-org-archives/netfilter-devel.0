Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482C014B06C
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730711391; cv=none; b=h2FDlTjvsa05UXXO9fWK1evDKaXU750AmhPJnAUdm9PEdHXb7/G/p50Jm9JkDw1sB+cayzTN67kL5sTs9ME1Qsk/LpIjzO0VM6F/eNbr3wTHt+MSbvCWyUno6rqpjMzy4o4uTojeYOUHIK7y2NaofsaF+3BJSXdKk4JrvEbX0zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730711391; c=relaxed/simple;
	bh=TpWy7Qfavmv9bQA9tbfHTCTySQd8ZMx3vZ6wOoRYR28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mO74nfFuE/ehEEpcfs7o5DIXfDA17PD9Vln0LxwrJZhyrnRUuqadECV4NPuzH+MP5STPS56vK9zmj8VEUGBu+txzE37cK/V9EXWctiTWHXllkDEitQoh7fOr0eq1U4I4nvgmPXClc8g6U/FGgs1QLWcnEE4dgRFFtwNo68UUHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60318 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t7t5b-00GN7S-H9; Mon, 04 Nov 2024 10:09:37 +0100
Date: Mon, 4 Nov 2024 10:09:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZyiPTuWKtSQyF05M@calendula>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Hi Nadia,

On Sun, Nov 03, 2024 at 11:26:36AM +0100, Nadia Pinaeva wrote:
> I would like to provide some more context from the user point of view.
> I am working on a tool that allows collecting network performance
> metrics by using conntrack events.
> Start time of a conntrack entry is used to evaluate seen_reply
> latency, therefore the sooner it is timestamped, the better the
> precision is.
> In particular, when using this tool to compare the performance of the
> same feature implemented using iptables/nftables/OVS it is crucial
> to have the entry timestamped earlier to see any difference.
> 
> I am not sure if current timestamping logic is used for anything, but
> changing it would definitely help with my use case.
> I am happy to provide more details, if you have any questions.

I'd suggest to add timestamping support to the trace infrastructure
for this purpose so you can collect more accurate numbers of chain
traversal, this can be hidden under static_key.
