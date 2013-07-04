From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 0/2] minor debugging fixes
Date: Thu, 04 Jul 2013 11:26:16 +0400
Message-ID: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63503 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3GDH0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:26:30 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPE0083FI00UT00@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 04 Jul 2013 08:26:28 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I faced with inconvenient behaviour in early version of iptables,
it runs modprobe unconditionally. I know it is already fixed.

While debugging I came across to missing debug trace in libxt_dccp and 
libxt_sctp. Also I think it would be better to clarify DEBUG define usage.


Alexey Perevalov (2):
  Clarify DEBUG usage macro
  extensions: libxt_dccp/libxt_sctp: enable debug tracing by DEBUG
    define

 INSTALL                 |    2 ++
 extensions/libxt_dccp.c |    4 ++--
 extensions/libxt_sctp.c |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.9.5

