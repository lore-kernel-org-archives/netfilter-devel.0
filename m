From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/38]: nf_conntrack_{tcp,sctp}: shrink state table
Date: Tue, 15 Jan 2008 07:19:43 +0100 (MET)
Message-ID: <20080115061938.3184.96176.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYAOGTo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:44 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_{tcp,sctp}: shrink state table

The TCP and SCTP conntrack state transition tables only holds
small numbers, but gcc uses 4 byte per entry for the enum. Switching
to an u8 reduces the size from 480 to 120 bytes for TCP and from
576 to 144 bytes for SCTP.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 310e65023fa9efc6b18c32f3146cc6c24e6b2c33
tree 1cbfef8fbfb6372a12d204531c8b3a83c8f85c3f
parent 644ca177a54fc8a0e3745955475cccad5c799aae
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:25 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 47c1dbe..9a5ec53 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -110,7 +110,7 @@ cookie echoed to closed.
 */
 
 /* SCTP conntrack state transitions */
-static const enum sctp_conntrack sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
+static const u8 sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index be19bd9..dbd8f84 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -149,7 +149,7 @@ enum tcp_bit_set {
  *	if they are invalid
  *	or we do not support the request (simultaneous open)
  */
-static const enum tcp_conntrack tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
+static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	{
 /* ORIGINAL */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
