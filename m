Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35C1A3028;
	Mon, 11 Nov 2024 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731344180; cv=none; b=tuX/Qw7nI/OFs1oLJ2+De3k5BRsWj4AfpQc5i6V4+ieijNkQcglXBLVCOQZPMBZFkpRKOqzEsyrfzR8kQ1uMjjMxp4LGV6VPLq9SdpSsmCnhockkYILwP+YigjFBIcKIQt96Wgv18WToqbDJqX9Fd+UmmC6sF5hUKUWDXfb9f1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731344180; c=relaxed/simple;
	bh=CPbt4ptTClt1ZwrN1NhFeJr/96tf+mEoicDZ5yuXqvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjDhcZt2Rswb7bsjF30BG7i+Ys6nkYodQcs2MPkYk24eh7adXyQZdP51M5TSytXf6HxFaqE+QyEvqHolvz3OEsglw/Jr9nfx8Noc4gwpc+tIQ5xujfMDRzrbg1tt+72UV3v5tF/KRBmIrEz9XNaQJxA+OU1OrQnZPylbS0D294A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tAXhu-0005Zz-PV; Mon, 11 Nov 2024 17:56:06 +0100
Date: Mon, 11 Nov 2024 17:56:06 +0100
From: Florian Westphal <fw@strlen.de>
To: egyszeregy@freemail.hu
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
Message-ID: <20241111165606.GA21253@breakpoint.cc>
References: <20241111163634.1022-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111163634.1022-1-egyszeregy@freemail.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)

egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
>  rename net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c} (98%)
>  rename net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c} (98%)
>  rename net/netfilter/{xt_HL.c => xt_HL_TARGET.c} (100%)
>  rename net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c} (99%)
>  rename net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c} (99%)

No, please, if we have to do this, then lets merge the targets
(uppercase name) into the match (lowercase), i.e. most of the contents
of xt_DSCP.c go into xt_dscp.c.

Same for tcpmss and others where applicable.

Renaming ip6t_ECN to ip6t_ECN_TARGET makes no sense to me,
there is no ip6t_ecn.c, so no collision exists for case-insensitive
file systems.

> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN_TARGET.h
> @@ -11,7 +11,7 @@
>  #define _IPT_ECN_TARGET_H

I don't think this can be done, for any of these files, as this
is UAPI code.

Best you can do is follow what
include/uapi/linux/netfilter/xt_MARK.h does (did).
