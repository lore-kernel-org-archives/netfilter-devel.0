From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] support ct/meta key lookups at runtime
Date: Thu, 27 Oct 2016 00:36:05 +0200
Message-ID: <1477521368-12696-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58154 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751810AbcJZWfz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 18:35:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a patch series to add support of hash (skb hash) and sym hash
(symmetric skb hash) to nft_meta.

This series would allow extending meta without adding new hash/symhash
keywords in the scanner.

What do you think?

