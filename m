From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: H.323 helper: fix endless loop caused by invalid
	TPKT len
Date: Tue,  2 May 2006 22:48:04 +0200 (MEST)
Message-ID: <20060502204804.7610.79065.sendpatchset@localhost.localdomain>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: fix endless loop caused by invalid TPKT len

When the TPKT len included in the packet is below the lowest valid value
of 4 an underflow occurs which results in an endless loop.

Found by testcase 0000058 from the PROTOS c07-h2250v4 testsuite.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ce641a7a27c17eaffbc769ef81d29c3925214655
tree 224c05dcc5fddb2bb8bc08f3cf01394d35605ca9
parent 532f57da408c5a5710075d17047e2d97bdfd22f3
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:57:27 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:57:27 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 2c2fb70..518f581 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -162,6 +162,8 @@ static int get_tpkt_data(struct sk_buff 
 
 	/* Validate TPKT length */
 	tpktlen = tpkt[2] * 256 + tpkt[3];
+	if (tpktlen < 4)
+		goto clear_out;
 	if (tpktlen > tcpdatalen) {
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */
