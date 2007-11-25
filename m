From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC IPTABLES 3/4]: add xt_RATEEST target
Date: Sun, 25 Nov 2007 18:34:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251831230.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACDB.3020705@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54621 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbXKYRen (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:34:43 -0500
In-Reply-To: <4749ACDB.3020705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Nov 25 2007 18:11, Patrick McHardy wrote:

>Date: Sun, 25 Nov 2007 18:11:55 +0100
>From: Patrick McHardy <kaber@trash.net>
>To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>Subject: [RFC IPTABLES 3/4]: add xt_RATEEST target
>
>
>

>[IPTABLES]: add xt_RATEEST target
>
>Signed-off-by: Patrick McHardy <kaber@trash.net>
>Index: include/linux/netfilter/xt_RATEEST.h
>===================================================================
>--- include/linux/netfilter/xt_RATEEST.h	(Revision 0)
>+++ include/linux/netfilter/xt_RATEEST.h	(Revision 0)
>@@ -0,0 +1,11 @@
>+#ifndef _XT_RATEEST_TARGET_H
>+#define _XT_RATEEST_TARGET_H
>+
>+struct xt_rateest_target_info {
>+	char			name[IFNAMSIZ];
>+	signed char		interval;
>+	unsigned char		ewma_log;

int8/uint8

>+	struct xt_rateest	*est __attribute__((aligned(8)));
>+};
>+
>+#endif /* _XT_RATEEST_TARGET_H */
>Index: extensions/libxt_RATEEST.c
>===================================================================
>--- extensions/libxt_RATEEST.c	(Revision 0)
>+++ extensions/libxt_RATEEST.c	(Revision 0)
>@@ -0,0 +1,240 @@
>+static unsigned int interval;
>+static unsigned int ewma_log;

>+static void
>+RATEEST_final_check(unsigned int flags)
>+{
>+	struct xt_rateest_target_info *info = RATEEST_info;
>+
>+	if (!(flags & (1 << RATEEST_OPT_NAME)))
>+		exit_error(PARAMETER_PROBLEM, "RATEEST: no name specified");
>+	if (!(flags & (1 << RATEEST_OPT_INTERVAL)))
>+		exit_error(PARAMETER_PROBLEM, "RATEEST: no interval specified");
>+	if (!(flags & (1 << RATEEST_OPT_EWMALOG)))
>+		exit_error(PARAMETER_PROBLEM, "RATEEST: no ewmalog specified");
>+
>+	for (info->interval = 0; info->interval <= 5; info->interval++) {
>+		if (interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
>+			break;
>+	}

-{}

>+static void
>+__RATEEST_print(const struct xt_entry_target *target, const char *prefix)
>+{
>+	struct xt_rateest_target_info *info = (void *)target->data;
>+	unsigned int interval;
>+	unsigned int ewma_log;

Ouchie - that throws a warning with -Wshadow (which is what I'm trying to slip
in later).

>+
>+	interval = (TIME_UNITS_PER_SEC << (info->interval + 2)) / 4;
>+	ewma_log = interval * (1 << (info->ewma_log));

ewma_log = interval << info->ewma_log;

>+	printf("%sname %s ", prefix, info->name);
>+	printf("%sinterval ", prefix);
>+	RATEEST_print_time(interval);
>+	printf("%sewmalog ", prefix);
>+	RATEEST_print_time(ewma_log);
>+}
>+


>-LDLIBS       = -ldl
>+LDLIBS       = -ldl -lm

I have not seen the function that requires -lm, which was it?

