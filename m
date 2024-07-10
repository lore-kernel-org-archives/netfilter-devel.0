Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762D192B8F;
	Wed, 10 Jul 2024 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720619373; cv=none; b=m1jN3gvGSn4l9JtjrqxFBK6iqhd3r9MZVQuXJGopj+vT31JLMeZbpXabWcWZPJk1sia2MtdJlKIdFXNcrrvl5zcss1BX7ShmHe7inefdvy5keEF/MZw8ezSvFOVg+5Tb8lPcHW9rq15gQee1aRHOXj9RRykiAvzZ/lb+qnKk4Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720619373; c=relaxed/simple;
	bh=pArGaEjrBNzLagzcUQy7sb6LrTj46+cz3oLQRUFO5fc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=H9GjNe2ew/a0eJYC0dh3qip94ACfk/n19u8PqpTY1lgDvfj1kg0ZbORbrk7IDQAeOL73fs9SmAguvC54mFNcqr77uKfzBlBwTCM7dzKqn9s7ro4pQBfg6sDDBvond2+0t2WfWsK9szehwqi43PV5eGEYQQXVHXy7vbhLn7YYrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Ek1pH4Tx; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Ek1pH4Tx"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 1FAF8CC02C0;
	Wed, 10 Jul 2024 15:49:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1720619365; x=1722433766; bh=z2NQrFM4Pv
	+TQSD3+eNSvbpMh/+SSq4xiXJqjXQ/tu4=; b=Ek1pH4TxHJwpAN0hMu9hMVhv9Z
	l5CXszvln762kNrB8+xgru6P4K6jjK5bvUV1+cKAB0kSiT78eavk2Bnmy0DJTP13
	/r4jqbQDxeNZu7TU3vZwsEibdDXGzV9UuxyQMVFc58JgBedvxgtvWvaknLXKj7ls
	baHu41t64KpwaRsbQ=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed, 10 Jul 2024 15:49:25 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 8F693CC02B4;
	Wed, 10 Jul 2024 15:49:24 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 4C35134316B; Wed, 10 Jul 2024 15:49:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 4B7B534316A;
	Wed, 10 Jul 2024 15:49:24 +0200 (CEST)
Date: Wed, 10 Jul 2024 15:49:24 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: yyxRoy <yyxroy22@gmail.com>
cc: Florian Westphal <fw@strlen.de>, 979093444@qq.com, coreteam@netfilter.org, 
    David Miller <davem@davemloft.net>, edumazet@google.com, 
    gregkh@linuxfoundation.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
    netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
    Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE
 for in-window RSTs
In-Reply-To: <20240710094554.483075-1-979093444@qq.com>
Message-ID: <7dd0aeaf-20cc-877c-e2d9-e0b40d40567d@blackhole.kfki.hu>
References: <20240708141206.GA5340@breakpoint.cc> <20240710094554.483075-1-979093444@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Wed, 10 Jul 2024, yyxRoy wrote:

> On Mon, 8 Jul 2024 at 22:12, Florian Westphal <fw@strlen.de> wrote:
>> We can track TTL/NH.
>> We can track TCP timestamps.
>>
>> But how would we use such extra information?
>> E.g. what I we observe:
>>
>> ACK, TTL 32
>> ACK, TTL 31
>> ACK, TTL 30
>> ACK, TTL 29
>>
>> ... will we just refuse to update TTL?
>> If we reduce it, any attacker can shrink it to needed low value
>> to prevent later RST from reaching end host.
>>
>> If we don't, connection could get stuck on legit route change?
>> What about malicious entities injecting FIN/SYN packets rather than RST?
>>
>> If we have last ts.echo from remote side, we can make it harder, but
>> what do if RST doesn't carry timestamp?
>>
>> Could be perfectly legal when machine lost state, e.g. power-cycled.
>> So we can't ignore such RSTs.
>
> I fully agree with your considerations. There are indeed some challenges 
> with the proposed methods of enhancing checks on RSTs of in-window 
> sequence numbers, TTL, and timestamps.

Your original suggestion was "Verify the sequence numbers of TCP packets 
strictly and do not change the timeout of the NAT mapping for an in-window 
RST packet." Please note, you should demonstrate that such a mitigation

- does not prevent (from conntrack point of view) currently
   handled/properly closed traffic to be handled with the mitigation as
   well
- the mitigation actually does not pose an easier exhaustion of the
   conntrack table, i.e. creating an easier DoS vulnerability against it.

> However, we now have known that conntrack may be vulnerable to attacks 
> and illegal state transitions when it receives in-window RSTs with 
> incorrect TTL or data packets + RSTs. Is it possible to find better 
> methods to mitigate these issues, as they may pose threats to Netfilter 
> users?

The attack requires exhaustive port scanning. That can be prevented with 
proper firewall rules.

> Note: We have also tested other connection tracking frameworks (such as 
> FreeBSD/OpenBSD PF). Also playing the roles as middleboxes, they only 
> change the state of the connection when they receive an RST with the 
> currently known precise sequence number, thus avoiding these attacks. 
> Could Netfilter adopt similar measures or else to further mitigate these 
> issues?

I find it really strange that those frameworks would match only the exact 
SEQ of the RST packets.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
