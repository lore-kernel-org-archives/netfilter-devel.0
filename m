Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA9B21A45A
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741368121; cv=none; b=b1OYQNizeNB8zfEC8AtbfdpZZ2Otx7vLlcTnh8SQSUbts8U4k17tIVXUMA6NAXKcCqRIUyhbN8pf75jc5IXkVMWjLq9QDfRrQoXVWTpXpCWT4bnEzuI69CvLCJSqmc8BRlItc7fu/ZSUqdN/EoMqMk5Z5N/lV/WOzOB9UHOYVWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741368121; c=relaxed/simple;
	bh=fxbwcH6nqSJFUX40lwdrb/6r0uHdsu8wx2zxNtWjVvQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jDtXZpxZBHV4ip3GqleWl4vRoarj15RN8Km0gBuSfs7DcfJ7dH2OFo+LRXJgvzaK197j58OdBJPKCe/foLvRBpLdh4Nnvtn2DqSZpZsg0alpgc1wrIrYMHrgHlB6o8RjtbNrjpVaQUPVdtR82eaAaSdQAPkueYss1EXvT1d6sDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id E660A1003BB141; Fri,  7 Mar 2025 18:21:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id E62841100AD650;
	Fri,  7 Mar 2025 18:21:56 +0100 (CET)
Date: Fri, 7 Mar 2025 18:21:56 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Guido Trentalancia <guido@trentalancia.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
In-Reply-To: <1741367396.5380.29.camel@trentalancia.com>
Message-ID: <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>   <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>  <1741361076.5380.3.camel@trentalancia.com>  <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr> <1741367396.5380.29.camel@trentalancia.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Friday 2025-03-07 18:09, Guido Trentalancia wrote:
>
>The patch solves a well defined problem: when iptables are loaded
>(usually at system bootup) the network might not be available (e.g.
>laptop computer with wireless connectivity)
>
>Consider that iptables can always be loaded again when Internet
>connectivity becomes available (for example, by a script used to turn
>the wireless connection up).

When you add/edit rules in Networkmanager hooks (or whatever the
software in use is), i.e. response to network events,
then you can just as well use a *deterministic* ruleset during early
boot.
