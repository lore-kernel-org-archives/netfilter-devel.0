Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611613D8B1
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951885; cv=none; b=DQYWpIbw5rGlrgpTXGkV47UMiXTvBBYUVMWpBacppWQ1qUtcogPeGWLcs41r2c3VtvTacBtV0TPV2/H0fLeIUHuuab6mxIDthpmmp3GCpbxqjmzbYy12lu25zLCpM3GH01YfUWMZOzTQtkii/XJbpHHKF/kteyNbqd8uSPMleVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951885; c=relaxed/simple;
	bh=kgQgij2FmsmtxNyskNKyMjEVfLTTSQIvYAoj6K8vako=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hh72lpPtK7Oy7KFGRGZmocfmncs6bcWy/jXc+x5hRdLOvdWCaUFUuw+vMQ+06Gnt1e9OIb61PeACPryDfwWhDwuV8tvlNvbIp4kFRXJfXsnwujzBfysw9gO3huCJFBVS5J56T+txoivvLFLL7te9LVmNh3VvcUyGyT3I0k5SWv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TqKbQz35; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TqKbQz35"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CDAFD6019B;
	Mon, 13 Jul 2026 16:11:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783951880;
	bh=oTfRYSTUMdl3CBEZTKXogqu6X5//qv7qd5QLR5WF93A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TqKbQz35H+16BWjtUUTKf6Ze9MUcakZfnseve7rM/HUKysIIRzb9r0h4E4Hkb6+sc
	 5/2nw0xTlVEEFFDFkE1aotqgt6K/nQDNMB5MCePROvNHPRNcRxxZzJr9BnoQG7CF5B
	 PX+MNgMmjcYwMfrlfgPuqYE/nCE40eGgAyqVZcxKW28N8zil/HNpIBOIiXn5cyDD1O
	 DuvNcbQYV3XvKBHL7haIvEMb+dJUDvAm+lBcrdnc3K9dQFU71G5FAC3x4AI+vCfVJd
	 MvryEnbeXNbQnToBmBQ3zDQ90UqZFYsZrz2xD20PeBEl9KC/SCY89YQSMwDPvp1hY1
	 W9col97jepZXA==
Date: Mon, 13 Jul 2026 16:11:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH ipset 0/7] test updates
Message-ID: <alTyBhLh8lbaoEiA@chamomile>
References: <20260709200358.15504-1-fw@strlen.de>
 <b84ff62f-bdea-4999-d889-c6e4da6d191e@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b84ff62f-bdea-4999-d889-c6e4da6d191e@blackhole.kfki.hu>

On Mon, Jul 13, 2026 at 03:35:14PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> I have committed Florian's patches but it seems my old rsa key is still
> valid at git.netfilter.org. Could you replace it with my attached ed25519
> key? Thank you!

Done, please give it a try. Thanks.
