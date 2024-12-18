Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A614884C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2024 15:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536176; cv=none; b=t5RB7H0Min9afJ5KJIqjzSQWx+hAZX8vJDj5RNHVlcdrKSgPItUYfcXQHkkXNs1a1Pt91khoUMPrdFEIyEXpnWJDkTznxVd1/wyrsbZggzON+3v1/zZkNOnsGyRBrx9STHpjfMxf4v+85Q/I4YardC1UnlqljDPe/5xroVCq+XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536176; c=relaxed/simple;
	bh=H0mRmCQzKKFAWzsEsgPam4vVdkORLHx3TLYGQYcl42s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=lAiQa7e57xFBTx0OOI994El/x30xpu+7nMMAXjpaPzqL4NOTczMlaaBFYf2d84kZ1WS6VONabNFG46z4BKhtCq3v+6mDCYig+WWzCu4Dgk2qLUxdNp+wmODXPmnIb2i0bssincF7r0pxnIArpuCEEzUqhub0dGnstjr23/NieMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b=Ia3cDzbT; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b="Ia3cDzbT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	jubileegroup.co.uk; h=date:from:to:subject:message-id
	:mime-version:content-type; s=uk; bh=Eq+TDOzFYl82rWY5Ed/z6Wb8fr/
	rWsrOfa8KNWmFjfA=; b=Ia3cDzbTqA9CQN2A551KniZ+iOD52lLVMepX4h6bHq9
	UNjXIokvLhk2vyiS4B40CeCssO94bjaAKsxpEsiZP3PoAv7s46N+hb29wBiDqlGX
	/G2wv8wqGbw+fio8R1VCbx7DVma4oeKxf9ojtyJevR2hdct3ZCYdp3FGM18hLmeq
	0NJ+Emc9HMig5ePGiTi7BzC7RhJ4LkiWLHBQWVoRgvStnb570lK1reQURIyV9LTC
	CZ5Ke70KVgLGbNyNOuiQdZyhfKeRi6+E6/N+KKCOdKUdJuY1iI0nXyXY48lW1aOB
	Z74t6zxz4VBLQn5B8HZg1wiiH4B7Q5THpwylz9O8R5Q==
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 4BIFK1w1025107
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2024 15:20:04 GMT
Date: Wed, 18 Dec 2024 15:20:01 +0000 (GMT)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: netfilter-devel@vger.kernel.org
Subject: Documentation oddity.
Message-ID: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178q

Hi there,

In the 'man' pages for 'ipset' on my systems, and at

https://ipset.netfilter.org/ipset.man.html

one sees

[quote]
netmask cidr
     When the optional netmask parameter specified, network addresses
     will be stored in the set instead of IP host addresses. The cidr
     prefix value must be between 1-32. [...]
[/quote]

I've just used a value of 64 for an IPv6 set.  It seems to work. :)

Have I missed something, or is the documentation in need of an update?

-- 

73,
Ged.
