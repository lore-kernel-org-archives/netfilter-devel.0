Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272911;
	b=iTWvThgxpy/RDUyZf7HVTJKt9LsddqoB4ivG266W+7XLCcCZH2cIKuAEdCfTXQ9H22Jm
	 RIPg9ybUIFda9Q5UjjwAdFmpXjGwVv1OXfICiuOyzhkgjq0hwgo08nPiyMJhdUxGGssVv
	 gfAYgfMMGmiYw/taGv7iCK+YuBd6FgWbv5lflYqqLwQX0h2tRsIdh+T8wPHAMN8Cm3Tsd
	 +cccIAGC2EKcNq7rdyYKN+nZ/A7c0rv7IHeSSHfh0ME4xGAFiMUOI7sq1w2vwxWBN6RlL
	 iDwgkpNeYoXZiIl26RvqcTy3VgmuPjsiHUkNxKZCA0Ch9JkseKavls0E+Z/rzcvGeqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272911;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=x36i1u1Ug+CsRO14sJNtHgtErxuuo8Mk9cH4G1xa/s4=;
	b=zcFEodlSwVQB8hDdlneCEnMKLEAuzS41+l60wHTMWq24yGIZzzIGn2e4ItEeGh/stxb5
	 PLM9w8JhY/2BRZsZqXOecokanmBYuFjxbcOGLn3FbQNGFAybBKIzkeVOETXbKEXCrdsCQ
	 vIhhjZkndUIT1fW9qT2wxxcP/ZE5ezPZ5NNKhNB+9kBCTc/WrG4sc26gR/vqtpRTKD4pY
	 X3A0Er4kgxXvIBnNNTtqdsjko5YbCH2dUHVRW3jVU24bLTtE9D6GXaQIGi9OsCNAnT5bS
	 bsHqBy9TqHNmzb1NbmemPcG6gpl8iVz6N7pKo1xOVZM5isadSyuWQjd6kjakQvjY8YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MdsVN4E4;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EA943606A325;
	Tue, 10 Nov 2026 01:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA943606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MdsVN4E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794272909;
	bh=x36i1u1Ug+CsRO14sJNtHgtErxuuo8Mk9cH4G1xa/s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MdsVN4E4iogadZhZ7ORSwt0JptmXZKE9Us7gR3oCWvLOqMMkL+9bl6sQEoYNBy38p
	 qPE6DOfvXgo+w6Y8hupDpGG8gSet1Lw17pKNtG/V8awdSWb5YBloR0Mk1I8i7qQelq
	 Dfb0HLiH88Fcvr8ZxvyaaV730A+RBly4n09VMRHxc1g82EStp0LrLx02IY4zZAL/wT
	 QG8tyqcwgqdoBhxUMCNyYqBgDTQR35vfv6vGiQh7VsJOsh8hVa4NBIwQ12CqCdh0GJ
	 ftuEAnqjcPyEjhk4496fHKAdGiKaevYwdy56CVDU8WC70XFJ7bz6Poq10UnWeO8hz+
	 /vpxzE/zToGxg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id F28146005B;
	Tue, 10 Nov 2026 02:08:28 +0100 (CET)
Date: Tue, 10 Nov 2026 02:08:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: bridge: refragment packets with a
 vlan tag moved by the bridge
Message-ID: <avJuijtALFuuk7yd@chamomile>
References: <avJo2nhgnulY776l@chamomile>
 <20261110010450.68995-1-laveeshb@laveeshbansal.com>
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
In-Reply-To: <20261110010450.68995-1-laveeshb@laveeshbansal.com>

On Mon, Nov 09, 2026 at 05:04:50PM -0800, Laveesh Bansal wrote:
> On Tue, Nov 10, 2026 at 01:44:10AM +0100, Pablo Neira Ayuso wrote:
> > Do you have a usecase for this?
> 
> I found this through the syzbot report and haven't seen a user report of
> it.

Yes, there is a patch to fix replace the WARN_ON_ONCE() that could be
found. But does it make sense what syzbot is trying in real life?

> This is the follow-up for nf-next we discussed in
> https://lore.kernel.org/r/atck-NoWvemxIsF6@chamomile.

Yes, I remember, thanks for the link.
