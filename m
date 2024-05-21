Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C45D219EB
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716288691; cv=none; b=gF9AXCGEu2kXp6TaU2GJZjN/eE+Ry6T2shNNTaM3T7PfSn6uMzsIDA+8kDx8qnbC1czAg8g3sWLnwRY+UEce5sJ0BHzCluq+HttAPyZhzLvGYSS+NkuvR/XbcEjHskKPeu1X1PCf3a9G0O75W46In4IbMk4hLvRPThMoVoMGUYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716288691; c=relaxed/simple;
	bh=6/duQeXisZkyYn+CBEHXcn9PTQ0CAb+ekCml/6ZuQ6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1jEBw/H4DfX47DSgDEDITAZJOffAzu9XbbrW8rVtRDqXhTHxQOYTZ+l1i4C/UuX2cwBxGkTStzQX65j7FzbyBqwCXY5YFusa1O0FP9E1mohFGf/my9zs2C/Kqyiowlr6drUZ4gC5pDHapt59SH7c2c/wLRPcQtu95YUoN+fjss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s9N5Y-0008E0-GW; Tue, 21 May 2024 12:51:24 +0200
Date: Tue, 21 May 2024 12:51:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Antonio Ojea <aojea@google.com>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <20240521105124.GA29082@breakpoint.cc>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zkx8BCuu6dyTDjcX@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I see, so I fixed the bug in one direction and regressed in the other
> > one, let me retest both things locallly
> 
> The check to force GSO SCTP to be segmented before being sent to
> userspace, my proposal:
> 
>               if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
>                         return __nfqnl_enqueue_packet(net, queue, entry);

This disables F_GSO with sctp packets, is sctp incompatible with nfqueue?
