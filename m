From: <abirvalg@lavabit.com>
Subject: conntrack can't update mark on icmp connection
Date: Tue, 14 Feb 2012 00:16:44 +0200
Message-ID: <20120214001644.2e3a0d4c@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:43709 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab2BMWPw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:15:52 -0500
Received: from b.earth.lavabit.com (b.earth.lavabit.com [192.168.111.11])
	by karen.lavabit.com (Postfix) with ESMTP id 5355911B850
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Feb 2012 16:15:52 -0600 (CST)
Received: from wwwwww-701sd (46.109.128.192)
	by lavabit.com with ESMTP id 6J6P6VCC4QAN
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Feb 2012 16:15:52 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
As root I try to set marks on all packets originating from my machine with

conntrack -U -s 192.168.1.114 --mark 10

It does set marks on some udp connections but ignores the icmp one.
Upon the issue of this command it lists all updated udp connections with mark=10 and \
                eventually gives
...
conntrack v0.9.14 (conntrack-tools): Operation failed: invalid parameters

After that conntrack -L shows that all udp connections that preceed in the list the icmp one \
where updated, but the icmp connection and all udp connections following it in the \
list were not updated. Seems like conntrack choked on icmp.

Could you please help me.
uname -a
Linux 2.6.35-30-generic #60-Ubuntu SMP Mon Sep 19 20:45:08 UTC 2011 i686 \
GNU/Linux

P.S.
Please CC me when replying.

