Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523794;
	b=SeCnOcSJDE/sjiBlKHjp4UnnJ38LaEmdh1qCD2FsiguL42YPAfLE489JBn3o/9Mn0+QZ
	 OEv53CfTulO8tFGb15fZCmcHBP3QYObmTgk+UDWeW4k5bMSp/co+dsVL0eaaL6RKN9O4b
	 Q8rSZ3ErVaLlwfZMy9eJ6yk0AlskMC4n22x6ifIRp7MjeQ2dm/7u+uXqZigGpXlQcRxAF
	 wdljGfuk+lp6Nmv2Tm35b7tPmmLS2G9wsmUoqveDQG0JouSstDg76U4Yq1jcnljjWLguC
	 cFDroo+uyzS5gNnHtGoonMSL/UMXLFsL8z9PPapBdyECpjoUN4ls6y/X6hiYY5xROww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523794;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CYKdYnCEUsSy3YSyFifRtnmPtCvqUVR+bj46YyQhHho=;
	b=w3rvzFzYQtchIxjqm+rLil8fW4dsPK1ajBbVKtWsoOGcdFAmPZk7KOe520LZx4nwL/nD
	 2uWbHmr7p62T1oaNl1+9pBZUiv84b51qpd1LfSpo4IenUzkHDsoUHKlC+LI2MvhVC2xTz
	 Ny2nJkme6ouPFPVUJQlpaVyHIK3QDDrV1Chatpcp0JpOdQaBBkU5lmhhFbuLV/gKffvvQ
	 I9Y4Qfkq6L30S0c8XxS3jrUWf2q1eI1VPFrm0WcgCJBgYNJQbEOqLuRjI72M2giqwXPYT
	 wlPO6zdcsOmb2xWbTpqAZZjmP1AZPXJUvtp87/+xpir8z5WTPnXKTrew29zIQo4J5ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F82606A31E;
	Tue, 24 Nov 2026 12:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27F82606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77EBF60327; Tue, 24 Nov 2026 13:36:30 +0100 (CET)
Date: Tue, 24 Nov 2026 13:36:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awWEtyMI_-VEreFq@strlen.de>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> Unfortunately a couple of in-flight nf patches prevent the CI from
> picking this series:
> 
> https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
> https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/
> 
> Could you please re-post it? thanks!
> 
> (Do I recall correctly that guidance for nf patches is to not CC netdev?)

CC'ing netdev@ provides no extra value to us.  Quite the opposite as
seen here, this means another delay to a backlogged subsystem.

This is coming from get_maintainer.pl, which for these patches gives:

Pablo Neira Ayuso <pablo@netfilter.org> (maintainer:NETFILTER,commit_signer:11/16=69%)
Florian Westphal <fw@strlen.de> (maintainer:NETFILTER,commit_signer:9/16=56%,authored:3/16=19%,added_lines:168/436=39%,removed_lines:73/217=34%)
Phil Sutter <phil@nwl.cc> (reviewer:NETFILTER,commit_signer:1/16=6%)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Eric Dumazet <edumazet@kernel.org> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
Jozsef Kadlecsik <kadlec@netfilter.org> (commit_signer:11/16=69%,authored:10/16=62%,added_lines:264/436=61%,removed_lines:139/217=64%,blamed_fixes:1/1=100%)
Yifan Wu <yifanwucs@gmail.com> (commit_signer:1/16=6%,authored:1/16=6%)
David Lee <david.lee@trailofbits.com> (authored:1/16=6%)
netfilter-devel@vger.kernel.org (open list:NETFILTER)
coreteam@netfilter.org (open list:NETFILTER)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

... which is waaay too much, IMO.

Would you mind a patch that alters this to only suggest:

Pablo Neira Ayuso <pablo@netfilter.org> (maintainer:NETFILTER,commit_signer:11/16=69%)
Florian Westphal <fw@strlen.de> (maintainer:NETFILTER,commit_signer:9/16=56%,authored:3/16=19%,added_lines:168/436=39%,removed_lines:73/217=34%)
Phil Sutter <phil@nwl.cc> (reviewer:NETFILTER,commit_signer:1/16=6%)
Jozsef Kadlecsik <kadlec@netfilter.org> (commit_signer:11/16=69%,authored:10/16=62%,added_lines:264/436=61%,removed_lines:139/217=64%,blamed_fixes:1/1=100%)
Yifan Wu <yifanwucs@gmail.com> (commit_signer:1/16=6%,authored:1/16=6%)
David Lee <david.lee@trailofbits.com> (authored:1/16=6%)
netfilter-devel@vger.kernel.org (open list:NETFILTER)
coreteam@netfilter.org (open list:NETFILTER)

?
