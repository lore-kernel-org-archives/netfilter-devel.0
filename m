From: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Subject: [PATCH] netfilter: changed generic l4 protocol number
Date: Mon, 26 Jan 2009 15:57:14 +0100
Message-ID: <200901261557.15172.christoph.paasch@student.uclouvain.be>
References: <200901241622.36634.christoph.paasch@student.uclouvain.be> <497DB865.8050003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.sgsi.ucl.ac.be ([130.104.5.77]:57013 "EHLO
	smtp3.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZAZO6I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:58:08 -0500
In-Reply-To: <497DB865.8050003@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


0 is used by Hop-by-hop header and so this may cause confusion.
255 is stated as 'Reserved' by IANA.

Signed-off-by: Christoph Paasch <christoph.paasch@student.uclouvain.be>
---
 net/netfilter/nf_conntrack_proto_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c 
b/net/netfilter/nf_conntrack_proto_generic.c
index 4be80d7..829374f 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -92,7 +92,7 @@ static struct ctl_table generic_compat_sysctl_table[] = {
 struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_mostly =
 {
        .l3proto                = PF_UNSPEC,
-       .l4proto                = 0,
+       .l4proto                = 255,
        .name                   = "unknown",
        .pkt_to_tuple           = generic_pkt_to_tuple,
        .invert_tuple           = generic_invert_tuple,
--
1.5.6.3

