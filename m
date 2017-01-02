From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH v2 0/2] segtree: move huge arrays to heap
Date: Mon,  2 Jan 2017 20:54:07 +0100
Message-ID: <20170102195409.14669-1-oleksandr@natalenko.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:44560 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933348AbdABTyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 14:54:18 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:470:5b39:29:c99:116f:61fe:9756])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 168F616AAEA
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2017 20:54:15 +0100 (CET)
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

Changelog:

v2: nmemb actually can be 0, so remove that
    assertion

v1: initial submission

Oleksandr Natalenko (2):
  utils: provide array allocation wrapper
  segtree: allocate memory for arrays on heap

 include/utils.h |  1 +
 src/segtree.c   |  8 +++++++-
 src/utils.c     | 10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.11.0

