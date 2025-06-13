Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318DA17BA3
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749819057; cv=none; b=mYglbUCbreLayasy29SNGRkQiwRtv7HO4k+NwacsDHoiic3RYvPzPSIPxCZYzgS9la+sFVbMqj/cvaJ3k9rPMiUZMPTnOzKecxYHSqLAFbZP0YjG80r2NoWa6RZAxInM6/3sNpHo9YIS4GXdjedZbOoJro3YVs4a81WwO5iIHnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749819057; c=relaxed/simple;
	bh=5Tl5bjo39P41CMIGPo1NILUnvPyeeGNQmMpyOGwHtzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jE3JXIVbFDrpmEutNdNoWjeh4yWLS6ZnV7WmXKg6v9tRSbb0pLm+ZuIn7vlhZJm20RldEE1kDM00KBwXv0cLiv3zPD10XjivO8zAPbDB1oah1LhCiDuYx2k6c5OvfjnL8toTBWDXV3Z9iFarIueICVaEPUrrDL4xO2nLXMcjg0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VCb1s8fb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bgf+JqBj; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VCb1s8fb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bgf+JqBj"
Date: Fri, 13 Jun 2025 14:50:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1749819054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IXdroQi5Lk5EdHthETnu91DKB/N6kqs+iVRmQt3T+WU=;
	b=VCb1s8fbUYJt+2jdel4zENuGNsM0qgUQh6YKjVs2RKRNTCPukhS8xa9K7+wsjSwaCMH6E8
	JJXLTEnDgjUrKEwSJzVA8N+UrjmgABFwJqTOVB/eKt2u3QfVsa0JQhXU6N4FJ1UFCfluR/
	qWfG23Hx6tqjfwS2u1FVdb9nyvmhrQ2CURveBascSi1PKSfUuwwlHyRzzuqDnWNNqyjq46
	4NxYm8ldYPYwBL08ciBu1bh8hJZj5B1uemlKLso2KXOa90SupPAmpiJp7URZQikXx818Zo
	hFHhEIM9aD0T8yog1H04DRmPZrGJxGxY54OFpultbWZdbjzgIYWY17YUU2cm1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1749819054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IXdroQi5Lk5EdHthETnu91DKB/N6kqs+iVRmQt3T+WU=;
	b=bgf+JqBjE6NkwsoDTJZHrvJud5GBsSm7AintL/rc7oMSdxfvYtaZUQfze1zrhgqGCJS0CI
	c9gEVK0dOracgGCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <20250613125052.SdD-4SPS@linutronix.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z_5335rrIYsyVq6E@calendula>

On 2025-04-15 17:14:39 [+0200], Pablo Neira Ayuso wrote:
> Applied to nf-next.
> 
> Thanks for keeping me as author, I don't deserve it.

I've been rebasing my trees on top of v6.16-rc1 and noticed that this
patch remained (because it still applies). My other nf patches were
dropped because they made it into v6.16-rc1.

Did something happen to this one?

Sebastian
