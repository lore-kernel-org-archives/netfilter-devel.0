Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43133264F9;
	Wed, 12 Aug 2026 20:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786567325; cv=none; b=V8RM7nylzxqobxFRKWlzHKDGWuAg82+0gC/ds5PwbeBKaUvFhqCMzPhlQXBHfUydFjtECyVG+RXdhqWIsXZUx63LCiy6LRdzwxjk5pgyjSFHTenItDJRfJ+rrkW00KFzRP1sAn7lFj5rXIFezBQA7jSlulgYQm79yAZsqt0BYnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786567325; c=relaxed/simple;
	bh=vbboMlkCG6Ih9WYK7WBb0Qe6u9LM6m6fEY4QsPU9dwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b89Y+as0zqaR5dFeGDmFN0NrikFA9OXHPoMtQ0aj4ZBq8a62v8601sEfxoBUwOrVatrbXb32hwREx3B602jWk+RS2/HfRHmGYjw5X3CxHddzY9TZ+AO0IVedatguY5vApsUjaO28v8alu82OoC6VSZ0n/qLnSfFqys1Hj/gKz08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dWk0VWpP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dWk0VWpP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786567321;
	bh=laGo1UmHOTgnZf8FvTzMXSTqr1KppFTxvmDsoefiNzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWk0VWpPXmui8OyAVcEU0pYHN4t5rjVabhLSFD1L+VrrMlKWTeFzUqZUdt1VaVcQO
	 sYHJFoEcthB5N22O4wFWiO7m9+ucI15K3yng3pRHV8YU7Hzo+VwNLUv3rZ3ATTltK1
	 skR7a26tPgQn0pFkAo0aHFmzy4nk6iGPFQz8Y9EpMnPxf8bUBNl6A1bIVbwMEAvK45
	 4jU6YNWPfsgKsAIvm1cMLZBwojrAuTNAEQw5xVsS1rpJ6wf04Zmpo2jA7y8A0RZY+i
	 WMdfzrbmi2cjjjVl8uGF8fMf8usACX/wz7YivYJBOeUQoQ+9+QWbHBXUSzheuoKdKC
	 HcdMOmQmlH1CA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CD86A60082;
	Wed, 12 Aug 2026 22:42:01 +0200 (CEST)
Date: Wed, 12 Aug 2026 22:41:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 11/12] netfilter: nf_conntrack_expect: bail out
 on insert dead expectations
Message-ID: <anzal-pjpO6mg5Xv@chamomile>
References: <20260810194015.932627-12-pablo@netfilter.org>
 <20260812013447.1676073-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812013447.1676073-1-kuba@kernel.org>

On Tue, Aug 11, 2026 at 06:34:47PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nf_conntrack_expect: bail out on insert dead expectations
> 
> This adds a check in nf_ct_expect_related_report() that refuses insertion
> of an expectation carrying NF_CT_EXPECT_DEAD, returning -EINVAL and
> triggering DEBUG_NET_WARN_ON_ONCE(). It is described as hardening for
> b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap
> expectations").
> 
> A couple of questions about the placement of the new check and about the
> DEAD flag itself.

This is a real limitation on this new bug trap, I forgot to cover the
expect_related_pair() case, I will follow up to address it.
