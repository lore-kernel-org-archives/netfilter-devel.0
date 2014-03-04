From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH 0/2] netfilter: nf_tables: set selection
Date: Tue,  4 Mar 2014 16:41:05 +0100
Message-ID: <1393947667-6143-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41017 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDPlt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:41:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds the beginning of proper set selection based on
a description of the set characteristics.

The basic idea is that userspace provides a description of the set
elements and the kernel selects the best suited implementation according
to a policy provided by userspace (performance/memory).

We have two cases:

- literal (anonymous/constant) sets where all elements are known in advance
- set declarations where elements might or might not be known in advance

In the first case userspace can provide all the information we need, in the
second case the user can provide hints that allow us to select something
based on the expected use case.

So far all the information we need is the maximum amount of elements in the
set. The performance class of both the rbtree and the hash (with resizing)
is fixed, the expected memory use depends purely on the amount of elements.

In case that userspace provides that information, the set implementation
calculate an estimate, otherwise we use the per-element costs to decide.

Instead of adding more information based on what we expect future
implementations might need, I decided to start simple and we can add more
information whenever the need arises for a new set implementation. Since
the type of information required is expected to be quite similar for
most set types, we should approach a state where a new set implementation
will have all the data it needs available. Otherwise things won't fail,
but old userspace might not take advantage of a better suited
implementation.

With these patches in place, we will usually select the hash implementation,
unless we require support for interval lookups, in which case we'll use
the rbtree.

Patches apply on top of the RCU hash resizing patch I just sent.

Comments welcome.
