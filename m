Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426C2DFA29;
	Tue, 15 Apr 2025 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731703; cv=none; b=Km4lZsdag5dDPnrQ0ljJdGxhlrwOCz36hDVmDQIU/Z2UvRtM859cIiOBh8y+Ibh0EP7KGVjMYcMtDmuZfUM/DBZMYY+q3qyHa2pb2uomt/TSVyI7lpl2h19mrQDA6DLezSI/6kP2+6tOoGnvoiVn9Gil6ezTh2R4IwEvM9rA7XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731703; c=relaxed/simple;
	bh=CIg8QmdP3BeTv3ceN/dvUqOI2TuC4nhVjPF76pREnLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDevZGKD8LBfOslgB1sokBm6otVuIUrXdYYQ2eXFIfSic5ckwPa3X+xnDsOdNqXQi7hlPGC9fEIHG6g3Rq7qRRl9d3tDMkzVUjKWvq/50yAYF2g0vpQtep1laKRgzHKxklytE7eVasjqkfKqFDU+2MbdHlY9XzAb0fdS2QLyByg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=inmuVdwX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RkDHEnNC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="inmuVdwX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RkDHEnNC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5AD79608C8; Tue, 15 Apr 2025 17:41:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731699;
	bh=CIg8QmdP3BeTv3ceN/dvUqOI2TuC4nhVjPF76pREnLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=inmuVdwXuYLpYwFRvYYzPoAj4KZeZbXpCpyQaeS1OX3yS931k4d9TVDW+sZ0i4GWT
	 CSYhj0qJ50QSBBxJPjHhTy22zQZAceAXk2/FCWe8JxftLoe4exHxZpchc4tGe70w2o
	 FOSdmAYgpi+luYfDB+ityxmUpu8YJdt6obz8KrfL1qS/Ws2A02SbSuUBO7Tmpcqx26
	 lJP4ir1Hh3atYA9YLLcDKUDaNhaks5VPCP2yV2Vwvj/LchKf3OcKmIXrSdT0/rhD0r
	 Me2MsgzAx/g8XWtwJEC8U2Tm6rObZZzwaqVZf7tjpalt7pmnJkrzkTjCOa2QP/Nzaa
	 sMrVzGP3czu5A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 740DC60883;
	Tue, 15 Apr 2025 17:41:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731697;
	bh=CIg8QmdP3BeTv3ceN/dvUqOI2TuC4nhVjPF76pREnLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RkDHEnNC4qIVB0kkMZ0j9le+WBomjWS0Iv/Qz2FKbjVVt1zva6O9+kpDM84wBM9+U
	 ARtUINfma9QCs4JqjtnrbSI5p80cwrYKSe33mbzcVxXhFclj4VjHQQNXodba+dU3qX
	 WcFn+qiuar26WLBqD34bSJOAoDN53AMxY7B/Os9mleVicJz++Hf49fsg7TORTE/F87
	 RGGSPYsgdjGUP/oyL/CANtfdi/MjN6uCzP9XYQRfJaXk7bfrgl9fCBAQUeIwr6wjO8
	 e/ArCxop0t3SMNz3jX7Ih1caX9YoS+SsKQEGFxQdV1wWTp3ZYrt1lRqUBQ7CJmjLt4
	 /mGB8WtyIwDjQ==
Date: Tue, 15 Apr 2025 17:41:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chen Linxuan <chenlinxuan@uniontech.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] docs: tproxy: fix formatting for nft code
 block
Message-ID: <Z_5-LkQaP9gs7O1b@calendula>
References: <E25F951CDC9F22B2+20250408073550.3319892-2-chenlinxuan@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E25F951CDC9F22B2+20250408073550.3319892-2-chenlinxuan@uniontech.com>

On Tue, Apr 08, 2025 at 03:35:50PM +0800, Chen Linxuan wrote:
> The nft command snippet for redirecting traffic isn't formatted
> in a literal code block like the rest of snippets.
> Fix the formatting inconsistency.

Applied to nf-next, thanks
