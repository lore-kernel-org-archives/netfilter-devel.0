Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E885C2D9EE6;
	Thu, 16 Oct 2025 11:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760613622; cv=none; b=bgreac74YDb7M8u7o+u2WkiGmyim7eHEpHRtS3a24HMP7xF0yLs24iTUS29jBj+SUbXdNKbhiqU+gEW5h6lJyEIOQgYXp3zAgLphmQK5kh1688uTWHPbAihHaEIWWQqkuYdsON9bZr8EK7T9L7/5wfPLRmkJ9ZQIM3d0nyhHO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760613622; c=relaxed/simple;
	bh=JRUebYVubCL3QW0KC1pAGr7YuA/5oFFXVxgrLB0FVJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nq0FluebpG5VXXv0y+e1qD7hTWMJxo+/CIXrulWLSiVwXP9tEVRBBCo51RJ3YG46WAXgehlx0vN4Fq3F+5aNHfwSockFHgB+Eooza03/ZKzIrIscbcvfRGtaENk1t261ltXgBOpH7V7bqStxWeX8XJhDsfflXW2DkMfkUP+7PHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 14D8361A14; Thu, 16 Oct 2025 13:20:11 +0200 (CEST)
Date: Thu, 16 Oct 2025 13:20:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] nf_conntrack_ftp: Added nfct_seqadj_ext_add() for
 ftp's conntrack.
Message-ID: <aPDU6i1HKhy5v-nh@strlen.de>
References: <20251016104802.567812-1-a.melnychenko@vyos.io>
 <20251016104802.567812-2-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016104802.567812-2-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> There was an issue with NAT'ed ftp and replaced messages
> for PASV/EPSV mode. "New" IP in the message may have a
> different length that would require sequence adjustment.
> 
> Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
> ---
>  net/netfilter/nf_conntrack_ftp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> index 617f744a2..0216bc099 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -25,6 +25,7 @@
>  #include <net/netfilter/nf_conntrack_ecache.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <linux/netfilter/nf_conntrack_ftp.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
>  
>  #define HELPER_NAME "ftp"
>  
> @@ -390,6 +391,8 @@ static int help(struct sk_buff *skb,
>  	/* Until there's been traffic both ways, don't look in packets. */
>  	if (ctinfo != IP_CT_ESTABLISHED &&
>  	    ctinfo != IP_CT_ESTABLISHED_REPLY) {
> +		if (!nf_ct_is_confirmed(ct))
> +			nfct_seqadj_ext_add(ct);

Still not convinced this is the correct place.

In nf_nat_setup_info we have:

                if (nfct_help(ct) && !nfct_seqadj(ct))
                        if (!nfct_seqadj_ext_add(ct))
                                return NF_DROP;

Looking at your cover letter (some of that info should be in
patch changelog, it provides essential context), I would say
that dnat rule is evaluated before the helper gets attached.

If so, the bug is in nft_ct_helper_obj_eval, and the Fixes
tag should be set to

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")

Probably something like:

if ((ct->status & IPS_NAT_MASK) && !!nfct_seqadj(ct))
	if (!nfct_seqadj_ext_add(ct)) ...

Could you please investigate a bit futher? To me it looks
like all other helpers have the same issue, a generic fix would
be better.
