From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/41]: nf_conntrack_sip: clear address in parse_addr()
Date: Mon, 14 Apr 2008 12:16:38 +0200 (MEST)
Message-ID: <20080414101635.32717.22079.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYDNKQk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:40 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: clear address in parse_addr()

Some callers pass uninitialized structures, clear the address to make
sure later comparisions work properly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ced3e6faece20aca754a2497d803f4494f20dd9
tree 34b8e752fa47ea84148e32ae797a23c2581a8479
parent 598490926dcfaf23b34ceb0330b03767e2c8b25c
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:46 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:46 +0200

 net/netfilter/nf_conntrack_sip.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index da5dec6..f3915f8 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -145,6 +145,7 @@ static int parse_addr(const struct nf_conn *ct, const char *cp,
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int ret = 0;
 
+	memset(addr, 0, sizeof(*addr));
 	switch (family) {
 	case AF_INET:
 		ret = in4_pton(cp, limit - cp, (u8 *)&addr->ip, -1, &end);
