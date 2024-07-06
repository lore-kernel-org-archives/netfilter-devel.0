Received: from smtp0-kfki.kfki.hu (smtp0-kfki.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C623BE;
	Sat,  6 Jul 2024 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720283111; cv=none; b=KomttPB3MC5U3vYS2Hm9GEggE8OeH5VeL0YAE8/TH9umszwiKIDxEpkrRNDO99SjuVMrv9JZLjufAHtNi1m1csbYX30nE73i+Jl7TsBe39vQWq5ECSH79yLyVq2Kwew796XyU0hQ5+cER0nFhfh2ugOavCuXVRrAjbgFXZOPeqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720283111; c=relaxed/simple;
	bh=yzuqB1ahBjHothxqzHppk9bd4Bz98MkN5vE8AgzGvBc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FjDCwXT5EYBIaYujeykxZBS3UpD0pDqDMyZCy1PHTtTW58Hlbp8vMkpLNEXTZv3IqheAQnK/8hTQd7uXNZz6n3/CiJ+MVVOUP9duhdoigbgySPZZIFkVbv2IzBzaA3oAiG8QL9HYL2twqajh3jRwQ2SiGbNfVDNzt8XpwJIPOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=j+h/bjEw; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="j+h/bjEw"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 876C4674010C;
	Sat,  6 Jul 2024 18:16:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1720282574; x=1722096975; bh=jHJHkf31U+
	8UwKd/kThgQslxJA+f8gODKZm1Ph5NdNg=; b=j+h/bjEwQZvrCxQYJb1ypJH3ls
	x5RguauVNfRT/9mA8xiGuGLXCzjt0EUrRvrSVIgrgkGssPa//Obp/QCSkW85FiH5
	CWf70AE0d9HyLkvycx5Bkn0D5lgXFCwoACV3BHj15ciomIh4Z8lSqdfQzd64HLfv
	t+B0uNh6SFFGGO/qo=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Sat,  6 Jul 2024 18:16:14 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (77-234-64-135.pool.digikabel.hu [77.234.64.135])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 964EB6740107;
	Sat,  6 Jul 2024 18:16:13 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 36AEC408; Sat,  6 Jul 2024 18:16:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 2D2F8406;
	Sat,  6 Jul 2024 18:16:13 +0200 (CEST)
Date: Sat, 6 Jul 2024 18:16:13 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: yyxRoy <yyxroy22@gmail.com>, pablo@netfilter.org, 
    gregkh@linuxfoundation.org, davem@davemloft.net, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org, yyxRoy <979093444@qq.com>
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE
 for in-window RSTs
In-Reply-To: <20240705094333.GB30758@breakpoint.cc>
Message-ID: <1173262c-a471-683f-9e00-abc8192c9ca8@blackhole.kfki.hu>
References: <20240705040013.29860-1-979093444@qq.com> <20240705094333.GB30758@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: dunno 31%

On Fri, 5 Jul 2024, Florian Westphal wrote:

> yyxRoy <yyxroy22@gmail.com> wrote:
> > With previous commit https://github.com/torvalds/linux/commit/be0502a
> > ("netfilter: conntrack: tcp: only close if RST matches exact sequence")
> > to fight against TCP in-window reset attacks, current version of netfilter
> > will keep the connection state in ESTABLISHED, but lower the timeout to
> > that of CLOSE (10 seconds by default) for in-window TCP RSTs, and wait for
> > the peer to send a challenge ack to restore the connection timeout
> > (5 mins in tests).
> > 
> > However, malicious attackers can prevent incurring challenge ACKs by
> > manipulating the TTL value of RSTs. The attacker can probe the TTL value
> > between the NAT device and itself and send in-window RST packets with
> > a TTL value to be decreased to 0 after arriving at the NAT device.
> > This causes the packet to be dropped rather than forwarded to the
> > internal client, thus preventing a challenge ACK from being triggered.
> > As the window of the sequence number is quite large (bigger than 60,000
> > in tests) and the sequence number is 16-bit, the attacker only needs to
> > send nearly 60,000 RST packets with different sequence numbers
> > (i.e., 1, 60001, 120001, and so on) and one of them will definitely
> > fall within in the window.
> > 
> > Therefore we can't simply lower the connection timeout to 10 seconds
> > (rather short) upon receiving in-window RSTs. With this patch, netfilter
> > will lower the connection timeout to that of CLOSE only when it receives
> > RSTs with exact sequence numbers (i.e., old_state != new_state).
> 
> This effectively ignores most RST packets, which will clog up the
> conntrack table (established timeout is 5 days).
> 
> I don't think there is anything sensible that we can do here.
> 
> Also, one can send train with data packet + rst and we will hit
> the immediate close conditional:
> 
>    /* Check if rst is part of train, such as
>     *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
>     *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
>     */
>     if (ct->proto.tcp.last_index == TCP_ACK_SET &&
>         ct->proto.tcp.last_dir == dir &&
>         seq == ct->proto.tcp.last_end)
>             break;
> 
> So even if we'd make this change it doesn't prevent remote induced
> resets.
> 
> Conntrack cannot validate RSTs precisely due to lack of information,
> only the endpoints can do this.

I fully agree with Florian: conntrack plays the role of a middle box and 
cannot absolutely know the right seq/ack numbers of the client/server 
sides. Add NAT on top of that and there are a couple of ways to attack a 
given traffic. I don't see a way by which the checkings/parameters could 
be tightened without blocking real traffic.
 
Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
