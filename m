Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E072D239B;
	Thu,  2 Oct 2025 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759391704; cv=none; b=oKV6+CnJzrtrj5tAM7FPryL5bbeVN7baGkmTumNZS+W4rdBde2SbtBFNNALSXnM/+TlVBdKfjApcHZLIXn9LuIrgFnaGVOqaMQhxUc8PTMPG5VNBOI5tlwnDkNTZ2CMGyAxfetHmSIIZaNCV6FR/QCYA9sHdR855j4E7fmY8Frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759391704; c=relaxed/simple;
	bh=xXHP/WK5yRRpU2UsD3sbFAGoRGxEXGuWI7BYMSJQPs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUtxWKDCkDdA940NCj9GIHbuGERQDfnsUhugJP93mIEkxull+YMHRNSDmzTMCE/TvIG5oIRUIWixBW0s3zk+fOtio6d5vCQQVhaNRMsWifPZRLcVgkUmtpBf+9U9t98qFDxiPoOhHRgOZ5kgKMOEYBUNSM1GNlAYozLc0nA8uQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9FA7D6032B; Thu,  2 Oct 2025 09:55:00 +0200 (CEST)
Date: Thu, 2 Oct 2025 09:55:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_flow_table_core: teardown
 direct xmit when destination changed
Message-ID: <aN4v1DB2S-AWTXAR@strlen.de>
References: <20250925182623.114045-1-ericwouds@gmail.com>
 <20250925182623.114045-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925182623.114045-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> +static void nf_flow_table_do_cleanup_addr(struct nf_flowtable *flow_table,
> +					  struct flow_offload *flow, void *data)
> +{
> +	struct flow_cleanup_data *cud = data;
> +
> +	if ((flow->tuplehash[0].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> +	     flow->tuplehash[0].tuple.out.ifidx == cud->ifindex &&
> +	     flow->tuplehash[0].tuple.out.bridge_vid == cud->vid &&
> +	     ether_addr_equal(flow->tuplehash[0].tuple.out.h_dest, cud->addr)) ||
> +	    (flow->tuplehash[1].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> +	     flow->tuplehash[1].tuple.out.ifidx == cud->ifindex &&
> +	     flow->tuplehash[1].tuple.out.bridge_vid == cud->vid &&
> +	     ether_addr_equal(flow->tuplehash[1].tuple.out.h_dest, cud->addr))) {

I think it would be better to have a helper for this, so
it boils down to:
if (__nf_flow_table_do_cleanup_addr(flow->tuplehash[0]) ||
    __nf_flow_table_do_cleanup_addr(flow->tuplehash[1]))

(thats assuming we can go forward with the full walk.)

> +static int nf_flow_table_switchdev_event(struct notifier_block *unused,
> +					 unsigned long event, void *ptr)
> +{
> +	struct flow_switchdev_event_work *switchdev_work;
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +
> +	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE)
> +		return NOTIFY_DONE;
> +
> +	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
> +	if (WARN_ON(!switchdev_work))
> +		return NOTIFY_BAD;

No WARN_ON here.  GFP_ATOMIC can fail, which then gives a splat.
But there is nothing that could be done about it for either reporter
or developer.

So, how much of a problem is this?
If its fine to ignore the notification, then remove the WARN_ON.
If its not ok, then you have to explore alternatives that do not depend
on successful allocation.

Can the invalided output port be detected from packet path similar to
how stale dsts get handled?
