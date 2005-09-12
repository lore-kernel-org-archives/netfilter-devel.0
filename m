From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: more nf_conntrack/ip_conntrack questions
Date: Mon, 12 Sep 2005 21:56:16 +0900 (JST)
Message-ID: <200509121256.j8CCuHOD026300@toshiba.co.jp>
References: <200509121129.j8CBT83a022872@toshiba.co.jp>
	<200509121141.j8CBfHp1003079@toshiba.co.jp>
	<43256ED8.2090500@ufomechanic.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Sep_12_21_56_16_2005_440)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <43256ED8.2090500@ufomechanic.net>
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

----Next_Part(Mon_Sep_12_21_56_16_2005_440)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Amin Azez <azez@ufomechanic.net>
Date: Mon, 12 Sep 2005 13:04:40 +0100

> Sure, I don't have any fault with the structures, just the way the
> sizeof is measured for initial zero-ing.

Oh, it's reasonable. Thank you for notice.

Harald, please apply this patch.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Mon_Sep_12_21_56_16_2005_440)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="tuple-l3size.patch"

[NETFILTER] simplifies calculation of size of l3 part in tuple

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 0a330af3412fbfaecd694acd572000f29f2a407c
tree 76e0dc454fa6723e98b1fc423fbb222985612960
parent b24ffb6730679e783e77eb3bc721ddd50fdf9ec7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 12 Sep 2005 21:49:32 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 12 Sep 2005 21:49:32 +0900

 include/linux/netfilter/nf_conntrack_tuple.h |    6 ++----
 net/netfilter/nf_conntrack_l3proto_generic.c |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tuple.h b/include/linux/netfilter/nf_conntrack_tuple.h
--- a/include/linux/netfilter/nf_conntrack_tuple.h
+++ b/include/linux/netfilter/nf_conntrack_tuple.h
@@ -104,10 +104,8 @@ struct nf_conntrack_tuple
         do {                                                    	\
                 (tuple)->src.u.all = 0;                         	\
                 (tuple)->dst.u.all = 0;                         	\
-		memset((tuple)->src.u3.all, 0,				\
-		       sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE);		\
-		memset((tuple)->dst.u3.all, 0,				\
-		       sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE);		\
+		memset(&(tuple)->src.u3, 0, sizeof((tuple)->src.u3));	\
+		memset(&(tuple)->dst.u3, 0, sizeof((tuple)->dst.u3));	\
         } while (0)
 
 #ifdef __KERNEL__
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -43,8 +43,8 @@ DECLARE_PER_CPU(struct nf_conntrack_stat
 static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 				struct nf_conntrack_tuple *tuple)
 {
-	memset(tuple->src.u3.all, 0, NF_CT_TUPLE_L3SIZE);
-	memset(tuple->dst.u3.all, 0, NF_CT_TUPLE_L3SIZE);
+	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
+	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
 	return 1;
 }
@@ -52,8 +52,8 @@ static int generic_pkt_to_tuple(const st
 static int generic_invert_tuple(struct nf_conntrack_tuple *tuple,
 			   const struct nf_conntrack_tuple *orig)
 {
-	memset(tuple->src.u3.all, 0, NF_CT_TUPLE_L3SIZE);
-	memset(tuple->dst.u3.all, 0, NF_CT_TUPLE_L3SIZE);
+	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
+	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
 
 	return 1;
 }

----Next_Part(Mon_Sep_12_21_56_16_2005_440)----
