From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 2/8] Add sanity checkings for ICMP
Date: Fri, 09 Dec 2005 11:40:41 +0900 (JST)
Message-ID: <200512090240.jB92egUK026258@toshiba.co.jp>
References: <4394229B.5030506@netfilter.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Dec__9_11_40_41_2005_460)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <4394229B.5030506@netfilter.org>
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

----Next_Part(Fri_Dec__9_11_40_41_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 05 Dec 2005 12:20:59 +0100

> Add proper checkings to avoid possible malformed ICMP conntracks. And return 
> to userspace -EINVAL in case of error.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
> ===================================================================
> --- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-12-04 03:35:50.000000000 +0100
> +++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-12-04 03:37:24.000000000 +0100
> @@ -288,10 +288,14 @@ nfattr_failure:
>  static int icmp_nfattr_to_tuple(struct nfattr *tb[],
>  				struct ip_conntrack_tuple *tuple)
>  {
> +	if (tuple->dst.u.icmp.type >= sizeof(valid_new)
> +	    || !valid_new[tuple->dst.u.icmp.type])
> +		return -EINVAL;
> +
>  	if (!tb[CTA_PROTO_ICMP_TYPE-1]
>  	    || !tb[CTA_PROTO_ICMP_CODE-1]
>  	    || !tb[CTA_PROTO_ICMP_ID-1])
> -		return -1;
> +		return -EINVAL;
>  
>  	tuple->dst.u.icmp.type = 
>  			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);

This checks ICMP type in tuple before putting it.
And it's better to use invmap instead of valid_new to allow Echo reply and
so on.

How about attached patch instead ?

# Please note that attached patch doesn't include your 1st patch.
# You can just replace your 2nd patch with it.

Regards,

-- Yasuyuki Kozakai


----Next_Part(Fri_Dec__9_11_40_41_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-ipctnetlink-check-icmp.patch"

[NETFILTER] ipctnetlink: Add sanity checkings for ICMP

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 2cae73ad22d11072b7787b70f5d38f443d110491
tree c6e05f2f2407f4c21ea48b990816bfce50c209e4
parent b01d2778bc7ca3049fed4eb4b216e063faa52477
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 02:01:49 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 02:01:49 +0900

 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |   43 +++++++++++++++-----------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 19cc550..30fc21d 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -47,20 +47,21 @@ static int icmp_pkt_to_tuple(const struc
 	return 1;
 }
 
+/* Add 1; spaces filled with 0. */
+static const u_int8_t invmap[] = {
+	[ICMP_ECHO] = ICMP_ECHOREPLY + 1,
+	[ICMP_ECHOREPLY] = ICMP_ECHO + 1,
+	[ICMP_TIMESTAMP] = ICMP_TIMESTAMPREPLY + 1,
+	[ICMP_TIMESTAMPREPLY] = ICMP_TIMESTAMP + 1,
+	[ICMP_INFO_REQUEST] = ICMP_INFO_REPLY + 1,
+	[ICMP_INFO_REPLY] = ICMP_INFO_REQUEST + 1,
+	[ICMP_ADDRESS] = ICMP_ADDRESSREPLY + 1,
+	[ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1
+};
+
 static int icmp_invert_tuple(struct ip_conntrack_tuple *tuple,
 			     const struct ip_conntrack_tuple *orig)
 {
-	/* Add 1; spaces filled with 0. */
-	static const u_int8_t invmap[]
-		= { [ICMP_ECHO] = ICMP_ECHOREPLY + 1,
-		    [ICMP_ECHOREPLY] = ICMP_ECHO + 1,
-		    [ICMP_TIMESTAMP] = ICMP_TIMESTAMPREPLY + 1,
-		    [ICMP_TIMESTAMPREPLY] = ICMP_TIMESTAMP + 1,
-		    [ICMP_INFO_REQUEST] = ICMP_INFO_REPLY + 1,
-		    [ICMP_INFO_REPLY] = ICMP_INFO_REQUEST + 1,
-		    [ICMP_ADDRESS] = ICMP_ADDRESSREPLY + 1,
-		    [ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1};
-
 	if (orig->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[orig->dst.u.icmp.type])
 		return 0;
@@ -110,17 +111,17 @@ static int icmp_packet(struct ip_conntra
 	return NF_ACCEPT;
 }
 
-static const u_int8_t valid_new[] = { 
-	[ICMP_ECHO] = 1,
-	[ICMP_TIMESTAMP] = 1,
-	[ICMP_INFO_REQUEST] = 1,
-	[ICMP_ADDRESS] = 1 
-};
-
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct ip_conntrack *conntrack,
 		    const struct sk_buff *skb)
 {
+	static const u_int8_t valid_new[] = { 
+		[ICMP_ECHO] = 1,
+		[ICMP_TIMESTAMP] = 1,
+		[ICMP_INFO_REQUEST] = 1,
+		[ICMP_ADDRESS] = 1 
+	};
+
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -291,7 +292,7 @@ static int icmp_nfattr_to_tuple(struct n
 	if (!tb[CTA_PROTO_ICMP_TYPE-1]
 	    || !tb[CTA_PROTO_ICMP_CODE-1]
 	    || !tb[CTA_PROTO_ICMP_ID-1])
-		return -1;
+		return -EINVAL;
 
 	tuple->dst.u.icmp.type = 
 			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
@@ -300,6 +301,10 @@ static int icmp_nfattr_to_tuple(struct n
 	tuple->src.u.icmp.id =
 			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 
+	if (tuple->dst.u.icmp.type >= sizeof(invmap)
+	    || !invmap[tuple->dst.u.icmp.type])
+		return -EINVAL;
+
 	return 0;
 }
 #endif

----Next_Part(Fri_Dec__9_11_40_41_2005_460)----
