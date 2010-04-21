From: Justin Yaple <yaplej@gmail.com>
Subject: Recalculate checksums in netfilter queue
Date: Tue, 20 Apr 2010 18:02:42 -0700
Message-ID: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61810 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0DUBCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:02:43 -0400
Received: by gwj19 with SMTP id 19so1125855gwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2010 18:02:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am having some trouble figuring out how to re-calculate the tcp/ip
checksums after pulling a packet into user space with
libnetfilter_queue.  In a netfilter hook I was able to use this:
tcph->check = 0;
tcph->check = tcp_v4_check(tcph, tcplen,
	iph->saddr,
	iph->daddr,
	csum_partial((char *)tcph, tcplen, 0));
	iph->check = 0;
	ip_send_check(iph); //ip checksum

In user space these functions tcp_v4_check(), csum_partial() and
ip_send_check() do not exists.  Are there equivalent functions in user
space so I can recalculate the ip/tcp checksums before passing the new
packet back to the kernel with nfq_set_verdict()?

Thanks.
