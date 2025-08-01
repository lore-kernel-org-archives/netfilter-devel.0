Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222E721FF46
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754045589; cv=none; b=JCy9OeuRe4NUTQNaRh3nGky46vwdhKq8x1bK4xAFaQ3vDCslTVRNypyyxlWp1NSc/YMpRFfSG9H7+TV9ILa8C4GNeNkKIw48BwSnk2MH+PrfFfufznD7SqSSaSvXdC1YsCRfLCz4ap+zdIDBxz6jzn8n0iBkmc7JzeZDwmoFLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754045589; c=relaxed/simple;
	bh=pS7n5NTLFWuaIjmlDOFE+/mrMqHAkeZagjMQYx7MIec=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KU2vWD0Wm65TjFgmTAceB/LClquUbhwql/E0E0W5ES1IRDzvRpJVUQEC++l8e3QGjHMEdFQvgbTfxWeKwt0ErJCszLTce9RYYRlkjE+hSvr+3r58F/pZKl/pl/my2ccCEYs5KyyETNTSQl9yNGbEgE8L3rhRGOhK5yV3E94eooI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EBNqGPbe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EBNqGPbe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GmXbF6WKsQzyB9hS54ZO/1J8tBxn1hi3uuoY2/WYIno=; b=EBNqGPbe/2rfgtSHHrtUd8yXMB
	qnxO51Wx0K+Gj7C/INdN9Ca/VTkaQwFkwyFtgI53lgpbWMEm2er1KPS4RY7pgx5P8ZevHQoRfIwFt
	g6rAyES/+Zjy0jQlbxU9aWTha1gogiqEkBK89BE49aAfWqkbtRdbewqx4nnk3hG+h9Y4xNNz6Fxc4
	TEXFLON8ixZltKlYeGk4CZh3OT8WAJh72BPw1ufpVCgdCwKuICMQlXGxAqcNz14QvYcV+O2Y1GtfZ
	DOyJ5LcGIxun+EIAZ1ZqxkHqtoXZ6ya7yzlEMsdLZkomHU9ixJa2xAQf75e5H7UIU0Ebpc8wAd45y
	cK7QEaug==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhnNn-000000002UZ-3OX7
	for netfilter-devel@vger.kernel.org;
	Fri, 01 Aug 2025 12:53:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Minor NAT STATEMENTS section review
Date: Fri,  1 Aug 2025 12:52:58 +0200
Message-ID: <20250801105258.2396-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Synopsis insinuates an IP address argument is mandatory in snat/dnat
statements although specifying ports alone is perfectly fine. Adjust it
accordingly and add a paragraph briefly describing the behaviour.

While at it, update the redirect statement description with more
relevant examples, the current one is wrong: To *only* alter the
destination port, dnat statement must be used, not redirect.

Fixes: 6908a677ba04c ("nft.8: Enhance NAT documentation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/statements.txt | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index f9460dd7fa77f..4aeb0a731fd90 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -412,11 +412,12 @@ NAT STATEMENTS
 ~~~~~~~~~~~~~~
 [verse]
 ____
-*snat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
-*dnat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
+*snat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'TARGET_SPEC' ['FLAGS']
+*dnat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'TARGET_SPEC' ['FLAGS']
 *masquerade* [*to :*'PORT_SPEC'] ['FLAGS']
 *redirect* [*to :*'PORT_SPEC'] ['FLAGS']
 
+'TARGET_SPEC' := 'ADDR_SPEC' | ['ADDR_SPEC'] *:*'PORT_SPEC'
 'ADDR_SPEC' := 'address' | 'address' *-* 'address'
 'PORT_SPEC' := 'port' | 'port' *-* 'port'
 
@@ -426,11 +427,11 @@ ____
 
 The nat statements are only valid from nat chain types. +
 
-The *snat* and *masquerade* statements specify that the source address of the
+The *snat* and *masquerade* statements specify that the source address/port of the
 packet should be modified. While *snat* is only valid in the postrouting and
 input chains, *masquerade* makes sense only in postrouting. The dnat and
 redirect statements are only valid in the prerouting and output chains, they
-specify that the destination address of the packet should be modified. You can
+specify that the destination address/port of the packet should be modified. You can
 use non-base chains which are called from base chains of nat chain type too.
 All future packets in this connection will also be mangled, and rules should
 cease being examined.
@@ -440,8 +441,12 @@ outgoing interface's IP address to translate to. It is particularly useful on
 gateways with dynamic (public) IP addresses.
 
 The *redirect* statement is a special form of dnat which always translates the
-destination address to the local host's one. It comes in handy if one only wants
-to alter the destination port of incoming traffic on different interfaces.
+destination address to the local host's one. It comes in handy to intercept
+traffic passing a router and feeding it to a locally running daemon, e.g. when
+building a transparent proxy or application-layer gateway.
+
+For 'TARGET_SPEC', one may specify addresses, ports, or both. If no address or
+no port is specified, the respective packet header field remains unchanged.
 
 When used in the inet family (available with kernel 5.2), the dnat and snat
 statements require the use of the ip and ip6 keyword in case an address is
-- 
2.49.0

