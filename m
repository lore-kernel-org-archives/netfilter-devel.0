Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0287817E
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742736853; cv=none; b=qDpbAqrUJ3tgXwO0vrCm4vK+EPLJH8KVCmQfY/jN5WcWFEphV/V048xS//im1buDxGW6DTEcKgv2gWYxn+i4we4LI8j8bfKE44z0xHrZtAzr7IWLihKjWZMpn6BZBNwjd9w4YvMtR24Zi0a/8k76K+Rtc30xlMJ/B5wgjB1IpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742736853; c=relaxed/simple;
	bh=PEZ6cIDQc7gikjlTQJiqm59N9zJR/zeXJvTEe3qRrTE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Irm89E5cPjVK6QPukiCnAlJQmzDveKDcVyf0S6McfkxMICGymvVmOv9qhZpN/LAqH/O7IHCN8apNwqlJ6KQ7Rsw9Z5IzuYRAXZ0V6XWYjKXkNrSqI5dqUl7ZnQNBlDWJGLEEqqpDgD2LIR+OhCPRXVmUEsqX1vVSQw6MbqHd4vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id A828C10038E577; Sun, 23 Mar 2025 14:34:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A64D61100E5004;
	Sun, 23 Mar 2025 14:34:01 +0100 (CET)
Date: Sun, 23 Mar 2025 14:34:01 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Arturo Borrero Gonzalez <arturo@debian.org>
cc: Duncan Roe <duncan_roe@optusnet.com.au>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, Jan Engelhardt <jengelh@inai.de>, 
    netfilter-devel@vger.kernel.org, fw@strlen.de, matthias.gerstner@suse.com, 
    phil@nwl.cc, eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
In-Reply-To: <5bf4cd03-ddb3-4cc4-b07e-e25e475395f8@debian.org>
Message-ID: <s44sopr8-7n17-1979-4qrr-4p5ps9s4s1rn@vanv.qr>
References: <20250228205935.59659-1-jengelh@inai.de> <Z8jDjlJcehMB_Z9F@calendula> <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org> <Z94XLnSQRfMh9THs@slk15.local.net> <22n4s4s4-8155-708o-4091-q6o3nq313641@vanv.qr>
 <5bf4cd03-ddb3-4cc4-b07e-e25e475395f8@debian.org>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Sunday 2025-03-23 11:00, Arturo Borrero Gonzalez wrote:
>> On Saturday 2025-03-22 02:49, Duncan Roe wrote:
>>>>
>>>> I have mixed feelings about having this systemd service file in this
>>>> repository.
>>>> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
>>>> outdated and neglected after a few years?
>> 
>> There are no changes expected to be necessary.
>
> How so? Is the systemd ecosystem not evolving?

I do not have a crystal ball that shows me what will (or will not)
happen in the future, so as far as I can tell, it is perfect as it is.
And I have no indication that unit files are planned to be ditched
anytime soon.
