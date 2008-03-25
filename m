From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/32]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc
Date: Tue, 25 Mar 2008 15:14:56 +0100 (MET)
Message-ID: <20080325141455.10539.18662.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32898 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYCYOO5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:14:57 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c17414dd75203d003a75a024de4ad736a64bc3e5
tree 061681c3626d0d535020efecbb578080883820a9
parent ee8406f54b255b347c08802fb39c13c2865234dc
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:39 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:39 +0100

 net/netfilter/nf_conntrack_expect.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 740d94d..4c05a58 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -475,6 +475,10 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
 		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
 				       expect->tuple.dst.protonum));
+
+	if (expect->flags & NF_CT_EXPECT_PERMANENT)
+		seq_printf(s, "PERMANENT ");
+
 	return seq_putc(s, '\n');
 }
 
