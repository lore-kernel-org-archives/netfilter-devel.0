Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBFC20EB
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716204448; cv=none; b=WvT4ogs6HsKWBr7a6Fi6kRPSNd9nYNgdn3O0jn+nRtrSXYwnNOl5pN+epkaWLGo/JCc+ipaxtC92HwXEij95hTWjt5VbgixL2QD07TOdhfduuQQq8nLHiwjCjhNA2PY//Q/c5Vkqdf/7cJb1fmfdBKsv8chMTL83vXDKJnFH/DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716204448; c=relaxed/simple;
	bh=G613Hq8ijq9CnWRyB260A6BwwBkHs1YNm+CfOY0nox4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xayzvjog0pBz1BOcS8xMKXkWWnc8quyGxlMTMsGV0nfC6PivhBzAI/hcm8j5izYI+F+z1K1H79kxzmA3S4ek/vaYDOXOxpeupMgZljzEByfpnBD38meJKs1SQAd6f7Q0SmMCEIyiKFBtGEzJFnA+Nv+BKfNx1O0rdk6vlUD8fw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 20 May 2024 13:27:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <Zkszmr7lNVte6iNu@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240513220033.2874981-1-aojea@google.com>

On Mon, May 13, 2024 at 10:00:31PM +0000, Antonio Ojea wrote:
> Fixes the bug described in
> https://bugzilla.netfilter.org/show_bug.cgi?id=1742
> causing netfilter to drop SCTP packets when using
> nfqueue and GSO due to incorrect checksum.
> 
> Patch 1 adds a new helper to process the sctp checksum
> correctly.
> 
> Patch 2 adds a selftest regression test.

I am inclined to integrated this into nf.git, I will pick a Fixes: tag
sufficiently old so -stable picks up.
