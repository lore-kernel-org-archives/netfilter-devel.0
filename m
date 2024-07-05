Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F8146A8D;
	Fri,  5 Jul 2024 09:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720172626; cv=none; b=QKMmYpzDwJsaLVl1uf2SAi8D9GZEw1BfOErtElPbwx/t9ixdunmVVXl7xAsIoXCUq/EYhNOLpNiYL5/M4bHEr2YO1ScHGwruqqdKz/aAZQ1X/xkoHgLH0pe+/nlXEsDMV3bQCYDZwRd5NuIJCHZ6uBWz3hed6dQpn2tZsKUWKOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720172626; c=relaxed/simple;
	bh=En2qOjPD1WZPJVdH9mcRoOPC7p3aqmF+PJMGB9P3eV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjQTt1oYUWNECAgqqb1clwMf6ft4Nrm7FlzIH1j5ryKvMQnoSzK6CqaJTDic8nTQGRkVZZHWH21ogfiWOEtKUeZnFITGNesJ6T0OT2/H4Ga0zj9vuCAlftfAdj6V44HNN7jBaJrNUeMkd1lnkfMVxOE0wBBxYjx2zyBk9ApJQT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sPfTZ-0008HZ-0e; Fri, 05 Jul 2024 11:43:33 +0200
Date: Fri, 5 Jul 2024 11:43:33 +0200
From: Florian Westphal <fw@strlen.de>
To: yyxRoy <yyxroy22@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, gregkh@linuxfoundation.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, yyxRoy <979093444@qq.com>
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE
 for in-window RSTs
Message-ID: <20240705094333.GB30758@breakpoint.cc>
References: <20240705040013.29860-1-979093444@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705040013.29860-1-979093444@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

yyxRoy <yyxroy22@gmail.com> wrote:
> With previous commit https://github.com/torvalds/linux/commit/be0502a
> ("netfilter: conntrack: tcp: only close if RST matches exact sequence")
> to fight against TCP in-window reset attacks, current version of netfilter
> will keep the connection state in ESTABLISHED, but lower the timeout to
> that of CLOSE (10 seconds by default) for in-window TCP RSTs, and wait for
> the peer to send a challenge ack to restore the connection timeout
> (5 mins in tests).
> 
> However, malicious attackers can prevent incurring challenge ACKs by
> manipulating the TTL value of RSTs. The attacker can probe the TTL value
> between the NAT device and itself and send in-window RST packets with
> a TTL value to be decreased to 0 after arriving at the NAT device.
> This causes the packet to be dropped rather than forwarded to the
> internal client, thus preventing a challenge ACK from being triggered.
> As the window of the sequence number is quite large (bigger than 60,000
> in tests) and the sequence number is 16-bit, the attacker only needs to
> send nearly 60,000 RST packets with different sequence numbers
> (i.e., 1, 60001, 120001, and so on) and one of them will definitely
> fall within in the window.
> 
> Therefore we can't simply lower the connection timeout to 10 seconds
> (rather short) upon receiving in-window RSTs. With this patch, netfilter
> will lower the connection timeout to that of CLOSE only when it receives
> RSTs with exact sequence numbers (i.e., old_state != new_state).

This effectively ignores most RST packets, which will clog up the
conntrack table (established timeout is 5 days).

I don't think there is anything sensible that we can do here.

Also, one can send train with data packet + rst and we will hit
the immediate close conditional:

   /* Check if rst is part of train, such as
    *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
    *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
    */
    if (ct->proto.tcp.last_index == TCP_ACK_SET &&
        ct->proto.tcp.last_dir == dir &&
        seq == ct->proto.tcp.last_end)
            break;

So even if we'd make this change it doesn't prevent remote induced
resets.

Conntrack cannot validate RSTs precisely due to lack of information,
only the endpoints can do this.
