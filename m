From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] netlink heap info leak fixes
Date: Mon, 30 Sep 2013 22:05:06 +0200
Message-ID: <1380571508-15486-1-git-send-email-minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52626 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3I3UFc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:05:32 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so2184756bkh.25
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 13:05:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series fixes a few netlink related heap info leaks.

All probably material for stable (ebt_ulog: v2.6.11+, ipt_ULOG: v2.5.2.4+).

Please apply!


Mathias Krause (2):
  netfilter: ebt_ulog: fix info leaks
  netfilter: ipt_ULOG: fix info leaks

 net/bridge/netfilter/ebt_ulog.c |    9 +++------
 net/ipv4/netfilter/ipt_ULOG.c   |    7 +------
 2 files changed, 4 insertions(+), 12 deletions(-)

-- 
1.7.10.4

