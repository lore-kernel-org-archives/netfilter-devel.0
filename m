Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE19B6CDC1
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710408346; cv=none; b=WSf2jEKNhLXjAivwIUDwOcj8HuLmLoEZeO/0mw1iojtvioIlBMQ1ITeOoqFEaxqArw8WrqM2VB5+3JazFzMdHZSWCMzn3fg5ydl6DLKLcnFB+oM21YMdCuKBrV13dwOdl73jU0Ggmb2td3ym/QVOU+oI2vOyAna+cK1fxEADhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710408346; c=relaxed/simple;
	bh=7ckVqXt43bfaC/MQdBNmRayET1Jqxcnp2LwNu+kKFYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7uTqmdZCLbVj0G5aUMp/cWEFg65rWnDnX4re8ZbKHxxEbLzi5cEmYCfrUNNmLo8aVT7syCnb4xYruJo0jcYRh6bEAScGKo0ADr9076dNqyEBSb5a8rLdqSPBbzhlg7+bGvOqeZ2Jhqd/ap7kB5w9zWzPFcC5n1LRoYwBHWiXBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkhLJ-0006C8-C0; Thu, 14 Mar 2024 10:25:41 +0100
Date: Thu, 14 Mar 2024 10:25:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <20240314092541.GB1038@breakpoint.cc>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
 <20240313152528.GF2899@breakpoint.cc>
 <2rzv5gwtw3mp4hzndzb4sjtnibefs7sjcsychvm7vpoy5wetv2@ssrxj7cmi42b>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2rzv5gwtw3mp4hzndzb4sjtnibefs7sjcsychvm7vpoy5wetv2@ssrxj7cmi42b>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> I tested your patch but that leads to other problems.

How can this work then for UDP, which has no fin/rst bits?

Maybe this is needed?  But I really do not understand any of this.

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a0571339239c..aed4994c1b6f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -423,6 +423,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 {
        if (nf_flow_has_expired(flow) ||
            nf_ct_is_dying(flow->ct) ||
+           !nf_conntrack_tcp_established(ct) ||
            nf_flow_custom_gc(flow_table, flow))
                flow_offload_teardown(flow);

