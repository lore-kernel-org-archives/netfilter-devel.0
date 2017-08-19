From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/7] tcp mss mangling support
Date: Sun, 20 Aug 2017 01:14:06 +0200
Message-ID: <20170819231413.15164-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39288 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752021AbdHSXNz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 19:13:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the userspace patch set for tcp option mangling.

First two patches add libnftl support for the exthdr and rt code,
remaining patches add nftables frontend support.

