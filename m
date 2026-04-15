Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3540313E07
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776251563; cv=none; b=k1mGv3zGBBP4z94/Dn8b1ELfboN4+SxRaR+lSsVEYXz3e6wcVEouWe/yeFxxKK3F5i49E5CEYyoRsjZIM/YYWSRtaSmcvtKRuRutd99q2DGIWXQOrur5G2ZykbQ0AT01C1ZK9rOBEuuLG/VfMPi0ic5b5RtqeCpktdSLjWoYt8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776251563; c=relaxed/simple;
	bh=g4+wCFzJW8XljBXBNOdqZdZ+S4CeDzwu2XKCfDPj9gA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=e66MwV5tr/jikXfw6sH03mHPwcETlPTBvRDhx+wH933qo4VjQIQ4tcdFkY8JyKO5Lu3t6c2EPMNUp7HXVByJwsf7Ugj0PRrFj0TWlz8TsN8OCzrjChFCyGtmrSyn4BbSdfMYsDB5mWY5o3GmwmqFoj2cQNf7UTSpSvY2Q3w+0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rhnXiM/k; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rhnXiM/k"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C7E9460177
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 13:12:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776251559;
	bh=I0TL6uLlxdsREaQziq2QTqWSFrAwe2oi30N6RRY0wDM=;
	h=From:To:Subject:Date:From;
	b=rhnXiM/kKqJlyl9vWWoGqxDJkuc28IctefUdDWJMcQjPVKOtFQc5NsSXSd4WZzV8Z
	 wI7mgAKtBBXWFE9iuCMOcM3pfsxlf96P74HzNYp/TbozIRoZlf5CAUcm0y0OpSAzLu
	 U1fpd5nisAWqdrOXLw3gIYEcTL8kjfYpVGZzIYW2rQmAq1euR8tWk7U/HzBMXj5IIP
	 7gBonm827+JJBdSO44KaPQywkpOOxn1gAMjGLqO7r3fui9GiHWSTHczxSJFMlBZ7/o
	 RpM49e5ovOz6aadAmPsLiLEpsJsZMI1vhNeho8TngrxaDmBXfTAas7EneckMRFU6hG
	 la5L6chpsCfLg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: allow nfnetlink built-in only
Date: Wed, 15 Apr 2026 13:12:36 +0200
Message-ID: <20260415111236.57925-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Netfilter has its own netlink multiplexer, initially only a few
subsystem were using it, most notably conntrack, queue and log,
later in time nf_tables. These days it is the control plane of
preference.

Just remove modular support for this, allow it built-in only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig  | 2 +-
 net/netfilter/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..d3f57392e698 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,7 +22,7 @@ config NETFILTER_SKIP_EGRESS
 	def_bool NETFILTER_EGRESS && (NET_CLS_ACT || IFB)
 
 config NETFILTER_NETLINK
-	tristate
+	bool
 
 config NETFILTER_FAMILY_BRIDGE
 	bool
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6bfc250e474f..7b89157b6bce 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
+netfilter-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 
 nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o \
 		   nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o \
@@ -23,7 +24,6 @@ endif
 obj-$(CONFIG_NETFILTER) = netfilter.o
 obj-$(CONFIG_NETFILTER_BPF_LINK) += nf_bpf_link.o
 
-obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
-- 
2.47.3

