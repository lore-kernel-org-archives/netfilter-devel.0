Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB719CC3E
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2025 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745505364; cv=none; b=PHrASR7JSH0I5G9YtJwutN0BPZzRt9EtuGovoM1DADndsFGovZmP0kPVB++J35uQfgS7BgaFF0sT8wrpJAcusNZOL1hH9MbzbTWmxwPx7jrzegwXsYJ0zCcOkpC7y0iUwFONMKafbhUOsVNgUUfOiiYnON1f4jn8hYycBmcqctY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745505364; c=relaxed/simple;
	bh=o7naMv77Z5nHTGQCNNa00KQ0mVjO5uwmH4Ax2GFzHuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSrO2n1PG0WnESbSKvlXwJYoPS3lGmW2ZWkWjcL9SFQXqHwsFq89TB9AXer0HAfgnlhNOTRNvELatUofgYhSwg8kgElZ8dZy3MNm5cuSSp+KQDqvc6v1n8edR3FxLt+S7Ijz4NFk+watyIE+HLIlQoiYijlEffaAD1VyoiZ5Y1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FLv/rhB1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FLv/rhB1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FLv/rhB1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FLv/rhB1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 92DFB60ABA; Thu, 24 Apr 2025 16:35:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745505357;
	bh=0RsKzVeggbq7HKa/c8XZXpZw+RuN0lk/aeIEQ2TcQdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLv/rhB1GBFzsFV+41S+HjFCceNfHeiMd0tybGvqiySBjfvfveRy2WB8JzasLj2MZ
	 GBUfiLUxGARNjYlG4d2jibsFnJm5GuLlAA+PNQYQbnxnqWOGlv1Wh0cVhn2wE/Bfw8
	 SF7wWppvVdCCjisxM5iKAf9DnMCVwblL2BWrsHcD6xXxgMgmosHlh+KY4C7iMQtRRi
	 twd7SdltAwfZQmxYOhn06Gz9DmlBUyr4Jzeyho39qBmmDkkF26CaBf6FAzDrjzjnSj
	 bgDlEGIsj1STj5GW2pqrdqDI07yUvwlweoXdb/HTC3exmDO2xjMWnNtaZAHZFhrWjt
	 xICcPOTZETobg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DEBDD60AB3;
	Thu, 24 Apr 2025 16:35:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745505357;
	bh=0RsKzVeggbq7HKa/c8XZXpZw+RuN0lk/aeIEQ2TcQdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLv/rhB1GBFzsFV+41S+HjFCceNfHeiMd0tybGvqiySBjfvfveRy2WB8JzasLj2MZ
	 GBUfiLUxGARNjYlG4d2jibsFnJm5GuLlAA+PNQYQbnxnqWOGlv1Wh0cVhn2wE/Bfw8
	 SF7wWppvVdCCjisxM5iKAf9DnMCVwblL2BWrsHcD6xXxgMgmosHlh+KY4C7iMQtRRi
	 twd7SdltAwfZQmxYOhn06Gz9DmlBUyr4Jzeyho39qBmmDkkF26CaBf6FAzDrjzjnSj
	 bgDlEGIsj1STj5GW2pqrdqDI07yUvwlweoXdb/HTC3exmDO2xjMWnNtaZAHZFhrWjt
	 xICcPOTZETobg==
Date: Thu, 24 Apr 2025 16:35:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] tools: selftests: prepare for non-default
 IP_TABLES_LEGACY
Message-ID: <aApMSm-Uq6lCK2pk@calendula>
References: <20250424134930.24043-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250424134930.24043-1-fw@strlen.de>

On Thu, Apr 24, 2025 at 03:49:27PM +0200, Florian Westphal wrote:
[...]
>  This could be squashed with
>  netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
>  Or it could be added before.  In that case the commit
>  message needs to be updated (CONFIG_NETFILTER_LEGACY knob
>  doesn't exist yet in this case).

Thanks Florian, I am going to collapse this, make a few more tests
then prepare for another pull request.
