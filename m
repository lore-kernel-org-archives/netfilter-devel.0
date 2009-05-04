From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] conntrack event subsystem updates for 2.6.31 (part 2)
Date: Mon, 04 May 2009 15:53:09 +0200
Message-ID: <20090504134740.8394.21789.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZEDNxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2009 09:53:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick!

This is the second part of the updates for the conntrack event
subsystem. These patches are built on top of the previous patchset.
They basically consists of a re-work of the conntrack event cache to
switch from per-cpu to the conntrack extension infrastructure that is
required by the optional reliable event delivery.

Basically, the idea consists of accumulating undelivered events in
the per-conntrack cache to allow another try once the next packet
hits the conntrack entry. We may keep losing events but, at worst
case, we make sure that destroy events are delivered.

Feedback welcome.

---

Pablo Neira Ayuso (2):
      netfilter: conntrack: optional reliable conntrack event delivery
      netfilter: conntrack: move event cache to conntrack extension infrastructure


 include/net/netfilter/nf_conntrack.h        |    2 
 include/net/netfilter/nf_conntrack_core.h   |    6 +
 include/net/netfilter/nf_conntrack_ecache.h |  156 ++++++++++++--------
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netfilter/nf_conntrack_helper.h |    2 
 include/net/netns/conntrack.h               |    7 +
 net/netfilter/nf_conntrack_core.c           |  106 ++++++++++---
 net/netfilter/nf_conntrack_ecache.c         |  215 ++++++++++++++++++---------
 net/netfilter/nf_conntrack_helper.c         |   15 ++
 net/netfilter/nf_conntrack_netlink.c        |   90 +++++++----
 10 files changed, 403 insertions(+), 198 deletions(-)

