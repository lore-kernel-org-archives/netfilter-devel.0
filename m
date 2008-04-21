From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [patch]iptables-save:remove unnecessary code.
Date: Mon, 21 Apr 2008 18:23:38 +0800
Message-ID: <480C6B2A.9070003@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: rusty@rustcorp.com.au, laforge@gnumonks.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYDUKYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:24:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following code is never be used. It should be removed.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>

--- iptables-save.org 2008-04-15 20:01:06.000000000 +0800
+++ iptables-save.c 2008-04-11 21:28:57.000000000 +0800
@@ -106,19 +106,6 @@ static void print_proto(u_int16_t proto,
}
}

-#if 0
-static int non_zero(const void *ptr, size_t size)
-{
- unsigned int i;
-
- for (i = 0; i < size; i++)
- if (((char *)ptr)[i])
- return 0;
-
- return 1;
-}
-#endif
-
static int print_match(const struct ipt_entry_match *e,
const struct ipt_ip *ip)
{


