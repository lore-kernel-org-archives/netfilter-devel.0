From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/5] nf_tables: rule deletion by description
Date: Thu,  9 Feb 2017 17:13:45 +0100
Message-ID: <1486656830-3245-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbdBIQOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 11:14:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BC0111A11C
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48BA3DA725
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8BB11DA725
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:13:59 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Rule deletion by description is a feature missing these days in
nf_tables that has been requested already several times by different
people.

I'm talking specifically of this feature that is available in iptables:

 # iptables -D INPUT -p tcp --dport 22 -j DROP

that allows us to delete the first rule matching this description.

So far, nf_tables allows users to delete rules through unique handle
numbers that you can list via -a option.

The approach I decided to follow adds most of this logic to userspace.
Basically, if the user wants to delete a given rule, the idea is to dump
the ruleset and compare if this rule matches any of the existing ones.
In case of matching found, annotate the rule handle and use it to delete
it from the kernel.

I noticed two corner cases that are problematic though:

1) A robot performs a rule deletion-after-addition from the same batch.
   This rule has no public u64 handle yet, therefore we cannot
   reference it. Add a new NFTA_RULE_ID, which is similar to NFTA_SET_ID
   in essence, that indicates an unique rule identifier inside the batch.
   This can be used to delete this rule not yet with the public handle.

1) Two threads compete to delete duplicated a rule. Even if duplicated
   rules make no sense, since the first rule would shadow the duplicated
   one, two robots inserting rules may lead us to this situation. Then,
   if robot A and robot B race to delete these duplicated rules, they may
   end up pointing to the same rule handle, so the one losing race will
   indicate that rule doesn't exist, while one of the two rules will
   still remain there, leaving the ruleset in inconsistent state.
   To catch this rare case, this patch introduces a way to validate
   what ruleset generation userspace expects to operate with. In case,
   kernel notices that userspace operates with a stale generation
   number, the kernel returns -ERESTART so userspace can transparently
   relookup for the rule handle.

I have a userspace patchset to implement rule deletion by description
for nft, still incomplete (I may push it to a branch though for
previous).  Main problem so far is that rule comparisons require that
the representation in both linearize and delinearize paths are the same.
This feature needs quite a bit of several userspace patches still
because there are a number of asymmetries in the rule representation
that need to be fixed, eg. I had to split bitfield transformations that
we're performing in the evaluation phase into a new specific step
between evaluation and linearization.

Another solution for this problem is to handle this entirely from
kernelspace. However, this is specifically cumbersome with anonymous
sets, that require a full comparison of all elements given that name are
meaningless. Moreover, on top of that, elements need to be ordered which
is not guaranteed when iterating over set backends such as hashtable. So
solving this from kernel look even more complex to me.

Let me know if you have any comment on these, thanks.

Pablo Neira Ayuso (5):
  netfilter: nfnetlink: get rid of u_intX_t types
  netfilter: nfnetlink: add nfnetlink_rcv_skb_batch()
  netfilter: nfnetlink: allow to check for generation ID
  netfilter: nf_tables: add check_genid to the nfnetlink subsystem
  netfilter: nf_tables: add NFTA_RULE_ID attribute

 include/linux/netfilter/nfnetlink.h      |  1 +
 include/net/netfilter/nf_tables.h        |  3 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 include/uapi/linux/netfilter/nfnetlink.h | 12 +++++
 net/netfilter/nf_tables_api.c            | 32 ++++++++++++
 net/netfilter/nfnetlink.c                | 90 +++++++++++++++++++++-----------
 6 files changed, 109 insertions(+), 31 deletions(-)

-- 
2.1.4

