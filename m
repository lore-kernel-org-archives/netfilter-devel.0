From: Thomas Graf <tgraf@infradead.org>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 17:22:23 -0500
Message-ID: <20110114222223.GA22508@canuck.infradead.org>
References: <20110114152024.GA9654@canuck.infradead.org>
 <4D306FBB.8020705@trash.net>
 <20110114161937.GA22101@canuck.infradead.org>
 <20110114165937.GA5759@canuck.infradead.org>
 <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:36673 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1ANWW0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:22:26 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 06:29:22PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2011-01-14 17:59, Thomas Graf wrote:
> >
> >This patch adds a new netfilter target which creates audit records
> >for packets traversing a certain chain.
> >+#ifndef _XT_AUDIT_TARGET_H
> >+#define _XT_AUDIT_TARGET_H
> >+
> >+#include <linux/types.h>
> >+
> >+enum {
> >+	XT_AUDIT_TYPE_ACCEPT = 0,
> >+	XT_AUDIT_TYPE_DROP,
> >+	XT_AUDIT_TYPE_REJECT,
> >+	__XT_AUDIT_TYPE_MAX,
> >+};
> >+
> >+#define XT_AUDIT_TYPE_MAX (__XT_AUDIT_TYPE_MAX - 1)
> 
> Hm, why not just add to the enum:

The above is used in various places around the kernel and there
is nothing wrong with it.

> >+static int audit_tg_check(const struct xt_tgchk_param *par)
> >+{
> >+	const struct xt_AUDIT_info *info = par->targinfo;
> >+
> >+	if (info->type > XT_AUDIT_TYPE_MAX) {
> >+		pr_info("Audit type out of range (valid range: 0..%u)\n",
> >+			XT_AUDIT_TYPE_MAX);
> >+		return -ERANGE;
> >+	}
> >+
> >+	return 0;
> >+}
> 
> Math nitpick: EDOM, not ERANGE.

ERANGE is the common error code to use in this situation.

> Do we need __XT_AUDIT_TYPE_MAX? It is unused; that is to say,
> would not this suffice:
> 
> enum {
> 	...,
> 	XT_AUDIT_TYPE_WHATEVER,
> -	__XT_AUDIT_TYPE_MAX,
> -	XT_AUDIT_TYPE_MAX = __XT_AUDIT_TYPE_MAX - 1,
> +	XT_AUDIT_TYPE_MAX = XT_AUDIT_TYPE_WHATEVER,
> };

This requires to modify XT_AUDIT_TYPE_MAX whenever the list is
extended which is a pain to maintain. Let's leave it how it is,
it's a well known coding practice and known to work just fine.
