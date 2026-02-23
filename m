Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE7343203;
	Mon, 23 Feb 2026 06:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771829400; cv=none; b=qe0oDBZiZanHB4RPvCDlOo8BtoZa4nWN/AL0G9LF/9xLqF7ISU69GsE0chbo37ej/HPdZkebyWSN95uQ03dkbNT9DbFStah2MOOfcqEX4QlR5oKvg+MsJYKz+9QVsrbJMqeZRkh2HYOBLYJDvFCE7640vs3d5WNoRJ1VB72GE8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771829400; c=relaxed/simple;
	bh=sjwgxeZjx5SSlamb871bLgvFyqx71+WMeyRCCGAccxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quyfrBKtK8zg6S5WyAv0hkubwW/GYYd3RarUFuqeq5q7jWSaO/uhlXMAL8puSAYm9Sh13cuwKgGKj3Ijl0Tb9IpprGZQk+Zd2rmn6EURocb7/m3cQGUpPCiBMEW0DZlTexXFWM4DOhxSpJ1KO/sjP7t3Gce8SrPYP+Ed6tCbnY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 63BD760490; Mon, 23 Feb 2026 07:49:56 +0100 (CET)
Date: Mon, 23 Feb 2026 07:49:52 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC v1 nf-next] netfilter: nf_flow_table_ip: Introduce
 nf_flow_vlan_push()
Message-ID: <aZv4kLUYBSzbWIxO@strlen.de>
References: <20260222155251.76886-1-ericwouds@gmail.com>
 <aZs8atSEZTjkzzQ3@strlen.de>
 <a4af5ff8-7aff-454d-8990-2922f1b9bbf3@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4af5ff8-7aff-454d-8990-2922f1b9bbf3@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> I have run into this, when testing my branch for implementing the
> bridge-fastpath, not in the forward-fastpath. But anyway, no matter how
> packets are handled in the original path (forwarding or bridged), once
> going through the fastpath it would not matter, so it is broken in any
> fastpath.

Agree, it cannot work as-is.

> > Ok, I see, this opencodes a variant of skb_vlan_push().
> > Would it be possible to correct skb->data so it points to the mac header
> > temporarily?  skb->data always points to network header so this cannot
> > have worked, ever.
> 
> The code here for the inner header is an almost exact copy of
> nf_flow_pppoe_push(), which was also implemented at the same time.

Ah, I see.  Makes sense to me.

What aobut this:
Wait for a day or so to give others to provide feedback. If no more
comments, re-send this patch, targetting nf.git, and amend the commit
message to mention that the new function is closedly modelled on
existing nf_flow_pppoe_push().

Makes sense to you?
