From: Kyle Sanderson <kyle.leet@gmail.com>
Subject: iptables doesn't function properly with x32.
Date: Mon, 1 Jul 2013 12:44:13 -0700
Message-ID: <CACsaVZJWLLYtfcDnbAWj6N_8mi5EHPvf7zND5Csyi_UDMj0Q_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter <netfilter@vger.kernel.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37472 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GATof (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:44:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I can't seem to get iptables functioning on my x32 system. I've tried
versions (1.4.16.3 and 1.4.19.1), however both result in the same
error message: can't initialize iptables table `filter': Invalid
argument.

Walking through the error with gdb shows the failure is in a call to
struct xtc_handle * TC_INIT(const char *tablename). The function if
(getsockopt(h->sockfd, TC_IPPROTO, SO_GET_ENTRIES, h->entries, &tmp) <
0) sets errno to EINVAL, which results in the failure. fw in #Netdev
seemed to indicate the compat layer might not be being used due to the
platform change.

I've tried various recompiles of Kernel 3.8.13 and Kernel 3.9.8. I'm
running iproute2 as well, this is all on Gentoo.

Thanks for your time,
Kyle.
