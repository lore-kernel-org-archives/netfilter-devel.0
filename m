Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7163AD537
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2026 08:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785746455; cv=none; b=aPtnDuYyH4ZBUs3Kq9iJFBcT+UDxTL7jJr+A1skKYGxjei0rHsVdi1wggwPoQnP5E43dxG2X5mVc8uN5IU9Ouk1AUfaVZ8BuyOP96ISwBshW8B+KKMeRcH3r3kjxMcsXDaPWkZ4aOhZoZBjcADRcnRq+gZ3YnAcad8BkNKO65S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785746455; c=relaxed/simple;
	bh=/IKI7F7U6fbPvCK4H7Vhgnk6f3oBk/C+vGfvWhCnqRM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=V0OtSJsp5xVexdNfDKCZ91kmCZjE71cyV/Ec+jFgUA9BfPJcaI3jqXOzZH6wxfex75DUBKtaQGpxYthW8tbVKvYIwyGkgwZsw6iw4aQnJduN92QCm7yWJQ4xWmGXOESzpVIPIUHImTZLjy3z3laP8y/zdd6USiXAlyV71fgh3So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4hD93520zSzGFDCJ;
	Mon, 03 Aug 2026 10:34:57 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id CiGToSy9ZFkk; Mon,  3 Aug 2026 10:34:55 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C23F7.nat.pool.telekom.hu [37.76.35.247])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4hD93265DjzGFDCH;
	Mon, 03 Aug 2026 10:34:54 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 461C614053C; Mon,  3 Aug 2026 10:34:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 42678140295;
	Mon,  3 Aug 2026 10:34:54 +0200 (CEST)
Date: Mon, 3 Aug 2026 10:34:54 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/5] netfilter: ipset fixes and rhastable prep work
In-Reply-To: <amusRhSn19YQzmQe@strlen.de>
Message-ID: <e7c0f855-d6bd-ce82-b223-786ed42853b7@netfilter.org>
References: <20260730183853.21868-1-fw@strlen.de> <amusRhSn19YQzmQe@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Thu, 30 Jul 2026, Florian Westphal wrote:

> https://sashiko.dev/#/patchset/20260730183853.21868-1-fw%40strlen.de
> 
> 'This is a pre-existing issue, but does asynchronous element destruction 
> in list_set_flush() race with this synchronous zeroing of set->ext_size, 
> causing an integer underflow?
> 
> If a user flushes a list:set ipset, list_set_flush() forces the counter to 0
> here. The elements are queued for asynchronous deletion via call_rcu() inside
> list_set_del().'
> 
> I will have another look at this to see if thats correct, in any case
> this should be handled in a different change.

I should have left out the call to atomic64_set(&set->ext_size, 0) in 
list_set_flush() and let the list_set_del() calls adjust the ext_size 
value. What do you thing, would it solve the issue?

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
