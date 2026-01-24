Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88271C84A6
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769273318; cv=none; b=ZBTLkd9bv66I3hGvZ+4fNCDolBVmbRqjaCke7GOtFYJ2IumEExzRreb9jzDLNFQFrmtiUPIkOPFLEm48rbjHvY6HQhAfcGWC6WkgTGlCRmCWCEdwxrDBDi7Wbudu6kT7o5xzc8k+s1pLPCRkpB85QJ35zzfK6Xm2IZmWs7pLBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769273318; c=relaxed/simple;
	bh=3U72buO+R5wlySJZVON9Ph0qoeQeEM4A8yusRDTyFpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUEqvZGL900w3U6gO3l4FwVOvpdeTg/n81GIt/uSSFPKg7i86we7mPhhCEYhi2gvUtkxwiJCz5lql9lwBgS076KhlKsY70HwEGisvrIkY+p57moPHr5eQqoqHEpo2YaiBe4e5/ApxU/NcvnLl0VwM31ZA0jMWI5Ew9Um9l3wndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0D049602B6; Sat, 24 Jan 2026 17:48:29 +0100 (CET)
Date: Sat, 24 Jan 2026 17:48:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
Message-ID: <aXT32zphu2Uph_Uf@strlen.de>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-3-scott.k.mitch1@gmail.com>
 <aWwUd1Z8xz5Kk30j@strlen.de>
 <CAFn2buDVyipnvn8iW1dsPN827D1BBrZ9xLjcuJHC7W00xjioSg@mail.gmail.com>
 <aXD1ior73lU4LYwm@strlen.de>
 <CAFn2buAFkjBHZL2LRGkfaAXGd9ut+uta1MaxaHuM+=MJdGf_zQ@mail.gmail.com>
 <aXMbOwOw0yVpIWZl@strlen.de>
 <CAFn2buDj1+X_zKqy-ex5x-fz05g_0a3V_u0gJr7Z_n5pGK4rqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFn2buDj1+X_zKqy-ex5x-fz05g_0a3V_u0gJr7Z_n5pGK4rqQ@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> For NFQA_CFG_QUEUE_MAXLEN API translation there are a few challenges:
> 1. Max packet size - If GRO is enabled, the MTU may not be a reliable
> upper bound. Using 2mb would be a conservative approach but also
> overcommit memory in many cases. Since there is no per-byte limit
> today it is likely safest to go with the conservative approach for
> backwards compatibility.
> 2. Per queue limit vs pernet limit - The number of queues and
> NFQA_CFG_QUEUE_MAXLEN are dynamic. How would you derive a pernet
> limit? One approach is "number of queues * queue with the max
> NFQA_CFG_QUEUE_MAXLEN" (which requires some additional state
> tracking).

I don't think a per queue limit was ever a good idea.

Back then network namespaces did not exist and nfqueue needs root
privileges, so misconfiguration was always self-sabotage.

But thats not true anymore.  I think we can keep a per queue limit,
if just to allow userspace to limit some queues more than others.

But to keep memory usage at sane levels we'll need some pernet
limit (pcpu counters?), counting based on skb->truesize.

We could adopt a low limit, say, 32 Mbyte, by default and add
nfnetlink options to increase this. (The default 1024 packet
queue length would use ~2mbyte, assuming 2k pages and no
packet aggregation of any kind).

Maybe we can precharge this to the requesting sockets memcg as well
to also prevent netns from configureing a 1 TB pernet limit.

> For the pernet byte limit API, were you thinking sysctl similar to
> nf_conntrack_max (e.g., /proc/sys/net/netfilter/nfqueue_max_bytes)?

Thats another option,  My first hunch was to extend nfqnl_attr_config
enum, as that api already has to be used to configure the queues from
userland.
