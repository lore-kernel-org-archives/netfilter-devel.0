From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC NETFILTER 1/4]: add xt_RATEEST target
Date: Sun, 25 Nov 2007 18:24:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251815430.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACCF.3020806@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59022 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXKYRYh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:24:37 -0500
In-Reply-To: <4749ACCF.3020806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 25 2007 18:11, Patrick McHardy wrote:

>Date: Sun, 25 Nov 2007 18:11:43 +0100
>From: Patrick McHardy <kaber@trash.net>
>To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>Subject: [RFC NETFILTER 1/4]: add xt_RATEEST target
>
>
>

^^^ That's all pine gives on reply. :)
*Inline patches* preferred.

>@@ -0,0 +1,11 @@
>+#ifndef _XT_RATEEST_TARGET_H
>+#define _XT_RATEEST_TARGET_H
>+
>+struct xt_rateest_target_info {
>+	char			name[IFNAMSIZ];
>+	signed char		interval;
>+	unsigned char		ewma_log;

int8_t, uint8_t.

>+	struct xt_rateest	*est __attribute__((aligned(8)));
>+};
>+
>+#endif /* _XT_RATEEST_TARGET_H */
