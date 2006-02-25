From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: avoid long expectation chains
Date: Sat, 25 Feb 2006 10:08:16 +0100
Message-ID: <44001E80.8080208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090701030303040904010308"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
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

This is a multi-part message in MIME format.
--------------090701030303040904010308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This is the last patch for now, the others still need a bit more work.

--------------090701030303040904010308
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

[NETFILTER]: H.323 helper: avoid long expectation chains

The RAS helper can exect new RAS connections when Gatekeeper discovery
is performed. This could lead to a situation where there is a long
chain of master conntracks which is recursively freed by destroy_conntrack
or which consumes lots of memory with only a single hashed conntrack,
decreasing chances of beeing evicted under memory pressure.

Avoid creating RAS expectations for already expected connections.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 74dc9a728dc33fab70b73ee30aca44bd2a0259ec
tree 6d3d7b250377b8587c9e32236ac22d91f4fb3300
parent 134aa8950c66de37bd644e7826c4d5cb1f1535ab
author Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 20:22:10 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 20:22:10 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 5692b2f..fa6e73f 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -1091,6 +1091,10 @@ static int process_gcf(struct sk_buff **
 	    port == ntohs(ct->tuplehash[dir].tuple.src.u.udp.port))
 		return 0;
 
+	/* Avoid RAS expectation loops. A GCF is never expected. */
+	if (test_bit(IPS_EXPECTED_BIT, &ct->status))
+		return 0;
+
 	/* Need new expect */
 	if ((exp = ip_conntrack_expect_alloc(ct)) == NULL)
 		return -1;

--------------090701030303040904010308--
