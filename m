From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 0/2] tproxy: add IPv6 support
Date: Thu, 21 Oct 2010 17:19:22 +0200
Message-ID: <20101021151922.21665.36832.stgit@este.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:48970 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0JUPUY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:20:24 -0400
Received: from [192.168.0.33] ([150.214.188.150])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0LAN00M2QBXYAEI6@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Thu, 21 Oct 2010 17:20:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds IPv6 support to the socket match and the TPROXY target.

---

Balazs Scheidler (2):
      tproxy: add IPv6 support for socket match
      tproxy: add IPv6 support to the TPROXY target


 extensions/libxt_TPROXY.c           |  213 +++++++++++++++++++++++++++++------
 extensions/libxt_socket.c           |  103 ++++++++++++++++-
 extensions/libxt_socket.man         |    6 +
 include/linux/netfilter/xt_TPROXY.h |    7 +
 include/linux/netfilter/xt_socket.h |   12 ++
 5 files changed, 295 insertions(+), 46 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

-- 
KOVACS Krisztian

