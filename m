From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [iptables PATCH 1/2] Add iptables support for the TPROXY
 target
Date: Wed, 15 Oct 2008 04:13:56 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810150412020.10924@fbirervta.pbzchgretzou.qr>
References: <200810151010.15083@nessa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYJOIOA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:14:00 -0400
In-Reply-To: <200810151010.15083@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-15 04:10, KOVACS Krisztian wrote:

>Add user-space code for the TPROXY target.
>
>+++ b/include/linux/netfilter/xt_TPROXY.h
>@@ -0,0 +1,14 @@
>+#ifndef _XT_TPROXY_H_target
>+#define _XT_TPROXY_H_target
>+
>+/* TPROXY target is capable of marking the packet to perform
>+ * redirection. We can get rid of that whenever we get support for
>+ * mutliple targets in the same rule. */
>+struct xt_tproxy_target_info {
>+	u_int32_t mark_mask;
>+	u_int32_t mark_value;
>+	__be32 laddr;
>+	__be16 lport;
>+};

A bit of forward planning would not have been bad; like using a
"union nf_inet_addr laddr" for a future IPv6 expansion, since those
pesky structs (xt_mymodule) tend be quite fixed and when they change,
they require a new revision.
