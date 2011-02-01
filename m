From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] bugfixes for nf-next-2.6 (2.6.38-rc)
Date: Tue, 01 Feb 2011 13:05:04 +0100
Message-ID: <20110201120116.3427.96097.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57583 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1BAMFT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:05:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick!

I've got a couple of patches for nf-next-2.6. The first fixes
arptables that seems to be broken since quite some time due
to a broken cleanup. The latter refers to the CT event filtering,
I think it can be qualified as bugfix since the current filtering
schema is not useful for conntrackd.

Please, apply!

---

Pablo Neira Ayuso (2):
      netfilter: arpt_mangle: fix return values of checkentry
      netfilter: ecache: always set events bits, filter them later


 include/net/netfilter/nf_conntrack_ecache.h |    3 ---
 net/ipv4/netfilter/arpt_mangle.c            |    6 +++---
 net/netfilter/nf_conntrack_ecache.c         |    3 +++
 3 files changed, 6 insertions(+), 6 deletions(-)

--
1+1=1
