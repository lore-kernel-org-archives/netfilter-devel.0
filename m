Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674AB1386DA;
	Fri, 29 Nov 2024 07:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732864099; cv=none; b=KCPGJBdvBWRYdqW0DoO67+vdbeZTQC0qb7XNB0qsUIQT91+nUCSq93KYBOzzWG3vGRpwo6aBvpA9UmlNKiC3qoM5AAlxirmaPrhF/zvwx2jAtazbzi6zPIDBUPiGsJwnXnqlZzzqR/vSNZrEA0N91dlMmSI0/RUcLjzTb4DY2Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732864099; c=relaxed/simple;
	bh=0W4gdl3LHtpXQqUcw6Hs+0eg26faz4Iu1fqKfJtsO1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHOO5e8KljSU9prUZ8DYm3rHAAMVuYeJLGzwx2bT7DtPFlX39BGex6CbmH+7HL/hyT3OS8gL9oDLhegEAeE7/mUM7Y0h/l2jfoWS5AAe8XN/zQdiLeJM9gwJWJmFtKvhv2Oxu7cQjA9vAAANknVX4unsffomgquHGmzwREKCwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tGv6j-0006q3-6S; Fri, 29 Nov 2024 08:08:05 +0100
Date: Fri, 29 Nov 2024 08:08:05 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?U3rFkWtl?= Benjamin <egyszeregy@freemail.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, kadlec@netfilter.org,
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
Message-ID: <20241129070805.GA26153@breakpoint.cc>
References: <20241111163634.1022-1-egyszeregy@freemail.hu>
 <20241111165606.GA21253@breakpoint.cc>
 <ZzJORY4eWl4xEiMG@calendula>
 <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)

Szőke Benjamin <egyszeregy@freemail.hu> wrote:
> and lower case *.h files can be merged to a common header files like
> "xt_dscp_common.h" but what about the *.c sources? For example if xt_DSCP.c
> removed and its content merged to xt_dscp.c before, what is the plan with
> kernel config options of CONFIG_NETFILTER_XT_TARGET_DSCP which was made for
> only xt_DSCP.c source to use in Makefile? Can we remove all of
> CONFIG_NETFILTER_XT_TARGET* config in the future which will lost their *.c
> source files?

Sure.

> obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
> ...

This line goes away.

> obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o

This line is changed to

obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o

Kconfig file NETFILTER_XT_TARGET/MATCH_DSCP are changed to
select new NETFILTER_XT_MATCH_DSCP.

This has been done before, see e.g.
28b949885f80 ("netfilter: xtables: merge xt_MARK into xt_mark")

you can follow this almost 1:1.
