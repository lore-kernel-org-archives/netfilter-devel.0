Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A732EDD5F
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 20:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762806611; cv=none; b=UNogx7NFnIa/q3k80RIiZSdy5lgZUSYk3Tp24lXBGx5awyszn/rH7A6I55a0zSXLuem6+Q3RWb6EGNZCDMtS77mfobninWxYgkQtrIM0N9enBdwsTdWGBz2L4QHThxBOu3ZzhrKiDyTjB9HfnEM61hXHLcFdDz25hqp1BbhfFWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762806611; c=relaxed/simple;
	bh=BcJgV0/h6dfAqxzHO2Bwq6c8Dzanxl6G8BtDz7Loo58=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=X2awF5l/3VZdZtiI2ko0cbystYNauzjMCqpW43D1nSG9+5nhR5Jf1MMNuLFLFFUq7QQicNWadRjpfdNj78+U8YwaiZYgX7SCWIVoKr6yYqmnrF7YHGoo76RAry2q4wAXxIVD2HcC7j66gBu1p7igl5UNKjKGyRJP3lTX2lL9m0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tgSnn5OM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tgSnn5OM"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B79E46031E
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 21:29:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762806599;
	bh=es6sbVfQIpyPxnnWaAdj//vd5DLT7GhYAUIqZRnnNxA=;
	h=From:To:Subject:Date:From;
	b=tgSnn5OMs5ibcavdHSaUXUUgZ+9tnVZnC5IhWUqxZIHBpS9i0LFRl4jLgda5HZC/T
	 em0Wl4JjjTW/8aswjTgXHwRyT10neHI8F3WFx9f82SJSsO8NGEYsUcEt7S8XveXNuH
	 Agz9mmHdPs2LpcivP7S4oqbdcvxMhV/QTIMb0wRaqRskS3pPHKzZxPPVwXZryMOTY9
	 /ZWVG8u26aRc9hanh7yeqcL5S3wewX2bLmasedO6EFUsRhmk67OzJo61oImpvHmies
	 dMKhZtaMNLBMYhfYuQh8eth+/3n6z5KMy8obqhwo1AgCdLpCXFGESdgxVZToZpHJUt
	 VV0fR+tuztnHQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools,v2 1/3] conntrackd: restrict multicast reception
Date: Mon, 10 Nov 2025 21:29:54 +0100
Message-Id: <20251110202956.22523-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bind the socket to the multicast address specified by {IPv4,IPv6}_address
to discard unicast UDP packets and multicast traffic not coming to the
dedicated interface. There is already code to restrict the interface
but the socket was bound to any address.

Without this patch, multicast sync messages can be received from any
interface if your firewall policy does not restrict the interface used
for sending and receiving them.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1819
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix previous attempt, use multicast address to bind to the already
specified interface.

 src/mcast.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/mcast.c b/src/mcast.c
index 4107d5d94891..912e7623bf15 100644
--- a/src/mcast.c
+++ b/src/mcast.c
@@ -49,23 +49,24 @@ struct mcast_sock *mcast_server_create(struct mcast_conf *conf)
 	switch(conf->ipproto) {
 	case AF_INET:
 		mreq.ipv4.imr_multiaddr.s_addr = conf->in.inet_addr.s_addr;
-		mreq.ipv4.imr_interface.s_addr =conf->ifa.interface_addr.s_addr;
+		mreq.ipv4.imr_interface.s_addr = conf->ifa.interface_addr.s_addr;
 
 	        m->addr.ipv4.sin_family = AF_INET;
 	        m->addr.ipv4.sin_port = htons(conf->port);
-	        m->addr.ipv4.sin_addr.s_addr = htonl(INADDR_ANY);
+	        m->addr.ipv4.sin_addr.s_addr = conf->in.inet_addr.s_addr;
 
-		m->sockaddr_len = sizeof(struct sockaddr_in); 
+		m->sockaddr_len = sizeof(struct sockaddr_in);
 		break;
 
 	case AF_INET6:
 		memcpy(&mreq.ipv6.ipv6mr_multiaddr, &conf->in.inet_addr6,
-		       sizeof(uint32_t) * 4);
+		       sizeof(struct in6_addr));
 		mreq.ipv6.ipv6mr_interface = conf->ifa.interface_index6;
 
 		m->addr.ipv6.sin6_family = AF_INET6;
 		m->addr.ipv6.sin6_port = htons(conf->port);
-		m->addr.ipv6.sin6_addr = in6addr_any;
+		memcpy(&m->addr.ipv6.sin6_addr, &conf->in.inet_addr6,
+		       sizeof(struct in6_addr));
 
 		m->sockaddr_len = sizeof(struct sockaddr_in6);
 		break;
-- 
2.30.2

