Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2A1ACDE7;
	Mon, 11 Nov 2024 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356334; cv=none; b=MWpT2dR0mwVQJtKd29ace6FesiqaNE6Vv5gJJKbsr7MJh3aAgKAzNIMufYaQZToEo70KylN5LPMSbWi3f2oiYVv7xfl8PgwMIuOJn93MIoiB63ufbd/qhYi5yfaByy3FjMYvL6BZCUiTS7CjfiQvIbhjE0VJ2OrvswsxbyJnGhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356334; c=relaxed/simple;
	bh=5i5l9MKkZVlFVs5cwNIXH5c0rcSzMfWOTFR/CxDx4Us=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VH0JhwVhQSpA9gdUKF2oA6i/w6Y0D5Fnpqq6uW/H6/3p677Mnz3Z0kGnUQr2jToXDHtp0JthdSlH+Bs7iJtRInAA/yxpExMsJbAuYABFt4+TCM7Jjxxlo/iky3vb7/2awPbQtC6olXQaMViRxl2MarW3jvwnfWI5EvwV4H18EDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 04BFF101A397E2; Mon, 11 Nov 2024 21:18:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 02DFB1100D3C49;
	Mon, 11 Nov 2024 21:18:42 +0100 (CET)
Date: Mon, 11 Nov 2024 21:18:41 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: egyszeregy@freemail.hu, Florian Westphal <fw@strlen.de>, 
    kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
In-Reply-To: <ZzJORY4eWl4xEiMG@calendula>
Message-ID: <706544q5-q0o9-8sq0-9q14-onr01r8rqq5q@vanv.qr>
References: <20241111163634.1022-1-egyszeregy@freemail.hu> <20241111165606.GA21253@breakpoint.cc> <ZzJORY4eWl4xEiMG@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2024-11-11 19:34, Pablo Neira Ayuso wrote:
>On Mon, Nov 11, 2024 at 05:56:06PM +0100, Florian Westphal wrote:
>> egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
>> >  rename net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c} (98%)
>> >  rename net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c} (98%)
>> >  rename net/netfilter/{xt_HL.c => xt_HL_TARGET.c} (100%)
>> >  rename net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c} (99%)
>> >  rename net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c} (99%)
>> 
>> No, please, if we have to do this, then lets merge the targets
>> (uppercase name) into the match (lowercase), i.e. most of the contents
>> of xt_DSCP.c go into xt_dscp.c.
>
>Agreed, please don't do this.
>
>We have seen people sending patches like this one for several years,
>this breaks stuff.

Because all those submissions renamed (e.g.) xt_DSCP.h to something
else.

It's kinda obvious that #include <xt_dscp.h> and <xt_DSCP.h>
must produce the same declarations as previously available.
Which seems doable with a layout like so:

xt_DSCP.h:
	#include "xt_dscp_1.h"
xt_dscp.h:
	#include "xt_dscp_1.h"
xt_dscp_1.h:
	<the usual contents>

That way, xt_DSCP.h overwriting xt_dscp.h as a result of `make
install` (or some other file creation action) becomes
inconsequential since they have the same content under that model.
