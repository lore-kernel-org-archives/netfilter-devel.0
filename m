From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nf-next 0/1] TCP option matching
Date: Tue,  7 Feb 2017 03:15:17 +0100
Message-ID: <20170207021518.22622-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:44125 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751456AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 98C83B02C1
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:15:27 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set is part of the TCP option matching implementation for nftables.

Manuel Messner (1):
  src: add TCP option matching requirements

 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h | 17 ++++++++++++-
 src/expr/exthdr.c                   | 49 ++++++++++++++++++++++++++++++++++---
 3 files changed, 62 insertions(+), 5 deletions(-)

--
2.11.1

