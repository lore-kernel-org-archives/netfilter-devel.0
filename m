Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271912;
	b=p8lbMNfzfjRkWTAxWm3W/SOJOsIgRTmut18fQBHrZm3EyPt6SBdgqYkwn5FIhbw0oK4L
	 wzcRQH6QxkEN2C+qL0gljrBV+JlvoDpOoU++qnm2bHS3PeaJU87xQTEpcGbhDpx8DxvtV
	 017yhuMhtsFfE7Qz34DsmTh1idIuC4ackf8R1dyvIVPTTN6GDKPjrdxxGgnhxeSlgZbju
	 Tll1GyaNSOB/trTgEJVphBcA0f9i+UzI1c8nHFwJDCnWodOx/e9yzpTLQfFQy6GdgpDrQ
	 YetSGukknVJNSHv52s1gXuzzvdgkV2N6RCQC460tGSEzEO6+7/TDP48QisLl6oYimhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271912;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=qFLW5MqQBOH4JsVHXQAmh/On3qOJ3YiJtFVuCm1tyXc=;
	b=x87Az2eII/Ja6dj7oD+ZCxXZ8colGpyH2BJDFQigKjKHKYRMsgkB2fB9RvSJKD6qj+Kh
	 SvWhSiZ0OuY9FGhJPbEHIJSpwZ/rQEyR/KqzfOrk3dwX0n4FL7unS4WGK5HTfuUp1AUgf
	 7cMl7WJVRtjOqfGLHGbh7VdpQcAczPsFZPFtnq7otEA65Df5kDCVamz+txaCd/gfGis55
	 +2oLd0G1sFrtgLf7uKI10VF9WsgircrXhlVZ2tttwHcWewuAwYU9rlWYU0pAvwFnBDuMp
	 0dwqxVEc4tN2z31jlnmMvzILkje9zkJHIHxzli+CYxgiKMxn8MPmJPIREJvqYJIy/ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vwnOWEwK;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C9E5D606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 00:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9E5D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vwnOWEwK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271909;
	bh=qFLW5MqQBOH4JsVHXQAmh/On3qOJ3YiJtFVuCm1tyXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vwnOWEwKXd4uNQw9Xh/Jd9SghJeqsVVI4Gqijg50YMQRmu95zj9sMZRaYbqgL498T
	 3aZDW7QAFHg3PgMKMX6us57igU/L8f3RnnT4YgOI2v8rjGC8ffx051UrwdqUNGeu0R
	 nFWgWJiedz7BwcMCJVVPV7g3aaAT6udlnVgw2/zbOh/oZb2r/UJROKAGbjSVeR5+Zw
	 HlhoIZPnvBjL1eOjQQRFpQGnVNktaQ3bMlZREstou8uO7ZZBnD9/VY5LD7W6gPvC9X
	 2rRIl/gWutG7b2jLWFw7RiutuvkP3ZfbJac1uHtMskGJ0P2t3k36OuUk9ePkFbBwYr
	 iCFBmZc8IqEtA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7932A6008B;
	Tue, 10 Nov 2026 01:51:49 +0100 (CET)
Date: Tue, 10 Nov 2026 01:51:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Stosse <florian.stosse@harvester.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl 1/5] nlmsg: fix overlapping copy in
 mnl_nlmsg_batch_reset()
Message-ID: <avJqoxKJEzgefDV-@chamomile>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
 <20261106191841.1645-2-florian.stosse@harvester.fr>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106191841.1645-2-florian.stosse@harvester.fr>

On Fri, Nov 06, 2026 at 08:18:36PM +0100, Florian Stosse wrote:
> When the message that overflowed the batch is longer than the messages
> already batched, the source (b->cur = b->buf + b->buflen) and destination
> (b->buf) of the copy overlap, which is undefined for memcpy(). Moreover,
> nlmsg_len is read again from the old location after the copy has
> overwritten it, so b->buflen and b->cur are set from message payload bytes
> and the next mnl_nlmsg_batch_next() dereferences a wild pointer.
> 
> Read the length before moving the message and use memmove().
> 
> Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

No, this can't be a Co-Author. Maybe this can use Assisted-by:
