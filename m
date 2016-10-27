From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH RFC netfilter-next 0/3] Additional refactoring enhancements for nf_hook_entry
Date: Thu, 27 Oct 2016 14:27:50 -0400
Message-ID: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34296 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936503AbcJ0S2C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 14:28:02 -0400
Received: by mail-qk0-f171.google.com with SMTP id x11so9652051qka.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 11:28:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series reduces the size of the nf_hook_entry objects, and converts the
loops which traverse into for-loops.  This will facilitate future work to
switch from a singly-linked list into an array.

This series was built and tested on top of Pablo's series posted at
https://www.spinics.net/lists/netfilter-devel/msg44408.html

Aaron Conole (3):
  netfilter: introduce accessor functions for hook entries
  netfilter: decouple nf_hook_entry and nf_hook_ops
  netfilter: Convert while loops to for-loops

 include/linux/netfilter.h       | 42 +++++++++++++++++++++++++++++++++++++----
 net/bridge/br_netfilter_hooks.c |  8 ++++----
 net/netfilter/core.c            | 14 +++++---------
 net/netfilter/nf_queue.c        | 11 +++++------
 4 files changed, 52 insertions(+), 23 deletions(-)

-- 
2.7.4

