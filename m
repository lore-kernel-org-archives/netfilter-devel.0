From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_sip: add missing message types
	containing RTP info
Date: Fri, 22 Jun 2007 13:47:32 +0200 (MEST)
Message-ID: <20070622114657.14839.85647.sendpatchset@localhost.localdomain>
References: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_sip: add missing message types containing RTP info

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 845abcbe6c8ef918b3499e820aafe4d26119c737
tree a07a4b377afbcfcb3cae6c93e50fc09c3006dd29
parent 188e1f81ba31af1b65a2f3611df4c670b092bbac
author Jerome Borsboom <j.borsboom@erasmusmc.nl> Mon, 18 Jun 2007 14:56:42 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Jun 2007 14:56:42 +0200

 net/netfilter/nf_conntrack_sip.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 7aaa8c9..1b5c6c1 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -442,6 +442,9 @@ static int sip_help(struct sk_buff **pskb,
 
 	/* RTP info only in some SDP pkts */
 	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) != 0 &&
+	    memcmp(dptr, "UPDATE", sizeof("UPDATE") - 1) != 0 &&
+	    memcmp(dptr, "SIP/2.0 180", sizeof("SIP/2.0 180") - 1) != 0 &&
+	    memcmp(dptr, "SIP/2.0 183", sizeof("SIP/2.0 183") - 1) != 0 &&
 	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) != 0) {
 		goto out;
 	}
