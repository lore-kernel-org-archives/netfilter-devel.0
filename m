Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B19F23AB88
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783952752; cv=none; b=jvXOQw3caxbum/is/6cJXYIZzxBSm7kTnUqJeYMNZbW6XFJByACPo9C1RBp7VTbb2VqILHU3bwvPKhm6oFpFmFCKs5RKptoiiAXdDddFcSqdTajwEGtShbAX56jh145RvPRZkJF85DPuI9EdIkEsomKL3Q2rtqD7oAHuOF45BCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783952752; c=relaxed/simple;
	bh=aIl0hTqdIhDFI9gEf4tvCz6W9nFjLxp0sqQDS24IsX8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Upy0KrbtuMv0/5RSdGpjz4U5FKJi/4ZUl41xOTzoKw9cFKC+Z2c5sGrKj9SHf+UXNHrfgEv+F02QwWMTXoSEEqqua4MmOH2cu/xceTyEKRI0rsnkoYy3Tk+xNZnHpnA971BGXudNJf66BEG9JZR5T7HGHSXvUNSAr00tkRsJPLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=grHxT+Fy; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="grHxT+Fy"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gzPqb48cWz7s7wc;
	Mon, 13 Jul 2026 16:25:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1783952745; x=1785767146; bh=aIl0hTqdIh
	DFI9gEf4tvCz6W9nFjLxp0sqQDS24IsX8=; b=grHxT+FyjViK5MaIV+YFXOs4OW
	3lOJ4lPNkfqdIMZN9nv1qM+my9Eyc5lQtNQkbwI7bOJ2pF11ETk/vKGjxE8ED2z5
	lnjPJIWy+ksr3LqKob4qvy7CN+A3xpx7vkUsu65Q7qBpz3s7Ky/rlm2gkfyw4L7W
	jhsPFWoLPRaR4TZxI=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id OYpJPdd7YV3V; Mon, 13 Jul 2026 16:25:45 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gzPqY4H6Kz7s7wg;
	Mon, 13 Jul 2026 16:25:45 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 85E8C34316E; Mon, 13 Jul 2026 16:25:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 84BD834316D;
	Mon, 13 Jul 2026 16:25:45 +0200 (CEST)
Date: Mon, 13 Jul 2026 16:25:45 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
    kadlec@netfilter.org
Subject: Re: [PATCH ipset 0/7] test updates
In-Reply-To: <alTyBhLh8lbaoEiA@chamomile>
Message-ID: <d407b3f1-3321-4ec1-a118-6e1f9ad3725d@blackhole.kfki.hu>
References: <20260709200358.15504-1-fw@strlen.de> <b84ff62f-bdea-4999-d889-c6e4da6d191e@blackhole.kfki.hu> <alTyBhLh8lbaoEiA@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Pablo,

On Mon, 13 Jul 2026, Pablo Neira Ayuso wrote:

> On Mon, Jul 13, 2026 at 03:35:14PM +0200, Jozsef Kadlecsik wrote:
>>
>> I have committed Florian's patches but it seems my old rsa key is still
>> valid at git.netfilter.org. Could you replace it with my attached ed25519
>> key? Thank you!
>
> Done, please give it a try. Thanks.

Thanks indeed, it works just fine.

Best regards,
Jozsef
