Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A70836F41C
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791413374; cv=none; b=lcFN70phhuvNL/SaddBjCUXjB5ufgmKgrl5UMjFASkYoOxY5Bx7kpU0zOFscOa1cu6VZC35yOTcn/sMwGeU5Odf6QZbRbgyQ6XyFkQ5KA6aDKQIu2E8Wt79+y2FOIshfNFk4QhMj1mxu+yuCjDG/cc7sVMbP7CVxKTRvR8TpKmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791413374; c=relaxed/simple;
	bh=LP3coihyobn/gIyEXt62ogs/GCfB5ORXn9uEyugGBLM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k40JW4FLRDHdLxNY0c53vuGrp1uDfI37pzNbaQWdo4Wj1dWyf6tNNLu2KqfAx7dr/ei2uqnQIpklUp1bI9nZu0tyH6bOMU5eGeQPn8mW8Y4nzMqJ4NZMyHyfmykodyEh/7wQmBwaEhMMpxQtGgX8N/x3O7tHEDXCCRksixCm1L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=THGUAayB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="THGUAayB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791413370;
	bh=LP3coihyobn/gIyEXt62ogs/GCfB5ORXn9uEyugGBLM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=THGUAayB+eWNnbQY/uHzCy+vHq5KgZm1vV3SuGj7phTtNadTJKtugZMGLjdVG9YBU
	 C8dPxIyOzcYvw6jnHviR8Qv1k/F9/eK9kW5bu8Ccjz1uhrOhDlnAZUj8NPnoxEDyWM
	 9hQ3tzOlJJvLQ+dgjCOaS9BywKoso735XFijqsjNjZtF4sYHaUQKoOQpwz4chGYfeR
	 3tquvfJfCsXEIIuaevG6BFqPPp8AoaokKyqqHwIgg9ibFZffEbfulvzOHqVhbpgLzn
	 5rnn6jbMrziljgImPX5sP2dF0z+toxknBxR8daS9mqZ9Q+gYYEp5TiaaZoHdcJmT+3
	 BnszdFJMnyEmA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AD2C760055
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 00:49:30 +0200 (CEST)
Date: Thu, 8 Oct 2026 00:49:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
Message-ID: <asbMeORd_D_FIKxK@chamomile>
References: <20261007222057.1141093-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261007222057.1141093-1-pablo@netfilter.org>

On Thu, Oct 08, 2026 at 12:20:56AM +0200, Pablo Neira Ayuso wrote:
> This patch adds bridge flowtable support, this allows to define a
> shortcut between two bridge ports. This is complementary to the
> existing inet family flowtable support.

This v5 rebase needs more careful look, because of several updates
that went into the tree. I will post a v6 asap.
