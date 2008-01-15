From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/38]: nf_conntrack_{tcp,sctp}: mark state table const
Date: Tue, 15 Jan 2008 07:19:42 +0100 (MET)
Message-ID: <20080115061937.3184.43803.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYAOGTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:43 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_{tcp,sctp}: mark state table const

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 644ca177a54fc8a0e3745955475cccad5c799aae
tree db5a1a2d5518c94a46a898c02c71a0d800e874b6
parent e98b968b91b444bb9af1547818b9601419150dba
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:24 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:24 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 9296fd2..47c1dbe 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -110,7 +110,7 @@ cookie echoed to closed.
 */
 
 /* SCTP conntrack state transitions */
-static enum sctp_conntrack sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
+static const enum sctp_conntrack sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1d496b9..be19bd9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -149,7 +149,7 @@ enum tcp_bit_set {
  *	if they are invalid
  *	or we do not support the request (simultaneous open)
  */
-static enum tcp_conntrack tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
+static const enum tcp_conntrack tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	{
 /* ORIGINAL */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
