Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8092750E3
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 19:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250453; cv=none; b=W8lSUbIMNCbpyU660zulNho7LsQz23Nl+aN+4celyX/4bsH86NN4z+5hiZ9+G8Z+8wnZHoa9v/ZJi+Xk14+Et6J+JT9etw1XULXO6ieAn4g2VIa3dRLvKj3SM9CXFR7Q1sHsbSwSscnWUsvUe1ZMrZEK1Fcn3P27wjtDKrvCm8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250453; c=relaxed/simple;
	bh=HOTiOFe0G/UqXtcej9PhZG2Fq5X93DdFsFquPTuBmiQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=coffLK1WVWov2OjIpsBegKO0CX2ZVZkdUvkCFq2x5Gya6tASIwkxvMAMMF8kF8Q99vol4ImIydInKvQT//mq2IeI9wad03xUVQYbmxHUH9RSnqW+92PDwhAiLxdYxqKQz5/5VMwhg9So/PyeuS3lbtcQw/1oIhSkNtxn+P+5hVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b=G2svQsA1; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b="G2svQsA1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	jubileegroup.co.uk; h=date:from:to:subject:message-id
	:mime-version:content-type; s=uk; bh=htxPRuZM+ZF/Qo9oKkDj73wggu0
	p0AkEi7nKb0FCzsM=; b=G2svQsA1R9HBfUyUd6vC1ktz1xyMgnvRVUUmaSoFS+L
	8PuGU6x7O4zxLsU53OqxDjVZF6dI9S8+hdmSyZhbrNUxmQvsFUw84Cta8R5ZRDbM
	iogsbbelEhJx3ygP+RpIUVmZINWRAgduGVhzt64PNG+7JTRLWvlesP9rElUSslRB
	dqbTvlS0IumQTaONqpyub7y5RzkQ0mKMH9O3S82Ub31XiddC3Xjbhl/cGt0w730h
	R8E2f9851sw528xie505HCJisPAgYp2bqj6f0eU1MzUDr1kSu/cEYZVA7Djs/eVz
	PjDnCL9rMa45OTcODPws3B8/AmYqH1vX9HaS8Biojag==
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 54EJENBf006804
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 20:14:35 +0100
Date: Wed, 14 May 2025 20:14:22 +0100 (BST)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: netfilter-devel@vger.kernel.org
Subject: Packets sent to local interface seemingly not accepted by nfq_set_verdict
 despite ACCEPT call.
Message-ID: <e15788d6-4dce-68fe-2337-d9e83d51a63@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178t

Hi there,

Still just feeling my way around userspace processing with netfilter,
so anything (such as stupidity on my part) is possible.

In the hope of teaching myself something I've hacked the nfqnl_test.c
code to give me statistics about packets outgoing from our mailserver.

One of the processes here which generates outgoing packets is part of
our Nagios/Icinga setup.  It reports how many days remain before the
certificate for our mail server will expire.  The Icinga server calls
a plugin on the mailserver.  The plugin uses openssl to get the mail-
server to connect to itself to query the certificate, and reports the
valid days remaining result to Icinga.  I chose to get the mailserver
to connect to its own LAN interface IP to request this information.
This worked fine for years.  Right up until I installed nfqnl_test.

To begin with it didn't appear to cause any problems.  But three and a
half days later, all the network connections to the box went down.  To
recover, I had to go to a console and kill the nfqnl_test process.

The three and a half day delay turned out to be repeatable, so it took
quite a while to figure out what was going on.  It *looks* like what's
happening is that if nfqnl_test sees a packet with *both* the source
and destination IPv4 addresses equal to that of the Ethernet interface
and it then calls

int result = nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);

the packet is not accepted even though the return value says it was:

May 14 16:44:16 mail6 NFqueue[27783]: Line 254: pktlen=64 data=[450000405283400040060eb2c0a82c19c0a82c19cfe80019b5fe6f1b812db3e5]
May 14 16:44:16 mail6 NFqueue[27783]: Line 290: ACCEPT packet (nfq_set_verdict returned [32])

I don't know what happens to the packet.  I think it gets stuck in the
queue, and eventually the queue fills up and the network hangs:

May  6 04:19:12 mail6 kernel: nfnetlink_queue: nf_queue: full at 1024 entries, dropping packets(s)
May  6 04:19:12 mail6 kernel: nfnetlink_queue: nf_queue: full at 1024 entries, dropping packets(s)
May  6 04:19:12 mail6 kernel: nfnetlink_queue: nf_queue: full at 1024 entries, dropping packets(s)
...
...

If I put in a rule (rule 4 below) which ACCEPTs these packets before
they're sent to userspace, things work as I expect them to work.

Chain OUTPUT (policy ACCEPT 35456608 packets, 9701968770 bytes)
num target   prot opt in out source        destination 
1   NFQUEUE  all  --  *   *  0.0.0.0/0     192.168.241.0/28 NFQUEUE num 11 bypass
2   ACCEPT  !tcp  --  *   *  0.0.0.0/0     0.0.0.0/0
3   ACCEPT   all  --  *   *  127.0.0.0/8   0.0.0.0/0
4   ACCEPT   all  --  *   *  192.168.44.25 192.168.44.25
5   NFQUEUE  tcp  --  *   *  0.0.0.0/0     0.0.0.0/0        NFQUEUE num 11 bypass

So to my questions:

1. Does any of this make sense?

2. How can I instrument the queue?  I'd really like to know how many
packets are in it at any time I choose to look.  I've looked at a few
utilities but nothing seems to answer the question.

3. Any suggestions to take the investigation further?

-- 

73,
Ged.
