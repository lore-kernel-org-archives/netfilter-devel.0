From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/1] extensions: add idletimer xt target extension
Date: Mon, 14 Jun 2010 16:40:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006141639390.32450@obet.zrqbmnf.qr>
References: <1276525990-7058-1-git-send-email-luciano.coelho@nokia.com> <1276525990-7058-2-git-send-email-luciano.coelho@nokia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	jukka.rissanen@nokia.com
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43191 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0FNOkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:40:10 -0400
In-Reply-To: <1276525990-7058-2-git-send-email-luciano.coelho@nokia.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-06-14 16:33, Luciano Coelho wrote:
>+#ifndef _XT_IDLETIMER_H
>+#define _XT_IDLETIMER_H
>+
>+#include <linux/types.h>
>+
>+#define MAX_IDLETIMER_LABEL_SIZE 32

I suggest we go down to 28 on this one, so that there won't
be a wasted padding hole on 64-bit.

>+struct idletimer_tg_info {
>+	__u32 timeout;
>+
>+	char label[MAX_IDLETIMER_LABEL_SIZE];
>+
>+	/* for kernel module internal use only */
>+	struct idletimer_tg *timer __attribute((aligned(8)));
>+};
