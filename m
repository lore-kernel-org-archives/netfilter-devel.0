Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C385259CB6;
	Wed,  9 Apr 2025 07:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744183246; cv=none; b=HkSjwbXq0AAS/oqL+ck1lvh2W1B+E2c4f5TOf1U7p/yh52+H7DAM+MXRwA5cTblBVcbynp/WeTE7AsW60UQj9reG21EQy/GlNiqBTzCN6JAnIPZcPDzsbDUr4u2TXT+JZr0/Zqzo2D2mFZ4MTO6xiDS0QDj1vmUH/q9HVgorDxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744183246; c=relaxed/simple;
	bh=U2J1fdphyqWzgc5nzEtL2jQ7Ms+BVb/HcY25EU7KOpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFc/OyuOue+JL21AtbSdH3S06adsT9+SqqmTpSH2iwmagt+JscFe7Q8swJSJtuEbi0Kw0gXYLGXIUBMyKX0NYahUXPZ5YDmKKXupv93kl5kL1i6gDyfIl/8T8+1VGXZMuMTPhUH1TJD0LSnf1qpMTH/TpaeYLJhARD25PHAch4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2PjY-0003f3-3P; Wed, 09 Apr 2025 09:20:28 +0200
Date: Wed, 9 Apr 2025 09:20:28 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, lvxiafei@sensetime.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250409072028.GA14003@breakpoint.cc>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250409042515.64578-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409042515.64578-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> -	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
> +	if (net->ct.sysctl_max && unlikely(ct_count > min(nf_conntrack_max, net->ct.sysctl_max))) {
>  		if (!early_drop(net, hash)) {
>  			if (!conntrack_gc_work.early_drop)
>  				conntrack_gc_work.early_drop = true;
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 2f666751c7e7..4a073c4de1b7 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -615,7 +615,7 @@ enum nf_ct_sysctl_index {
>  static struct ctl_table nf_ct_sysctl_table[] = {
>  	[NF_SYSCTL_CT_MAX] = {
>  		.procname	= "nf_conntrack_max",
> -		.data		= &nf_conntrack_max,
> +		.data		= &init_net.ct.sysctl_max,

Whats the function of nf_conntrack_max?
After this change its always 0?
