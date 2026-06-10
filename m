Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35517426EA9
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104340; cv=none; b=dF8DWFUfe/soXLuETVT1HO6mBvMCZo5uRNQvsoYeBdQXcrEp8tSowqq9aENU9pvKz7t9Vk/AibDnf2eDr6BEkki6sC89dTkUWLqw0jf1U2GjUtlQmNhpODyV8kLjiBYZUj5X5xw0Al3RAaOfDAqUCJ55YCwCzFYatrr4Ysi0Ilw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104340; c=relaxed/simple;
	bh=iqIIj05dDEp0xVebnZDEHeRLAjYV8Dg+cnEkopPQoyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mCuqQEGHFDOrI600y+aHxDhhpFP7LQG2jI3LuWuYh8GiNYb7XnFtjzSOCFNzZOvRNxksWWBYOk/JQSHD+qvnmUXnzmjTdJrmyDINnnZdiOxRQc9oeMH6ZH3z0oHOLjn0rmWogss4fPOc4ZrEUcAYfvVNc0XKcRX0nzLYxsL40nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KoG1N8th; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KoG1N8th"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3E476017E
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 17:12:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781104329;
	bh=7BHHI22OF/vvglKZW30fZV9iEdw957DDXnYHv5LyyUI=;
	h=From:To:Subject:Date:From;
	b=KoG1N8thbvm2FrEsIkctZcjWlHlQ3JED0lUpPlyDaL2/SUitZzwHJ9YYh0WyhsR8P
	 EDRRDA/J3uRPpNB385sh8otO75O8+4sco1XoyJd5N8tqXEytgpmvfUz2M1PgtgzPix
	 NIxXNxab8ldvAXv8HS+PwjwLEtI6FAgyx06/rHe7Y3gmAllf3DQONHIlejCkBwf61s
	 AE2OFdURmQewti4MpATkFMkejyedv4iBn9wff6OB8nCU4dCJscvIOrzS1Eqa+fbm+R
	 d5KxACTr4P0hIy5TLMlbLNqsjrqRzd1AYtjJupL70MhTbiJd5GldgDgQrHBDdOMFto
	 b6bYLevhuDNHA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack,v2] objopt: restrict NFCT_GOPT_IS_{S,D}PAT to supported layer 4 protocols
Date: Wed, 10 Jun 2026 17:12:06 +0200
Message-ID: <20260610151206.191842-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If layer 4 protocol has no ports, then return false. Otherwise, users
like the conntrack utility filtering does not properly work with layer 4
protocol such as ICMP and ICMPv6.

Fixes: b4c3a23c884c ("Introduce the new libnetfilter_conntrack API, features:")
Reported-by: Jan Kasprzak <kas@fi.muni.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - incorrect field, use .protonum, not .l3protonum
    - update Fixes: tag

 src/conntrack/objopt.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index 1581480667e5..7e8d71d15fbe 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -182,8 +182,27 @@ static int getobjopt_is_dnat(const struct nf_conntrack *ct)
 	}
 }
 
+static bool l4proto_has_ports(const struct nf_conntrack *ct)
+{
+	switch (ct->head.orig.protonum) {
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_SCTP:
+	case IPPROTO_TCP:
+	case IPPROTO_DCCP:
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static int getobjopt_is_spat(const struct nf_conntrack *ct)
 {
+	if (!l4proto_has_ports(ct))
+		return 0;
+
 	return ((test_bit(ATTR_STATUS, ct->head.set) ?
 		ct->status & IPS_SRC_NAT_DONE : 1) &&
 		ct->repl.l4dst.tcp.port !=
@@ -192,6 +211,9 @@ static int getobjopt_is_spat(const struct nf_conntrack *ct)
 
 static int getobjopt_is_dpat(const struct nf_conntrack *ct)
 {
+	if (!l4proto_has_ports(ct))
+		return 0;
+
 	return ((test_bit(ATTR_STATUS, ct->head.set) ?
 		ct->status & IPS_DST_NAT_DONE : 1) &&
 		ct->repl.l4src.tcp.port !=
-- 
2.47.3

