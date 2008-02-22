From: santosh shukla <sshukla@sh.mvista.com>
Subject: Bug ID-94: Limit match broken
Date: Fri, 22 Feb 2008 18:56:52 +0530
Message-ID: <1203686813.4124.5.camel@localhost.SH.COM>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:54562 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757366AbYBVNYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:24:20 -0500
Received: from [10.160.1.136] (unknown [10.160.1.136])
	by imap.sh.mvista.com (Postfix) with ESMTP id 351083ECA
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Feb 2008 05:24:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have recently found a problem while using iptables-1.3.3 package that,

its "limit match got broken up" while trying iptables cmd on ppc 64-bit
processor.

can any one suggest me for fixed version of this bug, is appeared in
which next iptable release.

Regards,
Santosh shukla
 

