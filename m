Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1844741F7E5
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785235568; cv=none; b=gjbDbgiZ/grsXUME3Gq8zATWVIbOFjKxQUyek/AMtF5FGVxaRvbUpI3ez5t4/Uc8aeVPBuoDvGtiNorvKr1Vk+UMFbi+F1YJ7u09P8Ao+LS4csm3EYSaxL3zC9Puz4mAm699qVcrGEPA3H57guSPydK7g3CGAc7o27CB6BuBAyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785235568; c=relaxed/simple;
	bh=+VBCTWXLfzfsEqIuAmGzE3e/cegT5qBkTGyV4gdsY1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwEvGcwzsl9KDJDfYoUpoHfX9rfi9uaFLxSr9aYVarA/kilIko3QISHlTBVfrpDj6RaXADvuJu1bdt8T11hJeHie5mlaJ/4rk0rby3Kl4ZxfTyhO3JrKSJGxQpEYGhbTdrJk0jgUIHD3icFq2RuzM/q71cDVrfCKdbXiZ8XMErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ESUnR/Sh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ESUnR/Sh"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 55D626017D;
	Tue, 28 Jul 2026 12:46:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785235562;
	bh=ehifvK4tH1BZ0IgilO5O7y9OzN+kCDEnAEwvTgFrWkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESUnR/Shl6C1POb06tEkdEUYiW/6TUguF1SrwIQfcRHkKnAgN9LccH91D4/jHvnzi
	 KgJV9nmSM6y4TOEpy4bayz9/lL7KrlAK1DALId3c6kRnVFIHAr9xqxVW6WCQJ1iPVx
	 da5AkhHIhxvw9LgPPlkGd7GCiaSjI+kYeac+UNvCBXXoe8NK5TtUsWR9P3QdIQqLBc
	 qlTw4hQnYM9BcmElzpBRqYs5jOYbMiyUPBBsxVcG7V6+VoRy1wPWPnZmTAjNzUqzGD
	 uND9i0DvPUXyQf+DIr3x7TR9sMUU1XQP6LSMS523CFS2C5vI4M7jpAOKa2kI7wphpT
	 FCx/Vg/VX1xZg==
Date: Tue, 28 Jul 2026 12:45:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Adam Tulinius <mail@adamtulinius.dk>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables: regression/bug in interval set lookup in 6.18.14,
 still present in 7.1.5
Message-ID: <amiIZyz2qIm2vkfX@chamomile>
References: <589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com>

Hi,

On Tue, Jul 28, 2026 at 11:16:40AM +0200, Adam Tulinius wrote:
> Hi there
> 
> Sorry to post here, I tried creating this bug report on bugzilla, but it seems down :(
> 
> I believe I have found a regression in kernel 6.18.14/6.18.15 w.r.t. interval set lookups, that still affects kernel 7.1.5. Sometimes the lookup will fail during table re-creation, and nftables will behave as if the element was missing, even if it isn't.
> 
> We found this while deploying kernel 6.18.35 to our kubernetes environment, where we started noticing connection refused rates of about 0.05%. Further testing revealed that this happens when we reload our nftables rules (every 20s), and bisecting through kernel versions tells me that 6.18.13 is the last good kernel. I haven't been able to test on 6.18.14, but as far as I understand 6.18.15 was released shortly after, and I know 6.18.15 is affected.
> 
> To reproduce I did this:
> 
> Ran a fast responding web server on port 127.0.0.1:3000 .
> 
> Loaded these rules in a loop (e.g. `while $(sleep 0.1); do sudo nft -f bar.nft ; done`):
> 
> delete table nft_rbtree_repro
> create table nft_rbtree_repro
> 
> table nft_rbtree_repro {
>         set local_ips {
>                 type ipv4_addr
>                 flags interval
>                 elements = {
>                         127.0.0.1,
>                 }
>         }
> 
>         chain egress-fw {
>                 ip daddr @local_ips accept
>                 meta nftrace set 1 mark set 0x00007ff8
>         }
> 
>         chain output {
>                 type filter hook output priority filter; policy accept;
> 
>                 tcp dport 3000 jump egress-fw
>                 tcp dport 3000 meta mark 0x00007ff8 meta nftrace set 1 reject
>         }
> }
> 
> Ran some requests: `echo "GET http://127.0.0.1:3000" | vegeta attack -rate=1000/s -duration=20s -insecure -keepalive=false | vegeta report`.
> 
> On kernel 6.18.13 no connections will fail, on 6.18.15 about 3-10 will fail during the 20 seconds, and kernel 7.1.5 shows the same affected behaviour.
> 
> Please let me know if I can provide more information or testing.

This is sufficient, thanks, I will be preparing a patch asap.
