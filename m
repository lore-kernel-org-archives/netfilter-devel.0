Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B21BC06C;
	Mon, 11 Nov 2024 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359807; cv=none; b=d3RSh594tJuf94wLXDi8bTCRjZQR7rSIRtVhXn2XZPb22RMnKry84dAw/xtlfHR75qQdXsI8KW5JCNIynTjRXzdvGmBlJvvw02kpy0nCs9hEjYCiV2FuUk9di7Fw+QVWm9GWNtWg9Y/LrnRB21DOkMnazSYvzz3cRLGOdh53Us0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359807; c=relaxed/simple;
	bh=LFUxDm15kTu7EqTwyvhKA9ENEhPjrw6Y5ATaPQBTGPk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Y+QvGJBgOndC41VV161CsiTQi2VxDXA0i5yWW3EQoxLfENwCxfGyeuXIyRm/6V4b3s/HVb9GpgELsEoivJx8T6omktlLV4eqovn8/aK2ZI6l5F/uA5/xBWxD6DJdzzfqrGmnXM11llThSUvdZq98y+GI6T+LH630v77pdC1y/Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id DCE5A1003F4283; Mon, 11 Nov 2024 22:16:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id DAFB21100D19CD;
	Mon, 11 Nov 2024 22:16:41 +0100 (CET)
Date: Mon, 11 Nov 2024 22:16:41 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
In-Reply-To: <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
Message-ID: <3s5r805n-208r-754q-80or-or22s65659n4@vanv.qr>
References: <20241111163634.1022-1-egyszeregy@freemail.hu> <20241111165606.GA21253@breakpoint.cc> <ZzJORY4eWl4xEiMG@calendula> <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Monday 2024-11-11 21:28, Szőke Benjamin wrote:
> What is your detailed plans to solve it? Maybe the contents of both upper and
> lower case *.h files can be merged to a common header files like
> "xt_dscp_common.h" but what about the *.c sources? For example if xt_DSCP.c
> removed and its content merged to xt_dscp.c before, what is the plan with
> kernel config options of CONFIG_NETFILTER_XT_TARGET_DSCP which was made for
> only xt_DSCP.c source to use in Makefile? Can we remove all of
> CONFIG_NETFILTER_XT_TARGET* config in the future which will lost their *.c
> source files?
>
> obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
> ...
> obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o

This issue you would approach by unconditionally building a .c file
and using #ifdef IS_ENABLED(...) inside the .c file.

Truth to be told, the overhead for a module (12288 bytes on on x86_64)
completely dwarfs the code inside it (xt_dscp.o: 765 bytes), so combining
modules should provide some decent memory savings.
