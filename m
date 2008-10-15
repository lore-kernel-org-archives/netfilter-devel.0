From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [iptables PATCH 1/2] Add iptables support for the TPROXY target
Date: Wed, 15 Oct 2008 10:22:06 +0200
Message-ID: <200810151022.06435@nessa>
References: <200810151010.15083@nessa>
 <alpine.LNX.1.10.0810150412020.10924@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:42986 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYJOIWJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:22:09 -0400
Received: from nessa.odu ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8R00F89TVP7A30@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Wed, 15 Oct 2008 10:21:25 +0200 (CEST)
In-reply-to: <alpine.LNX.1.10.0810150412020.10924@fbirervta.pbzchgretzou.qr>
Content-disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wednesday 15 October 2008, Jan Engelhardt wrote:
> On Wednesday 2008-10-15 04:10, KOVACS Krisztian wrote:
> >Add user-space code for the TPROXY target.
> >
> >+++ b/include/linux/netfilter/xt_TPROXY.h
> >@@ -0,0 +1,14 @@
> >+#ifndef _XT_TPROXY_H_target
> >+#define _XT_TPROXY_H_target
> >+
> >+/* TPROXY target is capable of marking the packet to perform
> >+ * redirection. We can get rid of that whenever we get support for
> >+ * mutliple targets in the same rule. */
> >+struct xt_tproxy_target_info {
> >+	u_int32_t mark_mask;
> >+	u_int32_t mark_value;
> >+	__be32 laddr;
> >+	__be16 lport;
> >+};
>
> A bit of forward planning would not have been bad; like using a
> "union nf_inet_addr laddr" for a future IPv6 expansion, since those
> pesky structs (xt_mymodule) tend be quite fixed and when they change,
> they require a new revision.

You're right. However I don't consider adding a new revision much of a 
problem when adding IPv6 support -- that is a major new feature anyway.

But I think we're still on time: feel free to submit a patch to DaveM 
which changes the kernel side as well as a patch to the iptables modules.

Thanks a lot!

-- 
KOVACS Krisztian
