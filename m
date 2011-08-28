From: Jan Engelhardt <jengelh@medozas.de>
Subject: (unknown)
Date: Sun, 28 Aug 2011 16:11:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42045 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1H1OLu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 10:11:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


libxt_SET.c requires IPSET_INVALID_ID, but this constant has moved into 
a #ifdef __KERNEL__ section lately and is thus absent from userspace. 
(In linux-kernel/include/linux/netfilter/ipset/ip_set.h.)
