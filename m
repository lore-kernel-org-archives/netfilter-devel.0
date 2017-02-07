From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nf-next 0/1] TCP option matching
Date: Tue,  7 Feb 2017 03:14:52 +0100
Message-ID: <20170207021453.22541-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:56608 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751690AbdBGCTx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:53 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 32B6CB02B4
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:15:05 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set is part of the TCP option matching implementation for nftables.

Manuel Messner (1):
  net: netfilter: nft_exthdr: add TCP option matching

 include/uapi/linux/netfilter/nf_tables.h |  17 ++++-
 net/netfilter/Kconfig                    |   4 +-
 net/netfilter/nft_exthdr.c               | 120 +++++++++++++++++++++++++++----
 3 files changed, 125 insertions(+), 16 deletions(-)

--
2.11.1

