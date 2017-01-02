From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 0/2] segtree: move huge arrays to heap
Date: Mon,  2 Jan 2017 18:38:49 +0100
Message-ID: <20170102173851.2542-1-oleksandr@natalenko.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:41738 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755998AbdABRjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 12:39:00 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:470:5b39:29:c99:116f:61fe:9756])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id DAB7B16AA53
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2017 18:38:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While dealing with huge sets, nft may exhaust stack
and trigger segfault. To avoid this, lets move those
huge arrays away from stack to heap.

First patch introduces array allocation helper.

Second patch modifies interval_map_decompose()
function, allocating memory for arrays on head.

Meny thanks to Florian Westphal who helped
to sort this out.

Oleksandr Natalenko (2):
  utils: provide array allocation wrapper
  segtree: allocate memory for arrays on heap

 include/utils.h |  1 +
 src/segtree.c   |  8 +++++++-
 src/utils.c     | 11 +++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.11.0

