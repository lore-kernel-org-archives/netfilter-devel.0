From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/33]: sip conntrack: make header shortcuts optional
Date: Wed, 29 Nov 2006 03:09:18 +0100 (MET)
Message-ID: <20061129020918.21082.25744.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: sip conntrack: make header shortcuts optional

Not every header has a shortcut, so make them optional instead
of searching for the same string twice.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 69e5ca0b3c45fc0831ca7d401bba4d791681e92b
tree 738a21a179c76df246e958b92a284d345ed0b101
parent 74ea88e39e990542e1a7492edb3bc4f0bc254384
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:30 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:50 +0100

 net/ipv4/netfilter/ip_conntrack_sip.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index a9c0d1d..0a6a13c 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -72,8 +72,6 @@ static struct sip_header_nfo ct_sip_hdrs
 	[POS_REQ_HEADER] = { 	/* SIP Requests headers */
 		.lname		= "sip:",
 		.lnlen		= sizeof("sip:") - 1,
-		.sname		= "sip:",
-		.snlen		= sizeof("sip:") - 1, /* yes, i know.. ;) */
 		.ln_str		= "@",
 		.ln_strlen	= sizeof("@") - 1,
 		.match_len	= epaddr_len
@@ -286,7 +284,8 @@ int ct_sip_get_info(const char *dptr, si
 
 	while (dptr <= limit) {
 		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
-		    (strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
+		    (hinfo->sname == NULL ||
+		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
 			dptr++;
 			continue;
 		}
