Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809712749EC
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 12:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760271490; cv=none; b=Gz1PlIxdhFo9ycA44xvx+3hMk3NPGKAA4N3fOTONaSXgJBnyi0SxXAppm6T37Il5kh3iKGVcghjUPY0KhnVlwu4JiQeVJn8twE76qK8WLd/Vu2au8nuCfrwgqUdYV4Je8pfeU7WfOKSMQ8GGtgQz+GCpW+8xJxSFPj6QKUWcpeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760271490; c=relaxed/simple;
	bh=BSIRUj0vqQIQkj/vw429QrqWlSOmWZgejECm7GQxl+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji1x7Fx4LnRnvh7PTZXtjVcn8iza0mfEKHbSW0NltrQbMtGVOTniDJtW4kRXdUuB3PhlNYn5ImzKfjAQtvPD3OTMUIEUVQy6HSDH7vKjbT9dofCgp77XCfHHd3yo9I/mAT7Fgr4e/J4JYUUMhGPrTAe6zGZKbW1Z76cWop4osY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 10CD660321; Sun, 12 Oct 2025 14:18:04 +0200 (CEST)
Date: Sun, 12 Oct 2025 14:18:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/5] netfilter: flowtable: move path discovery
 infrastructure to its own file
Message-ID: <aOuce8-RtHp-ARCh@strlen.de>
References: <20251010111825.6723-1-pablo@netfilter.org>
 <20251010111825.6723-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010111825.6723-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This file contains the path discovery that is run from the forward chain
> for the packet offloading the flow into the flowtable. This consists
> of a series of calls to dev_fill_forward_path() for each device stack.


> index 000000000000..159aa5c8da60
> --- /dev/null
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -0,0 +1,267 @@
> +// SPDX-License-Identifier: GPL-2.0-only

Wouly you mind adding above explanation here as a comment?
