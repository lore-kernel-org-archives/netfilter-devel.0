Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536988;
	b=iUuOmdOlT4ICo+bIo2A5uLIswLSpY6PDgrbo4QOgAHOJwN6tCmwhzJqf6ar2u0zmF0YP
	 f0FEMI8g0riipAiVvXQXIdm2ibUWqGy8IA/vy6Z65WQMBXqQAWZrJC6DM5DdQDDR5zkZg
	 ZxvQTG9Nb8B8NqaEBFaXjhs6hWZFq0XJhMxAgz6+ZiOdPDKrGIQQVcHp29QTYFFth33YS
	 MNeLu5mOO51EBQavW04OGilRDglZ7AVqg06GExXpv6fwrkIQRsdXAWMj8SQCAYHZWPGy/
	 TVS+q6i1pVJ2L8ejcBXNOL0FTns+GbGh5lcw6F9+lFfLJob4XDbfhdi9FgwU9T1yPjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536988;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=PXr+64rR4Tv2EoA7vxV/r7Lq/rz9TNXaSd8Nf7cZy44=;
	b=AQPzgBxfV2hV1YtdNxjHv5udklVPA6qWQqBmgE6uzeOqXhcCHbmRjBD7SHYLvyCQ+wnn
	 tb0Kq25R7dhTrL8nAq6BW93GvyyBfPketkDT8RmHtqIJzPvW61gxcHbqb6pA0KCsYhRrn
	 soocY8uVuxkVWOozmoJIBr4co22h/34onYBOcUsz3vxtZNcjmQjD/esBThPdlBBL2+Vuv
	 SbFIVpse15cZv7ww5iXP/F03lE7Na6LbCr6A2tkNEDz8CPgckT5vLNMuHiwzNj+o0XkMU
	 hgl0A61JKUUJxnLH7ru8aTsbhF5QGw0n24krcNhBx+nYsgGbWbjFAX0TQsvFdYSCo7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AHqSW6mN;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 29DF0606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 22:56:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29DF0606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AHqSW6mN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792536985;
	bh=PXr+64rR4Tv2EoA7vxV/r7Lq/rz9TNXaSd8Nf7cZy44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AHqSW6mN3FLVL8AH0Ogv2p4mDHzkI88seFpHoRDHmhzw/fNA0tnIDa/IAKI1qNjf2
	 voiQAY1XBxdQWjRqIA66cyra2/VY8jb9KaqRmEpN3l4s5iMHMZZhmWnYCn2xTJWC4p
	 lIJdpd4jyFEaUyknlkI5lpM3GEAO1YYdltCPmd8SogdX9cpujUGdq0DY+VkrYSkXS+
	 nkY6mudY9FwcTKMnriCk2slElrz3uAb4NWYPWFC+ka9i+QCfnfG6Gkx0asx/MQXamX
	 rlHzfWdZ6NH96mTU+JYXNhNibhecNQbyCU1o6vj1kuN5Zty0kL+uk0/pw9Rk6wWrwa
	 9hMUVKefUmgow==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3086560050;
	Wed, 21 Oct 2026 00:56:25 +0200 (CEST)
Date: Wed, 21 Oct 2026 00:56:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <atfxlqHrKr3n3Qy3@chamomile>
References: <20260928185803.335307-1-aojea@google.com>
 <20261016133304.1755951-1-aojea@google.com>
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
In-Reply-To: <20261016133304.1755951-1-aojea@google.com>

Hi Antonio,

On Fri, Oct 16, 2026 at 01:33:04PM +0000, Antonio Ojea wrote:
> Hi Pablo,
> 
> Gentle ping. v2 addresses Florian's feedback on v1: rebased on nf-next
> and the nf_queue_nf_hook_drop() call in nft_ct.c converted as well.
> 
> I rebased and retested the series today on nf-next main (a5e7d8e446af):
> it applies cleanly, builds, and nft_queue.sh passes, including the new
> test_hook_drop_scope.
> 
> Is there a chance to pick it up for nf-next before the 7.4 merge window,
> or do you prefer that I resend once 7.4-rc1 is out?

This is now in the net-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5d1b850ea3f6e6ba2090ebc437e9bbec1d7e5ae4

according to:

https://lore.kernel.org/netfilter-devel/atXgURtsFB4UFXES@chamomile/T/#u

this needs a follow up. Florian, please, confirm this.

Thanks.
