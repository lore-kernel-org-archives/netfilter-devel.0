From: valentina.giusti@bmw-carit.de
Subject: [PATCH] [RFC] xt_owner: enable xt_owner on INPUT chain
Date: Fri, 30 Aug 2013 14:43:42 +0200
Message-ID: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49541 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669Ab3H3Mwa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:52:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

I'm working on getting the owner extension also on the INPUT chain.

While it works already for TCP with the following patch (and thanks to commit
41063e9 ipv4: Early TCP socket demux), I'll also need to enable the match for
other kinds of sockets (e.g. UDP) on INPUT, which IMO should be achieved by
implementing the early demultiplexing for other kinds of connections.

In the meanwhile, could anybody please give feedback and tell me if this is the
right direction?



