Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45247154426
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742568817; cv=none; b=l5JZELbE+ldHeKTptEqzxWhsjus/OHmnmwDqZvAiHer3+G8fs/uWLNzkDtBskCF/ArI+XW6q0pyHZTjaTMY8X4uvaa5ejKcCrLaHxIUAB5mK5gHf402a7uJQBf4l45EooVbzj0G0QbYsYhXqvi7ptAjWV4osKowFFpBMrfIl+6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742568817; c=relaxed/simple;
	bh=jtw5ioTA0xDMqvIPlMI45RqwlscI+sLDkG5YwST7d6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwEN1vMsL2Em6Qncfnc/h0wQMqbflQhJxCks7Of4hDV3RKU/HI7ViN3oMXGKSSr+O4/LP7P/gCpQQVLlcF1D3Z+6eXPwEXKlvpdJJoJSyPI/3XTsebye+4U38MVD4j1UPB1dewLKBYZnLOBOp2pwSTACthHSDAF9JXzEn+lweNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Xc4KCrqe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Xc4KCrqe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jtw5ioTA0xDMqvIPlMI45RqwlscI+sLDkG5YwST7d6g=; b=Xc4KCrqegco4pzceQzP2qKiYhf
	G34cJaJFvcMogDqtwCLuLiY0ok1CCOnA1Wt5dozGUJIeRxtr4ifXGRJF2olBaPHaLkY5O+V1SgtKb
	BSeV1xDR2kZ4oMRTptSQTUL8tWcRa7jBQcQNxWy5NIybKXGcViEIsY0dT5oSWzXpYzncPYdHxEfdz
	1OLU87Tqr7NR7cgfQJ8yAqnXlaKaOoaCr7xuPkDGVHQhf4bXdpKO7m1zv8CbYvlMr5V4HT35DIPQ/
	bF/jamvNNi5X+/4UTIuZ2xqwp2e8fSK+ZjJd7FwjCBNtehfMmZWNoAYX9/6LNpfF9DjDCBXJGRHug
	PWFBxrAg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tvdka-000000003wu-1OcR;
	Fri, 21 Mar 2025 15:53:32 +0100
Date: Fri, 21 Mar 2025 15:53:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
Message-ID: <Z919bGfvp6scBYLi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Guido Trentalancia <guido@trentalancia.com>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
References: <1741354928.22595.4.camel@trentalancia.com>
 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
 <1741361076.5380.3.camel@trentalancia.com>
 <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
 <1741367396.5380.29.camel@trentalancia.com>
 <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
 <1741369231.5380.37.camel@trentalancia.com>
 <Z9w2vLdyQfWepMET@orbyte.nwl.cc>
 <1742556087.6585.35.camel@trentalancia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1742556087.6585.35.camel@trentalancia.com>

Hi,

On Fri, Mar 21, 2025 at 12:21:27PM +0100, Guido Trentalancia wrote:
[...]

Sorry for skipping all your points. I didn't see any new data in them so
no point in repeating what others have commented already.

> I hope this helps...

It does not. Applying a ruleset partially due to failures is not an
acceptable behaviour, so this is a NACK to your patch from my side.

Cheers, Phil
