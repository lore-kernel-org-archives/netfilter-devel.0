Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB423264E2
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777024342; cv=none; b=MpD560smoswzXSwv9TurXv4vDPBp4Xt3jOSJLfZq7fIYhi5n8eIKqTQ3VMGSG6rFR0Dr4fCVSkQKptzTE1QPYJIeCOabDlvksazV42vHly+mp5WhVIxYA2gdUlhvXxqHX5YxGMQPDIpn3mxAhhzcBfr089LkWIX8U5kxTz+U2EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777024342; c=relaxed/simple;
	bh=XyHFxLW08zH56ek4JeZXjLTlwXrhoacLwNL/r7W01w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7G4MQc00d2SbIgXHF1A/f8ePqkVZIXbgNMHPDen1fQxzthUyWYgc4uWZ3s5QPWrkxhLVxHKsLH/A575XqpSTnfLaS3pvB2LL5qw5JA5v1h0Mmj4Uw51+FUfpF0a7nUbS5SuwB3uSsN/3bzx3jxgeUlVkgjCizvlCZuSqE6cfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5ECD960425; Fri, 24 Apr 2026 11:52:17 +0200 (CEST)
Date: Fri, 24 Apr 2026 11:52:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, rakukuip@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: ebtables: fix OOB read in
 compat_mtw_from_user
Message-ID: <aes9S-ToE9yOXrIM@strlen.de>
References: <cover.1776834093.git.rakukuip@gmail.com>
 <4e714f6189f9691fa5980087ce378a57cf625976.1776834093.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e714f6189f9691fa5980087ce378a57cf625976.1776834093.git.rakukuip@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> The function compat_mtw_from_user() converts ebtables extensions from
> 32-bit user structures to kernel native structures. However, it lacks
> proper validation of the user-supplied match_size/target_size.
> 
> When certain extensions are processed, the kernel-side translation
> logic may perform memory accesses based on the extension's expected
> size. If the user provides a size smaller than what the extension
> requires, it results in an out-of-bounds read as reported by KASAN.
> 
> This fix introduces a check to ensure match_size is at least as large
> as the extension's required compatsize. This covers matches, watchers,
> and targets, while maintaining compatibility with standard targets.
> 
> Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  net/bridge/netfilter/ebtables.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index aea3e19875c6..80cd0233c088 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1977,6 +1977,11 @@ static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
>  		if (IS_ERR(match))
>  			return PTR_ERR(match);
>  
> +		if (match_size < match->compatsize) {
> +			module_put(match->me);
> +			return -EINVAL;
> +		}
> +

Are you sure this catches all bad requests? AFAIR compatsize is 0
in most cases, which bypasses this test.

should this be:

u16 csize = match->compatsize ? : match->matchsize;
...
if (match_size < csize) {
...

?

@Pablo: I think the 32bit compat layer should be removed in -next, or
at least strongly discouraged and slated for removal soon.
