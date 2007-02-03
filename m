From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 56/59] NETFILTER: xt_connbytes: fix division by zero
Date: Fri, 02 Feb 2007 18:36:00 -0800
Message-ID: <20070203024706.178736000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946264AbXBCCmn@vger.kernel.org>
Content-Disposition: inline; filename=netfilter-xt_connbytes-fix-division-by-zero.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

When the packet counter of a connection is zero a division by zero
occurs in div64_64(). Fix that by using zero as average value, which
is correct as long as the packet counter didn't overflow, at which
point we have lost anyway.

Additionally we're probably going to go back to 64 bit counters
in 2.6.21.

Based on patch from Jonas Berlin <xkr47@outerspace.dyndns.org>,
with suggestions from KOVACS Krisztian <hidden@balabit.hu>.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/netfilter/xt_connbytes.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- linux-2.6.19.2.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6.19.2/net/netfilter/xt_connbytes.c
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
 

--
