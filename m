Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3090C225762
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770942; cv=none; b=bXJ0be1jpi7n3Kbj1jFtUDY8IHAOknGSRrcg2YAY5s0tI43BNx+e4TGr607rnjfwLpTFnmXvO253+odg6vtXknp3Thy7qse6ZTFCPxgACxAJ4ROXSOVR4lm753tWoUpjV2hHTkGpsPTFapME/UUaolgom0M7y1O/B3F/MdmjTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770942; c=relaxed/simple;
	bh=UIwnnQ107kYhCSqMK9Br6iQmhYXxLSlYNkRdzkGeNLc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Qf7mGJ+WowTY+2lwJP1LRFBf/xEvmy2/J80E+ERYBt/E12uPOks1bQCS3YhsPYnB5RXE9mQlXxQjuUInNl8I11J8HksSrykHGJZyedVJxIt02/9+xKm0Y04iCOpwhsdV06bhQjp1LMl/wga8erKf7pUn0XErRh1CA1QXfWZViaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IHbBOVTL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IHbBOVTL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A9A6D600B9
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 11:35:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762770935;
	bh=rMp1fIR5z2E+bNCEqNsSsBcGA26Cd/uwcKzb3QjthJg=;
	h=From:To:Subject:Date:From;
	b=IHbBOVTLabmmar4dH/kRBf7iW4aqWBZ3HsU7iIYfJCiIhU1CpKhxvf0UR0EEVmlcG
	 Az3BQtpnlu+dARdeBFo/I8CeQBTTvIvRXfcsH3D3KfjCveTWWSB8nG/Fe/eB5n1371
	 YoD23xkC8xUhxpg9vT4mqP/aRcV388zUQX4Towghf6hyu21AkEfQpkdgXCAYDF34Ag
	 47I/ddQulW8r5Lrh34aJ2QB4bmDWco7Bd1fe4yNzJQ+QWHCHvyKZjTnQlc974zC2Ic
	 fGdJnyDXSbj6FDLtDKy81X3VYRU8FirxWlURFD0stlQHSV7vQ7ECq7M0mlTnmGX8+z
	 o1ViZXXPXCfdw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 1/2] conntrackd: restrict multicast reception
Date: Mon, 10 Nov 2025 11:35:30 +0100
Message-Id: <20251110103531.2158-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- For IPv4, bind multicast socket to the address specified by
  IPv4_interface to restrict the interface.

- For IPv6, bind the multicast socket to the IPv6 multicast address.
  Although interface_index6 already restricts the interface, binding to
  inaddr_any still allows for IPv4 sync messages to be received.

Without this patch, multicast sync messages can be received from any
address if your firewall policy does not restrict the interface used for
sending and receiving them.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1819
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mcast.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/mcast.c b/src/mcast.c
index 4107d5d94891..88300da32673 100644
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
+	        m->addr.ipv4.sin_addr.s_addr = conf->ifa.interface_addr.s_addr;
 
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

