From: Florian Westphal <fw@strlen.de>
Subject: [RFC 0/2] nftables iptables nat co-existence patches
Date: Thu, 29 Jun 2017 14:28:54 +0200
Message-ID: <20170629122856.28231-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39750 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdF2M2i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 08:28:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... another round of changes we can discuss at nfws.
This allows to use both iptables and nft nat at the same time,
first match wins.

