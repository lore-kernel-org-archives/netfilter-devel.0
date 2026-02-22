Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A744419D8AC;
	Sun, 22 Feb 2026 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771781245; cv=none; b=NUhY7YbpJL5cu9/dgiJKO1UdESnxJ4IlxZE+h5Nyk25uhZJAXiYi0pSIwu20ZQZx92dyMlHf9y7RL5VAqXtdWTr6DcsUo35IA53A9DcO0D1cDE1KDD3qMRzt99J82WT8pdn1tBoCKFauhImyZ4g/rfqEKtBMZdMQ35CkjAiGQEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771781245; c=relaxed/simple;
	bh=lAXiP7N9VY4KBII59KzvHJIOIezOiaQHobdgcX+mTOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyBUzvNIIQZ6HnSpOFVxX76flazvd/BYAePKY2Ir/BD7dERI7CGP/nVsDaY3y3V8S95bXxjVk+9L03WjJPp2R86G59SIIbwuH2vqX4rrj97m4HMUWrofyi4fP8CpjSsVg/ejM7yfF3+4DKQLMFnLuLXXdM7o3X44qlY56ySShlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CCB3D604AA; Sun, 22 Feb 2026 18:27:14 +0100 (CET)
Date: Sun, 22 Feb 2026 18:27:06 +0100
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
Message-ID: <aZs8atSEZTjkzzQ3@strlen.de>
References: <20260222155251.76886-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222155251.76886-1-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> With double vlan tagged packets in the fastpath, getting the error:
> 
> skb_vlan_push got skb with skb->data not at mac header (offset 18)
> 
> Introduce nf_flow_vlan_push, that can push the inner vlan in the
> fastpath.
> 
> Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")

This change is in net/nf tree, so why are you targetting nf-next?
Are you proposing a revert for nf?  If so, please first send a revert
for nf.

Is there a test case for this that demonstrages the breakage?

And why is this tagged as RFC, what is the problem with this patch?

> +	if (skb_vlan_tag_present(skb)) {
> +		struct vlan_hdr *vhdr;
> +
> +		if (skb_cow_head(skb, VLAN_HLEN))
> +			return -1;
> +
> +		__skb_push(skb, VLAN_HLEN);
> +		skb_reset_network_header(skb);
> +
> +		vhdr = (struct vlan_hdr *)(skb->data);
> +		vhdr->h_vlan_TCI = htons(id);
> +		vhdr->h_vlan_encapsulated_proto = skb->protocol;
> +		skb->protocol = proto;

Ok, I see, this opencodes a variant of skb_vlan_push().
Would it be possible to correct skb->data so it points to the mac header
temporarily?  skb->data always points to network header so this cannot
have worked, ever.
