From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 2/3] netfilter: add APPROVE target
Date: Fri, 21 Jan 2011 00:22:36 +0100
Message-ID: <201101210022.36851.richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <1295563629-14996-3-git-send-email-richard@nod.at> <alpine.LNX.2.01.1101210012330.29106@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:58731 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab1ATXWk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:22:40 -0500
In-Reply-To: <alpine.LNX.2.01.1101210012330.29106@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Freitag 21 Januar 2011, 00:17:48 schrieb Jan Engelhardt:
> On Thursday 2011-01-20 23:47, Richard Weinberger wrote:
> >This new target is related to the ruleid extension.
> >It accepts a packet and stores it's rule id into
> >the connection tracking entry.
> >
> >Signed-off-by: Richard Weinberger <richard@nod.at>
> >---
> >
> > include/linux/netfilter/xt_APPROVE.h |    8 +++
> > net/netfilter/Kconfig                |   12 +++++
> > net/netfilter/Makefile               |    1 +
> > net/netfilter/xt_APPROVE.c           |   85
> > ++++++++++++++++++++++++++++++++++
> 
> Until the situation with preexisting modules is solved,
> let's at least not add anymore modules with cased names.
> 
> xt_approve.{c,h} please. (Do retain the module aliases however.)
> 
> > 4 files changed, 106 insertions(+), 0 deletions(-)
> > create mode 100644 include/linux/netfilter/xt_APPROVE.h
> > create mode 100644 net/netfilter/xt_APPROVE.c
> >
> >diff --git a/include/linux/netfilter/xt_APPROVE.h
> >b/include/linux/netfilter/xt_APPROVE.h new file mode 100644
> >index 0000000..c62c6bc
> >--- /dev/null
> >+++ b/include/linux/netfilter/xt_APPROVE.h
> >@@ -0,0 +1,8 @@
> >+#ifndef _XT_APPROVE_H
> >+#define _XT_APPROVE_H
> >+
> >+struct nf_approve_info {
> >+	u_int16_t ruleid;
> >+};
> 
> Intended to be "struct xt_approve_info"?

Ok, will rename...

> 
> >+
> >+#endif /* _XT_APPROVE_H */
> >diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> >index 1534f2b..34cd76c 100644
> >--- a/net/netfilter/Kconfig
> >+++ b/net/netfilter/Kconfig
> >@@ -546,6 +546,18 @@ config NETFILTER_XT_TARGET_TRACE
> >
> > 	  If you want to compile it as a module, say M here and read
> > 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
> >
> >+config NETFILTER_XT_TARGET_APPROVE
> >+	tristate  '"APPROVE" target support'
> >+	depends on NF_CONNTRACK
> >+	depends on NETFILTER_ADVANCED
> >+	help
> >+	  The APPROVE target allows you to add a rule ID to the
> >+	  connection tracking entry. So you can see which rules
> >+	  allowed a connection.
> >+
> >+	  If you want to compile it as a module, say M here and read
> >+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
> >+
> 
> Do please keep the list sorted rather than throwing it somewhere :)

Ok.

> 
> >diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> >index f5bff47..db8a342 100644
> >--- a/net/netfilter/Makefile
> >+++ b/net/netfilter/Makefile
> >@@ -62,6 +62,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
> >
> > obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
> > obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
> > obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
> >
> >+obj-$(CONFIG_NETFILTER_XT_TARGET_APPROVE) += xt_APPROVE.o
> >
> > obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
> 
> Likewise.

Ok.

> 
> >+static unsigned int
> >+approve_tg(struct sk_buff *skb, const struct xt_action_param *par)
> >+{
> >+	enum ip_conntrack_info cti;
> >+	struct nf_conn *nfc;
> >+	struct nf_conn_ruleid *nfcr;
> >+	const struct nf_approve_info *ri = par->targinfo;
> 
> (There is no strict rule to use three-letter variable names. It's
> just that skb and par are often typed and thus warrant having it.)

I like short names. :-)

> 
> >+	if (!nfcr) {
> >+		nfcr = nf_ct_ext_add(nfc, NF_CT_EXT_RULEID, GFP_ATOMIC);
> >+
> >+		/* we're out of memory */
> >+		if (!nfcr)
> >+			goto out;
> >+	}
> >+
> >+	nfcr->rule[cti] = ri->ruleid;
> >+
> >+	spin_unlock_bh(&nfc->lock);
> >+
> >+out:
> >+	return NF_ACCEPT;
> >+}
> 
> In the error case, you forget to unlock the spinlock.

*ashamed*, will fix.

Thanks for your review!
//richard
