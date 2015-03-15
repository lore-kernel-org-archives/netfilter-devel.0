From: Philipp Kerling <philipp.kerling@tu-ilmenau.de>
Subject: Using kernel ip_tables headers in C++
Date: Sun, 15 Mar 2015 14:26:33 +0100
Message-ID: <1426425993.8827.7.camel@tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smail.rz.tu-ilmenau.de ([141.24.4.149]:38350 "EHLO
	smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbCONgF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Mar 2015 09:36:05 -0400
Received: from hiraizumi.lan (dslb-094-222-075-045.094.222.pools.vodafone-ip.de [94.222.75.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id B8F515EE09
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2015 14:26:32 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good day,

the current iptables headers do not allow the inclusion in C++ code
because of some pointer arithmetic issues in
include/linux/netfilter_ipv4/ip_tables.h and
include/linux/netfilter_ipv6/ip6_tables.h. Now there is a patch
available already at
https://marc.info/?l=netfilter-devel&m=134906873228460 that was
submitted two years ago. What is the current state on this? IMHO, it
should be trivial to apply and does not have any downsides or
side-effects. It's only a "clarification" of what the current code does
in C mode anyway. But it would make C++ developers very happy. GCC is
nice enough to only output warnings, but CLang isn't. It just bails out
with "error: arithmetic on a pointer to void".

Regards
Philipp Kerling

