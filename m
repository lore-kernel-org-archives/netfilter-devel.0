From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: nf_conntrack_sip: check sname != NULL before
	calling strncmp
Date: Tue, 14 Aug 2007 18:40:16 +0200 (MEST)
Message-ID: <20070814164007.14668.94133.sendpatchset@localhost.localdomain>
References: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_sip: check sname != NULL before calling strncmp

The check got lost during the conversion to nf_conntrack.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c58af8c25d20e59644356f78e055eeba9edb8aae
tree c7c95d0ba93d86f6ec33dc2ae12e532dc1ce77ab
parent 4cbeda3b69e71c535ea820f5a94f4232598e3eea
author Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:01 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:01 +0200

 net/netfilter/nf_conntrack_sip.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1276a44..5cc9636 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -330,7 +330,8 @@ int ct_sip_get_info(struct nf_conn *ct,
 
 	while (dptr <= limit) {
 		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
-		    (strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
+		    (hnfo->sname == NULL ||
+		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
 			dptr++;
 			continue;
 		}
