Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E59A23817E
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 10:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761732482; cv=none; b=KMINmh+QF6Ljg3ll4LjBO+sO277EJkNyR0IL0VaZ2MXxyTCzOrP8gYNXjSXNaI86/cOEROyQdfG5evj+LKqaYeZxKBJXUZ9ROc5xI6plziAvVx2TcxCBwMMPyKPAcStPGsCx5FAcMFczrci8/2hKterT3WeLUfBSPrl4jREoIXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761732482; c=relaxed/simple;
	bh=tNHfKkP1bexFIuRfD+p4MqTX/lkSsKGrKSEjXH4Tny0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IfUc9uwO76gaxb2U9Da6EJmGhkklt8Os9w5cH22FJ1G/jE+U/BH+L2VgpL126K8q8w/cu4djWPJZjpLhhpSt12+RxlXxiTGQetPO2l7vetBRCO764NyxUmAvI8uaocbHRkLs+kZNRrOH97mvMOfQilKQ6XRfcfY77eCPxwsE+hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id A83EF10041AA29; Wed, 29 Oct 2025 11:07:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A651A11073D4F7;
	Wed, 29 Oct 2025 11:07:57 +0100 (CET)
Date: Wed, 29 Oct 2025 11:07:57 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual dedicated
 unit stop
In-Reply-To: <b88acc763d340c8f7859349621fa6a0f027610b2.camel@christoph.anton.mitterer.name>
Message-ID: <5rs82n4r-4por-6784-1n4o-39730qrs65n0@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>  <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>  <q48p3nq8-5969-0qp9-po30-nrn7s1q53109@vanv.qr>
 <b88acc763d340c8f7859349621fa6a0f027610b2.camel@christoph.anton.mitterer.name>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2025-10-29 01:41, Christoph Anton Mitterer wrote:
>That rationale, I don't understand. What does editing nftables.service
>have to do with it?
>
>The scenario I'm trying to "solve" is:
>A user changes his nftables rules and wants to get them loaded.
>Unknowingly or accidentally he does a
>  systemctl restart nftables.service
>rather than
>  systemctl reload nftables.service

>Even if the new rules are sound, there'll be a short time window in
>which everything is open.

"The universe will always build a better idiot"

before you know it they'll type `systemctl stop nftables; systemctl start
nftables`, nullifying the restart magic.

If you really need restart-safe behavior, then just delete the
ExecStop= line entirely (at the cost of not flushing the ruleset).
sysctl.service does not have ExecStop either, it also does not reset
sysctl settings.
