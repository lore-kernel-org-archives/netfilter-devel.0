Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2ED30E836
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769788897; cv=none; b=grvfUW7NDk0/1jYWx6Jh7CrSIO+eHbD6NRVXmRpKhtqI4El/8pAQYLabBbn9rJQd39kr+CGzN8tw8WrCAdOfndEJUlBzkzQrPOe7duTq0nmvz33XhiKm9OlnaIHTB5TUV0RGubkqjhN5x9PGiEsDl4VQDgGI/363SoLiKsmlepY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769788897; c=relaxed/simple;
	bh=/OeTRspXjE6PirClchJps+UN1FTdhzJe7fwW7kRQqLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7dGBdoMw5kwz3zBRzDHvVQOjHgi40zBVOcCPVjX/W2bSXNf7IpPYgCg38nSJXLg/j8MiXT61Cjs+dst/Rde8Jbyu8qVaMad5ncPe2BcvOJRFnSL2Ip5HBMGnIQetr8GvJSagOvJevshi7gtM2QNta/EWYp9KZgc3M8kGHTnOJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BlE+QuP8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BlE+QuP8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FXiUlhkFvU2yNVsURqcufkWQw6snYEM6BbBqDAlnrSo=; b=BlE+QuP8EGImJ8p/u+xYImntky
	bH4vTnE37WZRbWiEfALZ3BIbOaU1Z/XeBVtnBHI2nAzWgCIzUEWb9FrEVv7UK+RdgUgc28e8hb7sg
	cd/CPzgHP2Bui5n0NkSJhYTcsMSNeZ3c2005014kIKxvPJn6QYxc9O9Jai6V9YjqTTuLq2ZtXIptY
	aJYCeTKJ0ZVQyZHj0ozU6ME7/xxHYDfzbJKAnG/myW8ohin/ixYnZEsSBol7mHVwsr76T/dFvJDo7
	1/b8DQMbZu2+d8p6lcx5FLNzNuXLj1aGQE0Ew7fOZ5Vc637bWmNKx9zeeMu61D28qyxSh0b5fe1AH
	p/HaA0PQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlqw1-000000001LX-3LgK;
	Fri, 30 Jan 2026 17:01:25 +0100
Date: Fri, 30 Jan 2026 17:01:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Mathieu Patenaude <mpatenaude@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nft bash completion
Message-ID: <aXzV1cB0zHqe4wwl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Mathieu Patenaude <mpatenaude@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAJ-1uKHCK_yGx7WUAyOpoTn5QJFhu5khG4W17Foj_3ovgTjPwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-1uKHCK_yGx7WUAyOpoTn5QJFhu5khG4W17Foj_3ovgTjPwQ@mail.gmail.com>

Hi Mathieu,

On Mon, Jan 26, 2026 at 10:26:16PM -0500, Mathieu Patenaude wrote:
> Just inquiring to see if there is any interest in adding nft bash
> completion to the nftables project tree?  I only found a reference to
> it dating back to 2016 (patchwork RFC), but I'm unclear if this was
> ever merged or if I'm just looking in the wrong place.

AFAIK nothing exists yet.

> I wrote something that works:
> https://github.com/mpatenaude/bash-nft-completion/blob/main/nft
> 
> Let me know if that can be helpful.

Just to clarify:

| # - Provides completions up to the start of a statement (until a '{' is needed).

So this does not complete statements/expressions when adding a rule, and
completing the initial part is limited since it can't find out which
ruleset elements exist already unless sudo does not require a password.

Is the latter a requirement for the former? I.e., could it continue to
complete something like 'nft add rule t c ip ' despite it does not know
what "t" or "c" is supposed to be?

Cheers, Phil
