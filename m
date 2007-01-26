From: Patrick McHardy <kaber@trash.net>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Fri, 26 Jan 2007 18:24:00 +0100
Message-ID: <45BA3930.9070804@trash.net>
References: <45AF5318.8040204@outerspace.dyndns.org>	<45AF7617.8010202@netfilter.org>	<45AF7861.5000201@outerspace.dyndns.org>
	<200701181522.37984@nienna>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090907070905030304040103"
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200701181522.37984@nienna>
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
--------------090907070905030304040103
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

KOVACS Krisztian wrote:
>   Hi,
> 
> On Thursday 18 January 2007 14:38, Jonas Berlin wrote:
> 
>>| Better check that divisor must be != 0 inside div64_64.
>>
>>I initially suggested that too and would have renamed the function to
>>div64_64_safe() or similar in the same go.. but Hidden (on irc) thought
>>it was up to the caller to do the checking, and I felt he probably
>>knows the kernel way of thinking better than me and succumbed. :) I
>>think it's up to Patrick, I'm really only concerned with that it gets
>>fixed :) If Patrick so requests, I'll redo it the other way..
> 
> 
>   Not that it matters a lot, but I thought determining what to do if there 
> have been no packets yet does not belong to the division routine 
> logically. For me at least, it would introduce some kind of obscurity: at 
> a first glance you won't be able to see what happens if packets==0, 
> you'll have to scroll up to the div() function. Choosing zero as the 
> average packet length in the corner case is appropriate only because 
> that's whay usually makes sense in your ruleset. (For example if you use 
> connbytes to classify traffic into bulk and interactive categories based 
> on the average packet length, 0 as the "fallback" value is OK because it 
> means that a brand new connection is considered interactive.)
> 
>   I guess this is a matter of personal preference: one way it's less code, 
> the other way it's easier to read -- at least for me. Of course the only 
> thing that matters is having this bug fixed, as it's quite ugly indeed.


I agree that having the caller check it is easier to read.
I'm wondering what value to use when packets == 0 though,
it can't happen for the first packet of a connection since
it has already been accounted for before we can match, so
the packets counter must have overflown at least once (and
the byte counter at least as often as the packet counter).

Well, I guess it doesn't matter since we've lost anyway,
so I've queued this patch.

--------------090907070905030304040103
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: xt_connbytes: fix division by zero after overflow

When the packet counter of a connection overflows a division by
zero occurs in div64_64(). At that point we can't give calculate
accurate values anymore, but at least make sure it doesn't crash.

Additionally we're probably going to go back to 64 bit counters
in 2.6.21.

Based on patch from Jonas Berlin <xkr47@outerspace.dyndns.org>,
with suggestions from KOVACS Krisztian <hidden@balabit.hu>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 57a227273018d7b507d01a67392a6faa082350e4
tree 01d37699758bd05f483b86ebe56405005c2e27c4
parent 9999a622b03b44e395c8388ff9ab99f99726dce0
author Patrick McHardy <kaber@trash.net> Fri, 26 Jan 2007 18:22:35 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 26 Jan 2007 18:23:33 +0100

 net/netfilter/xt_connbytes.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d93cb09..6314601 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -53,6 +53,8 @@ match(const struct sk_buff *skb,
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
 	const struct ip_conntrack_counter *counters;
+	u_int64_t bytes;
+	u_int64_t pkts;
 
 	if (!(counters = nf_ct_get_counters(skb)))
 		return 0; /* no match */
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
 

--------------090907070905030304040103--
