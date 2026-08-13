Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F63203B6;
	Thu, 13 Aug 2026 09:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786612631; cv=none; b=NhgVoH14Uq/TdtVXDPoPzIfKSHTD9DikiSNn6dST1jFDSJrUpOCG82lueNGP5uUeFL0c60AoWufkEBwMkDjxsijI5jo+xFE3dKUWX5mWTwwlBWfHaSbFoqvRii4KQCgcaAYUSZ1zuypuz8+M+bEalkvALtJu6Qa4CJ5hyTM7QmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786612631; c=relaxed/simple;
	bh=tUZaz1RCucVsEDGRvj9FHxX2OFB+nyLkOg9r9Nsl8oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGkPqkSbKH6M2BHFJWAObVGAq2DaVajjayZElmC7V5UQ/5HJg2ubqX7rT8bNrqYbgQa5vIqTR/DtKV5HTccmU698M7D/1aLxL3t0ZDPdnM6doOnX+47Sjp+fYZK0Mii3xHLtmAiZPUa7FX456mczBaUaB4xcUvGfidGI7fseULk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Co8TbmZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Co8TbmZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17951F000E9;
	Thu, 13 Aug 2026 09:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786612630;
	bh=OXYcJLVzLV7Uk2tqqHsfEiLorIcsxP0S7TQAHPjR1kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Co8TbmZiW4OZ2AjU4gdPYrpgTlLVotasEYn52O+A5qhrueZsoh4R6nGNodE/Az2fI
	 t5YlmPMZ0PGJQD0/RSjbHv2CfSRBRE7xU/4u7b7YkEtuOcJGk5HJ7ec3IrhcJ5jEcy
	 u+azUcG9f0Mc48zVWPup2Wzbaurscmt0TIWj6vB6dCGKi1Pgm9p8rWTb/1Is4oZM0y
	 Rlko7CdaRjxvcCVKunVvSjc3FMx8jRPUjcDMQHZd27etMemAfrIatOLOInYViyhVvl
	 x7/0Jr/t904gU9HG886mqckl9sOWwkDO8eJ3qUvjsJSW8uoeFjCYbVwAduyf7mPd8J
	 MgU/jbF2uU4xg==
Date: Thu, 13 Aug 2026 10:17:02 +0100
From: Simon Horman <horms@kernel.org>
To: Joel Granados <joel.granados@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH v4 0/3] net: sysctl: Const Qualify sysctl ctl_table arrays
Message-ID: <20260813091702.GA196815@horms.kernel.org>
References: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>

On Mon, Aug 10, 2026 at 03:01:01PM +0200, Joel Granados wrote:
> What?
> =====
> We do two things:
> 1. Reject netns-unsafe: Replace warning and file permission change with
>    an error (reject registration) when an "unsafe" net sysctl
>    registration is detected.
> 2. Const qualify: Const qualify network templated ctl_table arrays and
>    unconditional kmemdup'ed ctl_table arrays.
> 
> Why?
> ====
> The main motivation for this is to continue with the const qualification
> of the ctl_table arrays [1]. The permission change inside
> ensure_safe_net_sysctl disallows cons qualifiaction as it basically
> modifies the entries before running the sysctl registration.
> 
>       ent->mode &= ~0222;
> 
> On reject netns-unsafe?
> =======================
> * I believe that there is currently now way that the permission change
>   gets executed [2]
> * I found one case where the warning message was posted to lore
>   (vsock_sysctl_register) [3], but it made its to mainline as part of
>   the second case in [2].
> * We should error anyway because writing to the global sysctl value
>   through a child netns is indicative of a bug [4].
> 
> On Const qualification?
> =======================
> We can separate the places where network registers sysctl tables into
> three groups:
> 1. Static global: The unchanged global static arrays are passed along to
>    sysctl register.
> 2. Always kmemdup: The global static arrays are always kmemdup'ed before
>    passing them along to sysctl register.
> 3. Dynamic global: The global static array is changed in place before
>    passing it along to sysctl register.
> 
> This series handles case 1 and 2. It leaves 3 for a later point as
> const qualifying those global ctl_tables is more involved.
> 
> I would be very thankful if you point me to anything that I have missed
> in my analysis that shows that this cannot/shouldn't be done.

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>

