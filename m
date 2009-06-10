From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4] improve conntrack event reliability (try 3)
Date: Wed, 10 Jun 2009 15:40:17 +0200
Message-ID: <20090610133716.14805.95308.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZFJNkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:40:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here it follows the third incarnation of the reliable event delivery
for the conntrack event subsystem. I think that I did not miss any
of your suggestions and comments from the last time. This patchset
includes the missed cache approach that you have proposed today and
Eric's ack'ed patch that I sent yesterday to add some missing functions
to the nulls lists.

If you like them, you can pull them from:

git://1984.lsi.us.es/nf-next-2.6 master

Thanks!

---

Pablo Neira Ayuso (4):
      netfilter: conntrack: optional reliable conntrack event delivery
      list_nulls: add hlist_nulls_add_head and hlist_nulls_del
      netfilter: conntrack: move helper destruction to nf_ct_helper_destroy()
      netfilter: conntrack: move event caching to conntrack extension infrastructure


 include/linux/list_nulls.h                  |   18 ++
 include/net/netfilter/nf_conntrack.h        |    2 
 include/net/netfilter/nf_conntrack_ecache.h |  160 ++++++++++++---------
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netfilter/nf_conntrack_helper.h |    2 
 include/net/netns/conntrack.h               |    7 +
 net/netfilter/nf_conntrack_core.c           |  103 ++++++++++---
 net/netfilter/nf_conntrack_ecache.c         |  210 ++++++++++++++++++---------
 net/netfilter/nf_conntrack_helper.c         |   14 ++
 net/netfilter/nf_conntrack_netlink.c        |   68 +++++----
 10 files changed, 394 insertions(+), 192 deletions(-)

