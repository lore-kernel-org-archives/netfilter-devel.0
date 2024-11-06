Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115B21DFE38
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903579; cv=none; b=pIqPhrkXlKcTzqw0ZV+D95i5i2MyaA2pIU3mb+5mJCBdtDI/1Z8Rq3+wIQJ3amFs/xzk28AfrasiYrMHNODI7hiKQMSFGXLHROYoQN+LuzF+yLv7cWyUbETh7KRlayUNtNEEEVanMBHwwXA+nwx5rV4MxmV9r9ApS9v+Fkp14po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903579; c=relaxed/simple;
	bh=3lf0JsaudSW/DD5HZBEJpCb/ABz/TCR3FYW6bdacWYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2n+ql0vBSQITF20ZzSyZb30vZKbHk+SswvGObeZmrmA63qv8xW7qkX674+iDFUzzTNzEVeGh3E53ZrGUyOHBJS+XgWtVus9OoGxoF391224jvx83q5mvPhLy0e9GI+jOmGkD1U85vStHD3BQOjmqqATKwopo1AnFgP1JXjGSKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8h5a-0003LE-16; Wed, 06 Nov 2024 15:32:54 +0100
Date: Wed, 6 Nov 2024 15:32:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <20241106143253.GA12653@breakpoint.cc>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
 <20241106135244.GA11098@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106135244.GA11098@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> > From userdata path it should be possible to check for this special
> > internal queue_datatype then encode the queue number type in the TLV.
> 
> I have no idea how to do any of this.  I don't even know what a "queue number
> type" is.
> 
> How on earth do i flip the data type on postprocessing without any idea
> what "2 octets worth of data" is?

You seem to dislike EXPR_TYPE; I tried to sketch something but i would
turn EXPR_VALUE into EXPR_TYPE, including EXPR_TYPEOF_NFQUEUE_ID and
the udata build/parse functions, with the addition of a

 /* Dummy alias of integer_type for nf_queue id numbers */
 const struct datatype integer_queue_type = {

that has no actual function except to override what constant_expr_print()
ends up doing.

TL;DR I give up.
