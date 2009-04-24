From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: conntrack: fix EINVAL during DCCP loading
Date: Fri, 24 Apr 2009 12:30:53 +0200
Message-ID: <20090424103053.30250.7275.stgit@Decadence>
References: <20090424102534.30250.37215.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbZDXKbB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:31:01 -0400
In-Reply-To: <20090424102534.30250.37215.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

# modprobe nf_conntrack_proto_dccp
FATAL: Error inserting nf_conntrack_proto_dccp (/lib/modules/2.6.30-rc1-00666-gd4b5cc5/kernel/net/netfilter/nf_conntrack_proto_dccp.ko): Invalid argument

This patch fixes a problem during introduced in commit
a400c30edb1958ceb53c4b8ce78989189b36df47.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_proto_dccp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 3c266e6..8e757dd 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -790,6 +790,7 @@ static struct nf_conntrack_l4proto dccp_proto6 __read_mostly = {
 	.print_conntrack	= dccp_print_conntrack,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.to_nlattr		= dccp_to_nlattr,
+	.nlattr_size		= dccp_nlattr_size,
 	.from_nlattr		= nlattr_to_dccp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,

