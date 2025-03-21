Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454FE1B6CE0
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742553416; cv=none; b=GvUe7MXh3vUeruLsfyzTheUyYOMZGWv4mHaTpD4Ue0i+Q1YIg0vI3wF4rjAmn0IFEGIbUoNLxtqIFz4RKAzw4U91ppFPL0X7l4xU53tdzaUcBUVX/WsrNxb2sr6+kTbg/s9kMlQAe+HNn3dWE8p0veOdFX4Id7AbotOZiw19WNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742553416; c=relaxed/simple;
	bh=UA+i1MhEiX1E1KQs/1ZQdlzQEWhNWsJicfq00ysm50E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JIzDlJUqJIPFGT7VJCtDBSVM7tJjbjxSzDVbx/karPzUf0mU31rFVPX4yhX7W69l9urn3rlpSuoHMMnoNMN+o9SHb3bCbhpQPWo9WRXzMhPW5CD3S+s2xhCCKO60u0xF8BtYdkI/4akI3j7g9+I4HUyGE5L0rMXrqqZJikcjSrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S+wuhF1N; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PFImkNT1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S+wuhF1N";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PFImkNT1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 603EA605A5; Fri, 21 Mar 2025 11:36:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742553412;
	bh=GWq9TM5M+C776jkHOvUZ5AAxGWevU+5htQCpwQB9Qwo=;
	h=From:To:Cc:Subject:Date:From;
	b=S+wuhF1NUYsNMbJPwe23Bg3n5QTe6ci94z1S44BJVk29eZ6F8MNhAV6Y620e7sGoq
	 vKPib0x83ASZVgSw2OOr+wlcZ4xvXCkqJZzgt4lI5wRGwc574JIt8SSNk9qIdqFHmQ
	 ToHPZ5dl7s+3iDiImXwg5ca9b3u7A8CjiRZzFKX4p/gANBfCkQ1+ZKhpv31dQhyjUM
	 ya/phMU0Oj+yrlRiI3Tbzu5WXp+A5Z8CwF9xDd/DmLvTZj+GlGyetl/SRU9yYrO/hv
	 Qv+4KbvcmV06CzGl1cpr26fdQXIiGypFLFBiOFIVRrhOi4pQ1IN0uxOvduPUPQPMzC
	 oFgDqUts4SNmQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7FD76605A5;
	Fri, 21 Mar 2025 11:36:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742553411;
	bh=GWq9TM5M+C776jkHOvUZ5AAxGWevU+5htQCpwQB9Qwo=;
	h=From:To:Cc:Subject:Date:From;
	b=PFImkNT1bNpfj3Xe6hXueQpQQHx08Ph5PJ2e4T8Alh5cY7A64UumMS9Y/vL/7DgT5
	 vmkG0IaA2THk0gN4iMuyna8qKKNm20gn0BrvANS1lrI+xLfiQbKh49GHTBxHRbWQbo
	 msFUjTzANEkKRkYHbvPDOLzysj7TC+6F117aGDtcapoHGfJqbnma6QtLCdEn/tLXch
	 l8cqfbLrMFYjRlyJY73MbaX8CxHPbGPWI/SNXSamAn7bq23P7j/oM0cGQL9l86jgSB
	 B+I4bY9bBDHXzAJDQFOlXK9rFWXDaq1/WBMME8ETZ7JYVl+gGdR5+j4UYXYLT5O7Ye
	 O9oIEsm+GR6uA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next] netfilter: replace select by depends on for IP{6}_NF_IPTABLES_LEGACY
Date: Fri, 21 Mar 2025 11:36:47 +0100
Message-Id: <20250321103647.409501-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Relax dependencies on iptables legacy, replace select by depends on,
this should cause no harm to existing kernel configs and users can still
toggle IP{6}_NF_IPTABLES_LEGACY in any case.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 10 +++++-----
 net/ipv6/netfilter/Kconfig | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ef8009281da5..a215f01d16a3 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -183,7 +183,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -220,10 +220,10 @@ config IP_NF_TARGET_SYNPROXY
 config IP_NF_NAT
 	tristate "iptables NAT support"
 	depends on NF_CONNTRACK
+	depends on IP_NF_IPTABLES_LEGACY
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -264,7 +264,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -299,7 +299,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -313,7 +313,7 @@ config IP_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index e087a8e97ba7..490200b7c209 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -197,7 +197,7 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -234,7 +234,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -244,7 +244,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -258,7 +258,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -269,8 +269,8 @@ config IP6_NF_NAT
 	tristate "ip6tables NAT support"
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	depends on IP6_NF_IPTABLES_LEGACY
 	select NF_NAT
-	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
-- 
2.30.2

