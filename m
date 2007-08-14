From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: nf_conntrack_sip: fix SIP-URI parsing
Date: Tue, 14 Aug 2007 18:40:17 +0200 (MEST)
Message-ID: <20070814164009.14668.906.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_sip: fix SIP-URI parsing

The userinfo component of a SIP-URI is optional, continue parsing at the
beginning of the SIP-URI in case its not found.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 492d0e43049e7f420c1c64044ab57abf278fbead
tree d5b5da1b2109b78f28fa8748bcb33e573be85e5a
parent c58af8c25d20e59644356f78e055eeba9edb8aae
author Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:25 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:37:25 +0200

 net/netfilter/nf_conntrack_sip.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5cc9636..d449fa4 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -295,6 +295,7 @@ static int epaddr_len(struct nf_conn *ct, const char *dptr,
 static int skp_epaddr_len(struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {
+	const char *start = dptr;
 	int s = *shift;
 
 	/* Search for @, but stop at the end of the line.
@@ -309,8 +310,10 @@ static int skp_epaddr_len(struct nf_conn *ct, const char *dptr,
 	if (dptr <= limit && *dptr == '@') {
 		dptr++;
 		(*shift)++;
-	} else
+	} else {
+		dptr = start;
 		*shift = s;
+	}
 
 	return epaddr_len(ct, dptr, limit, shift);
 }
