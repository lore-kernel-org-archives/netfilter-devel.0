From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: A bug in xtables-addons-1.38
Date: Mon, 22 Aug 2011 23:42:54 +0200
Message-ID: <j2uigu$sk4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38647 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1HVVnI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:43:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1QvcGw-0008Hm-El
	for netfilter-devel@vger.kernel.org; Mon, 22 Aug 2011 23:43:06 +0200
Received: from h75021.upc-h.chello.nl ([62.194.75.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2011 23:43:06 +0200
Received: from sfzhi by h75021.upc-h.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2011 23:43:06 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Looks like there is a small bug in xtables-addons-1.38.
extensions/xt_CHECKSUM.c should #include <linux/version.h>
otherwise build fails (tried with kernel 2.6.35.14).

--
Regards,
Sergei.

