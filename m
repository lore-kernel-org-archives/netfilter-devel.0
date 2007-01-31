From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: xt_connbytes: fix division by zero
Date: Wed, 31 Jan 2007 01:27:29 +0100
Message-ID: <45BFE271.6000704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050307060809060303080101"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------050307060809060303080101
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Attached is another netfilter patch for -stable, fixing a division
by zero in the connbytes match, affecting kernels since about 2.6.16.

Please apply, thanks.


--------------050307060809060303080101
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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
commit 70806eca525b54e46be5fbdc5c7ad4f9a8cf5225
tree d400adc22f9f46190fb1aaaa0d922c114194f9d0
parent 3ac4e26b2cc43180661453851174f40a1292da09
author Patrick McHardy <kaber@trash.net> Wed, 31 Jan 2007 01:23:01 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 31 Jan 2007 01:23:01 +0100

 net/netfilter/xt_connbytes.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index dcc497e..5e9af03 100644
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
 

--------------050307060809060303080101--
