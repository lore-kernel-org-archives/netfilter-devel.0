Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48D43218B3
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2025 11:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760528813; cv=none; b=a8mf+kOE3wSXdqU0pnZ8M0szS5wLQr85isVsokoy/eL+dRJCjuymsjuCmn8OpfioM6tU4Puc5Fyv+k++OYL2OwsMBs6ZUY0OmRd9hSQLGP95YBvZysXliT7MLKj01CZlC5X01eD8rjkLPICJ0v9hATXJeUV11drEuSRARPLqzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760528813; c=relaxed/simple;
	bh=/Llx/tyO2ESQz4oowmST0gPWBwbS8w5ywavTXsENz6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU7iBWrnDR0oqQGVTBH0b7zqQ705AjM5m/I/RxTGzBP598oXfPFfo/mATlu35hzhX1FGtEXp74h7HDXrQIxuBhbnZnVT9L0kmCoD8jNNf7iZO9DhteksrDEpwW/MEcPXAM7YcDfSH2v5sjY2C8vWlku9s57M1T/eEFfrir9YYtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DFA4B60186; Wed, 15 Oct 2025 13:46:48 +0200 (CEST)
Date: Wed, 15 Oct 2025 13:46:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 1/7] doc: clarify evaluation of chains
Message-ID: <aO-JqGMgkSmgEUF_@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-2-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011002928.262644-2-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> In particular:
> - Mention that grouping of chains in tables is irrelevant to the evaluation
>   order.

Applied this one with minor edits, thanks!
