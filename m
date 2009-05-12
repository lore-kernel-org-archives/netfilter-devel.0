From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/1] Conntrack-event-generation-control, userspace part
Date: Tue, 12 May 2009 14:52:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905121448020.31110@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0905121352260.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45604 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZELMw7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 08:52:59 -0400
In-Reply-To: <alpine.DEB.2.00.0905121352260.28379@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-05-12 13:54, Jozsef Kadlecsik wrote:
>+	case 'e': /* --events */
>+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK",
>+				  *flags & F_EVENTS);

Should be *flags & F_EXP_EVENTS, because presence of F_EXP_EVENTS
shall cause the error to be thrown (I assume).

>+		parse_events(&info->eventmask);
>+		info->events = 1;
>+		*flags |= F_EVENTS;
>+		return true;
>+
>+	case 'x': /* --exp-events */
>+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK",
>+				  *flags & F_EXP_EVENTS);

Conversely, *flags & F_EVENTS.

>diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
>index 4e58ba4..bc4526e 100644
>--- a/include/linux/netfilter/xt_CONNMARK.h
>+++ b/include/linux/netfilter/xt_CONNMARK.h
>@@ -13,7 +13,8 @@
> enum {
> 	XT_CONNMARK_SET = 0,
> 	XT_CONNMARK_SAVE,
>-	XT_CONNMARK_RESTORE
>+	XT_CONNMARK_RESTORE,
>+	XT_CONNMARK_EVENT_ONLY
> };
> 
> struct xt_connmark_target_info {
>@@ -27,4 +28,114 @@ struct xt_connmark_tginfo1 {
> 	u_int8_t mode;
> };
> 
>+struct xt_connmark_tginfo2 {
>+	u_int32_t ctmark, ctmask, nfmask;
>+	u_int8_t mode;
>+	u_int8_t events;
>+	u_int16_t eventmask;
>+};
>+
>+/* Connection tracking event bits */
>+enum ip_conntrack_events
>+{
>+	/* New conntrack */
>+	IPCT_NEW_BIT = 0,
>+	IPCT_NEW = (1 << IPCT_NEW_BIT),

This change will be overwritten when the kernel headers are resynced
from the linux kernel. As such, the ip_conntrack_events add should be
done in the same file as it was done in the kernel.

>+static const char events[IPEXP_ALL_BIT+1][16] = {
>+	[IPCT_NEW_BIT]		= "NEW",
>+	[IPCT_RELATED_BIT]	= "RELATED",
>+	[IPCT_DESTROY_BIT]	= "DESTROY",
>+	[IPCT_REFRESH_BIT]	= "REFRESH",
>+	[IPCT_ASSURED_BIT]	= "ASSURED",
>+	[IPCT_PROTOINFO_BIT]	= "PROTOINFO",
>+	[IPCT_ICMP_PROTOINFO_BIT] = "ICMP_PROTOINFO",
>+	[IPCT_HELPER_BIT]	= "HELPER",
>+	[IPCT_HELPINFO_BIT]	= "HELPINFO",
>+	[IPCT_SEEN_REPLY_BIT]	= "SEEN_REPLY",
>+	[IPCT_MARK_BIT]		= "MARK",
>+	[IPCT_NATSEQADJ_BIT]	= "NATSEQADJ",
>+	[IPCT_SECMARK_BIT]	= "SECMARK",
>+	[IPCT_ALL_BIT]		= "ALL",
>+	[IPEXP_NEW_BIT]		= "NEW",
>+	[IPEXP_REFRESH_BIT]	= "REFRESH",
>+	[IPEXP_TIMEOUT_BIT]	= "TIMEOUT",
>+	[IPEXP_ALL_BIT]		= "ALL",
>+};

Definitions go into .c files, too. I might even suggest to just use

static const char *const events[] = {...}


