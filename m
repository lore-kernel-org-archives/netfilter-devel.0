From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: xt_connbytes: fix division by zero
Date: Tue, 30 Jan 2007 19:16:28 +0100 (MET)
Message-ID: <20070130181627.25041.43611.sendpatchset@localhost.localdomain>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_connbytes: fix division by zero

When the packet counter of a connection is zero a division by zero
occurs in div64_64(). Fix that by using zero as average value, which
is correct as long as the packet counter didn't overflow, at which
point we have lost anyway.

Additionally we're probably going to go back to 64 bit counters
in 2.6.21.

Based on patch from Jonas Berlin <xkr47@outerspace.dyndns.org>,
with suggestions from KOVACS Krisztian <hidden@balabit.hu>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0893450b69979cc8ee6ef9335bdef4f442f21e8e
tree 4dd285255056ce84002e77f9cde926f26c6aefff
parent 9999a622b03b44e395c8388ff9ab99f99726dce0
author Patrick McHardy <kaber@trash.net> Fri, 26 Jan 2007 18:22:35 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 28 Jan 2007 00:25:03 +0100

 net/netfilter/xt_connbytes.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d93cb09..5e32dfa 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -52,6 +52,8 @@ match(const struct sk_buff *skb,
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
+	u_int64_t bytes = 0;
+	u_int64_t pkts = 0;
 	const struct ip_conntrack_counter *counters;
 
 	if (!(counters = nf_ct_get_counters(skb)))
@@ -89,29 +91,22 @@ match(const struct sk_buff *skb,
 	case XT_CONNBYTES_AVGPKT:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
-					counters[IP_CT_DIR_ORIGINAL].packets);
+			bytes = counters[IP_CT_DIR_ORIGINAL].bytes;
+			pkts  = counters[IP_CT_DIR_ORIGINAL].packets;
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what = div64_64(counters[IP_CT_DIR_REPLY].bytes,
-					counters[IP_CT_DIR_REPLY].packets);
+			bytes = counters[IP_CT_DIR_REPLY].bytes;
+			pkts  = counters[IP_CT_DIR_REPLY].packets;
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			{
-				u_int64_t bytes;
-				u_int64_t pkts;
-				bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
-					counters[IP_CT_DIR_REPLY].bytes;
-				pkts = counters[IP_CT_DIR_ORIGINAL].packets+
-					counters[IP_CT_DIR_REPLY].packets;
-
-				/* FIXME_THEORETICAL: what to do if sum
-				 * overflows ? */
-
-				what = div64_64(bytes, pkts);
-			}
+			bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
+				counters[IP_CT_DIR_REPLY].bytes;
+			pkts  = counters[IP_CT_DIR_ORIGINAL].packets +
+				counters[IP_CT_DIR_REPLY].packets;
 			break;
 		}
+		if (pkts != 0)
+			what = div64_64(bytes, pkts);
 		break;
 	}
 
