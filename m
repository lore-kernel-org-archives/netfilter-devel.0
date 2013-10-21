From: Jan Engelhardt <jengelh@inai.de>
Subject: ipset 6.20 compile failure on <3.8
Date: Tue, 22 Oct 2013 00:53:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1310220048430.30326@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48179 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3JUWxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:53:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The openSUSE build system reports for their kernel 3.7 a FTBFS
for ipset 6.20 (path abridged with a '~'):

[   94s]   CC [M]  ~/kernel/net/sched/em_ipset.o
[   94s]   CC [M]  ~/kernel/net/netfilter/xt_set.o
[   97s]   CC [M]  ~/kernel/net/netfilter/ipset/ip_set_core.o
[   97s]   CC [M]  ~/kernel/net/netfilter/ipset/ip_set_getport.o
[   97s] ~/kernel/net/netfilter/ipset/ip_set_core.c: In function 'ip_set_sockfn_get':
[   97s] ~/kernel/net/netfilter/ipset/ip_set_core.c:1867:21: error: 'struct net' has no member named 'user_ns'

The lines 1867+ are:
        if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
                return -EPERM;

But net->user_ns is only available starting from 3.8.
