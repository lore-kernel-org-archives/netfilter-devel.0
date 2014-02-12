From: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 2/2] lib: don't segfault when ipset_data_get returns NULL
Date: Wed, 12 Feb 2014 10:27:20 +0100
Message-ID: <1392197240-9389-2-git-send-email-fw@strlen.de>
References: <1392197240-9389-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37574 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbaBLJbM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:31:12 -0500
In-Reply-To: <1392197240-9389-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipset_data_get returns NULL if the attribute is not available, causes when
running 'ipset list':

$ ipset -N foo hash:ip
$ ipset list
Segmentation fault (core dumped)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not sure about this patch, the missing attr is IPSET_OPT_MEMSIZE.
 Is the kernel supposed to send it along (i am on latest nf tree)?

diff --git a/lib/print.c b/lib/print.c
index f81c074..9ad4bab 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -378,6 +378,8 @@ ipset_print_number(char *buf, unsigned int len,
 	assert(data);
 
 	number = ipset_data_get(data, opt);
+	if (!number)
+		return 0;
 	maxsize = ipset_data_sizeof(opt, AF_INET);
 	D("opt: %u, maxsize %zu", opt, maxsize);
 	if (maxsize == sizeof(uint8_t))
-- 
1.8.1.5

