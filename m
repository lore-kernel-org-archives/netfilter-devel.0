Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB934AB04
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525684; cv=none; b=KSp7tTBFY05E0S8KPtazfDCCp2MjrkSSF82eD5D0tx0hFcpNYOzCU/njMZTATTVLBnG++7PqWrKdgC0nFeo+/AwhZGMxX8PhFx3zagn/59yy2zn7HysPzjHpBN1YvgAaOmbhhmfRKjQmwfm7k/eVIIpSykDOBqU4dELL9HP8PtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525684; c=relaxed/simple;
	bh=wtnyAd5a1M0IDNCcaRZEfSSrH/cBd/HVpVbQdFB9oNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sV72UcjGeeGWcfhPd/PrL5OJHoJFkKk9LaK7HjVYgX5PLw8KrsL89m7q2gFwEkI5kcL7MTrWtYLLF0k1uPhn3VeNTO+eM+4rG2TTitpTdGnotcIVfgY9fkBbPy/3TMmy+0Vke09xFERMLgUy2KqCDSSU/4n7nJlmA5by+D9UzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Zuxr9PJ7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Zuxr9PJ7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Zuxr9PJ7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Zuxr9PJ7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8D23D60269; Mon, 18 Aug 2025 16:01:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755525678;
	bh=l1dtidGBRxR3AshiuE9qqrGRfCDUW7Bo37/Ns00i9PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zuxr9PJ7LYZtXn5wIPguoiyElrOYU8XDXEEJ0nUpDNZMqELeJuD2BcOwn72s5rm1q
	 HV+7P4mBWDvLNDVwLX5ozeH6HORd4q9b4Okxc6m2beP+iEEgkyczRS3pRNhy+D/g1b
	 1pEazS9m9JP9SCwHbj7J/ic3Ol9tsdQTbSDw7E/VmaOMmaqQukKKfYP6nTczqi+fGG
	 mjyNOOsV/QXf9Nh4qgPyJUvzdvj7iBt4jLAWupG4cP0cbAmC1prW5GmsWFtGPwKkJ0
	 ZOYVyFGiKdltQaMcLn7ekfLdlN9S0qDIS7S0sgjbzt6RRsBYU8fqtwpNRUTn82EYEI
	 SuazHRK7netWw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F0EF960269;
	Mon, 18 Aug 2025 16:01:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755525678;
	bh=l1dtidGBRxR3AshiuE9qqrGRfCDUW7Bo37/Ns00i9PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zuxr9PJ7LYZtXn5wIPguoiyElrOYU8XDXEEJ0nUpDNZMqELeJuD2BcOwn72s5rm1q
	 HV+7P4mBWDvLNDVwLX5ozeH6HORd4q9b4Okxc6m2beP+iEEgkyczRS3pRNhy+D/g1b
	 1pEazS9m9JP9SCwHbj7J/ic3Ol9tsdQTbSDw7E/VmaOMmaqQukKKfYP6nTczqi+fGG
	 mjyNOOsV/QXf9Nh4qgPyJUvzdvj7iBt4jLAWupG4cP0cbAmC1prW5GmsWFtGPwKkJ0
	 ZOYVyFGiKdltQaMcLn7ekfLdlN9S0qDIS7S0sgjbzt6RRsBYU8fqtwpNRUTn82EYEI
	 SuazHRK7netWw==
Date: Mon, 18 Aug 2025 16:01:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: check XOR RHS operand is a constant
 value
Message-ID: <aKMyK3QfkZ0xocg8@calendula>
References: <20250805194032.18288-1-fw@strlen.de>
 <aKMyDsWdj6Bapv7j@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKMyDsWdj6Bapv7j@calendula>

On Mon, Aug 18, 2025 at 04:00:49PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 05, 2025 at 09:40:14PM +0200, Florian Westphal wrote:
> > Now that we support non-constant RHS side in binary operations,
> > reject XOR with non-constant key: we cannot transfer the expression.
> > 
> > Fixes: 54bfc38c522b ("src: allow binop expressions with variable right-hand operands")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Maybe a tests/py for this to improve coverage is worth?

Sorry, it's coming in 2/2, that's fine. Thanks.
