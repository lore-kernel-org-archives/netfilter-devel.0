From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next 0/3] Additional nf_hook_entry compaction
Date: Tue, 15 Nov 2016 17:48:43 -0500
Message-ID: <1479250126-15111-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        coreteam@netfilter.org, "David S . Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33378 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753793AbcKOWsy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 17:48:54 -0500
Received: by mail-qt0-f194.google.com with SMTP id n6so9641961qtd.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 14:48:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series introduces a set of accessors, compacts the nf_hook_entry, and
rearranges some of the loops in preparation for the final set of work going
to an array based hook system.

After this series, the nf_hook_entry should fit in a cacheline on a modern
Intel i7.

Tested on bare-metal system.

Aaron Conole (3):
  netfilter: introduce accessor functions for hook entries
  netfilter: decouple nf_hook_entry and nf_hook_ops
  netfilter: convert while loops to for loops

 include/linux/netfilter.h       | 31 ++++++++++++++++++++++++++++++-
 net/bridge/br_netfilter_hooks.c |  8 ++++----
 net/netfilter/core.c            | 16 ++++++----------
 net/netfilter/nf_queue.c        |  5 ++---
 4 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.7.4

