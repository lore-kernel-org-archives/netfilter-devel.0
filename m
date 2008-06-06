From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 10/11: nf_conntrack: remove unnecessary function declaration
Date: Fri,  6 Jun 2008 17:18:01 +0200 (MEST)
Message-ID: <20080606151759.25286.63716.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbYFFPSD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:18:03 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack: remove unnecessary function declaration

This patch removes nf_ct_ipv4_ct_gather_frags() method declaration from
include/net/netfilter/ipv4/nf_conntrack_ipv4.h, since it is unused in
the Linux kernel.

Signed-off-by: Rami Rosen <ramirose@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e0f7130611c678e99a237ecdfb065daae1e677bf
tree 53fdf07e06b6742d03b53d0be0b3aeb5a0f81228
parent ddafe2d8dec88f9fb0c9de1f9eea0dd994d97a95
author Rami Rosen <ramirose@gmail.com> Fri, 06 Jun 2008 17:11:05 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 9bf0598..7573d52 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -9,8 +9,6 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
-/* Returns new sk_buff, or NULL */
-struct sk_buff *nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 
