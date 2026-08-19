Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C62C4A32;
	Wed, 19 Aug 2026 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787097869; cv=none; b=PgPmWCWumVOAw22xRMkBE0Lsy2eYAIpXzg9IKvKvP/pa5D7O/+ZmVmOKCZhpPli4VF5J7h/Qtw6lmMfKxFXyGuVsvvw2AkZC7RHzbjfQjAOTMaoE/U9gc24D2Gu7EgfDN1BB8j7Ila9CHKaePTEvfSPqCSg9HLLQkAQ6duOXO1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787097869; c=relaxed/simple;
	bh=WE2x7jHrm03UlaP/2dAQIQ5o8TD0gc6PX/qTsqOTrwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhoZxE8ReQf/lxr5fRhoRS3sh/GyXibK3T6uKPFzcDAfJC8uZhrrR//ymJYvBYzRJX0YYQI4FprDwiyu5+njgvxlZd1zdyBV9bwjkCRMrmMnWTZZuMgK163gz+g65GAx3dzB7zHoODB9/cgyBOknrvP/w50ASx0uDlsqkUyQxqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BD67660424; Wed, 19 Aug 2026 02:04:17 +0200 (CEST)
Date: Wed, 19 Aug 2026 02:04:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
Message-ID: <aoTzAYyHk7E-HTE_@strlen.de>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 1) Validate layer 4 header mangling done via nfnetlink_queue and
>    nft_payload, this is a follow up to recent similar validation
>    at layer 3. From Zhiling Zou.

This needs a followup patch to add validation of the checksum field.

> 2) Do not allocate memory on delete operations in ipset hash:net
>    type, delete operation must always succeed. From Florian Westphal.

The AI feedback should be ignored for this one.
The missing check for the error is valid, it is added in the pending
rhashtable patchset.
