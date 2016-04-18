From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/7] named sets with intervals
Date: Mon, 18 Apr 2016 20:14:28 +0200
Message-ID: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35434 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcDRSOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2AB5FC107F
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 120F39D10D
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC438C21A8
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:47 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset updates the set interval support to work with named sets,
that requires the following kernel patches that I have already submitted:

http://patchwork.ozlabs.org/patch/609733/
http://patchwork.ozlabs.org/patch/609734/
http://patchwork.ozlabs.org/patch/609735/
http://patchwork.ozlabs.org/patch/609736/

Several comments on this:

1) nft supports automerging of adjacent intervals when they are added in
   the same command, eg.

	nft add element filter myset { 192.168.0.0/24, 192.168.1.0/24 }

   this results in one single interval 192.168.0.0/23.

   However, if you add them in two command invocations:

	nft add element filter myset { 192.168.0.0/24 }
	nft add element filter myset { 192.168.0.1/24 }

   You get two intervals, ie. 192.168.0.0/24 and 192.168.1.0/24. Automerging
   for this case should be possible from userspace, by removing the previous
   interval and adding the new one. This code is not yet available though.

2) There is currently no check in userspace for interval shadowing, eg.

	nft add element filter myset { 192.168.0.0/24 }
	nft add element filter myset { 192.168.0.0/16 }

    In this case, the largest segment is prioritized over the smaller one.
    The code to detect this shadowing from userspace is missing.

3) The first non-matching end interval (ie. all-zero) is specific of the
   rbtree implementation, I don't need this in my bitmap set
   representation. This is already part of the API though, so my plan is to
   add this node to the rbtree set from the kernel and ignore whenever we
   receive it from userspace, so we can deprecate having to send this from
   userspace at some point.

4) Support for named interval map is also missing. This requires a very
   small oneliner fix for the parser. Interval shadowing is particularly
   problematic in this scenario, for this reason, the oneliner fix should
   come with the shadowing detection code too. Meanwhile we don't have
   proper support for named interval maps.

Pablo Neira Ayuso (7):
  segtree: perform stricter expression type validation from expr_value()
  segtree: clone full expression from interval_map_decompose()
  segtree: handle adjacent interval nodes from expr_value_cmp()
  segtree: explicit initialization via set_to_intervals()
  rule: support for incremental set interval element updates
  segtree: special handling for the first non-matching segment
  evaluate: bail out on prefix or range to non-interval set

 include/expression.h |  3 ++-
 src/evaluate.c       | 15 +++++++++++
 src/rule.c           | 52 +++++++++++++++++++++++++++++-------
 src/segtree.c        | 75 +++++++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 118 insertions(+), 27 deletions(-)

-- 
2.1.4

