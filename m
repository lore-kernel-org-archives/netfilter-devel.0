Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CA6255248;
	Thu, 21 Aug 2025 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755758244; cv=none; b=IHESy3q9gCJ8cAgGTUBkAU/AVfjKk3rSEGm4k+RZEC3UR/eDrFxu7mSywDmhvHd2U47GAkEGyoaJzvDpgmOr1aaCsoCpr6FYZIKsIDEZAlnNKSXXfNneUCjWY4CyAO8htDjaDA4lgUkO/ut10JqEbb97FARiC743ftI6NlHqB4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755758244; c=relaxed/simple;
	bh=fIPjFgU4kbJHAMX5NoqzdFE8Hxcq8vV4q6G70L/GAAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdG1X0e1dFEmFdzQM7ffM8F19f7nwwa7fQ5ts9mWeGj3B87Ksq4xfOUOFSetd60x3I9bp2sOcqMWfsw+ugFhVkcgYXEu8IG4XpXLQACo4t3Cp9SO5lns/9VTBuZcgqiJ52Lm7JR0MrtyFsIWX6jwdAkTGZcnzURyMetXr/rXZY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oIEAKtvC; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=KN0OingQ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oIEAKtvC";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KN0OingQ"
Date: Thu, 21 Aug 2025 08:37:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755758240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7nDs/D4cyXax7bq0/ER/nxMXVP+lSfgy8DQRWLUXCeQ=;
	b=oIEAKtvC6pWqCLaN4se0+Tj60Vf0m/v8jMljcT64+LhITUTHBqppHia2ir5+Tn8D9lu0m7
	USDAv+vBAcz8rXrDGXpI0ZhOGYox4hlHyMxmT4n0lsdOhyQt9KN+KR6v7z1FNsAMO2FSkW
	S7suh4XiuABocgrO8me0AwKwFjSYoX2N6W0phpI1F60lJHJrfvjCDWXGTs26yconA9m4ak
	ZFrtHeDMF41RuyH8pwLpa0wFtOfCv8nhm1nYXgd/fiHmiBaQj+8BN8bzO9XC9NbK0L/4+k
	eTllLtoEwHQCM4zauKM8r1LBC3C3tVAE7iiIu1TsNob5+HqcqtNxo7aqaIQdaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755758240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7nDs/D4cyXax7bq0/ER/nxMXVP+lSfgy8DQRWLUXCeQ=;
	b=KN0OingQ10+N2C9Xyj48IGU+Ka1FkFnmk7xUrIrxZmANX9smIXWXbzZbU1P415sPGi0HCa
	aUl8qSJMLhfojbAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250821063719.SylAQzbe@linutronix.de>
References: <20250820144738.24250-1-fw@strlen.de>
 <20250820144738.24250-6-fw@strlen.de>
 <20250820174401.5addbfc1@elisabeth>
 <20250820160114.LI90UJWx@linutronix.de>
 <20250820181536.02e50df6@elisabeth>
 <20250820162925.CWZJJo36@linutronix.de>
 <20250820183451.6b4749d6@elisabeth>
 <20250820230445.05f5029f@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250820230445.05f5029f@elisabeth>

On 2025-08-20 23:04:45 [+0200], Stefano Brivio wrote:
> On Wed, 20 Aug 2025 18:34:51 +0200
> 
> it's a single run and not exactly from the same baseline (you see that
> the baseline actually improved), but I'd say it's enough to be
> confident that the change doesn't affect matching rate significantly,
> so:
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> 
> ...thanks for making this simpler!

Thank you for testing in the meantime!

Sebastian
