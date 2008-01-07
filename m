From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 25/27] Merge ipt_ah and ip6t_ah into xt_ah
Date: Mon, 07 Jan 2008 15:24:18 +0900 (JST)
Message-ID: <200801070624.m076OJbG022966@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:48673 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbYAGGyV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:54:21 -0500
Received: from inet-tsb5.toshiba.co.jp (inet-tsb5 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id m076sK7a027600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Jan 2008 15:54:20 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by inet-tsb5.toshiba.co.jp  with ESMTP id m076OLoB012477
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Jan 2008 15:24:21 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id m076OLbJ011220
	for netfilter-devel@vger.kernel.org; Mon, 7 Jan 2008 15:24:21 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id m076OLQ8011494
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Jan 2008 15:24:21 +0900 (JST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

> commit 11c4c687b1df11aeadd9ab76f37c4a89144d9a73
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 20:14:28 2008 +0100
> 
>     [NETFILTER]: Merge ipt_ah and ip6t_ah into xt_ah
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

+static struct xt_match ah_mt_reg[] __read_mostly = {
+       {
+               .name       = "ah",
+               .revision   = 0,
+               .family     = AF_INET,
+               .match      = ah_mt4,
+               .matchsize  = sizeof(struct ipt_ah),
+               .checkentry = ah_mt4_check,
+               .me         = THIS_MODULE,
+       },
+#ifdef WITH_IPV6
+       {
+               .name       = "ah",
+               .revision   = 0,
+               .family     = AF_INET6,
+               .match      = ah_mt6,
+               .matchsize  = sizeof(struct ip6t_ah),
+               .checkentry = ah_mt6_check,
+               .me         = THIS_MODULE,
+       },
+#endif
+};

ah match for IPv4 requires ".proto = IPPROTO_AH," as written in
the current ipt_ah.c. For IPv6, it is not needed. Because AH header is
an extension header, not transport header.

-- Yasuyuki Kozakai
