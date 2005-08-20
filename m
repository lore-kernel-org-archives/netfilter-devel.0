From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 3/3]: Fix HW checksum handling in TCPMSS target
Date: Sat, 20 Aug 2005 04:12:46 +0200
Message-ID: <4306919E.4000602@trash.net>
References: <430689F7.5070305@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090306080109020201030705"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <430689F7.5070305@trash.net>
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
--------------090306080109020201030705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> @@ -114,9 +118,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
>  			opt[i+2] = (newmss & 0xff00) >> 8;
>  			opt[i+3] = (newmss & 0x00ff);
>  
> -			tcph->check = cheat_check(htons(oldmss)^0xFFFF,
> -						  htons(newmss),
> -						  tcph->check);
> +			if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
> +				tcph->check = cheat_check(htons(oldmss)^0xFFFF,
> +							  htons(newmss),
> +							  tcph->check);

On second thought, this is not a good idea, we need to update the
checksum in any case for forwarded packets. These patches should
be better.



--------------090306080109020201030705
Content-Type: text/x-patch;
 name="03-2.6.13.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-2.6.13.diff"

[NETFILTER]: Fix HW checksum handling in TCPMSS target

Most importantly, remove bogus BUG() in receive path.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f22a5a1a34286cde024bef21c75299a9ec8b564
tree 2ff9f0f32fd4cef9df2c121bf6772ab254f8ec41
parent b477e1c6defc1b0e1181350908714e11de5768dd
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 04:11:03 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 04:11:03 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -61,6 +61,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	if (!skb_ip_make_writable(pskb, (*pskb)->len))
 		return NF_DROP;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, out == NULL))
+		return NF_DROP;
+
 	iph = (*pskb)->nh.iph;
 	tcplen = (*pskb)->len - iph->ihl*4;
 
@@ -186,9 +190,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	       newmss);
 
  retmodified:
-	/* We never hw checksum SYN packets.  */
-	BUG_ON((*pskb)->ip_summed == CHECKSUM_HW);
-
 	(*pskb)->nfcache |= NFC_UNKNOWN | NFC_ALTERED;
 	return IPT_CONTINUE;
 }

--------------090306080109020201030705
Content-Type: text/x-patch;
 name="03-2.6.14.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-2.6.14.diff"

[NETFILTER]: Fix HW checksum handling in TCPMSS target

Most importantly, remove bogus BUG() in receive path.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7591ae593acedfcb570f713902b9dbd6b4ae3581
tree 92a7500452c3edd781680c93b93056d04ce66d87
parent f1929b1a15a9a7d9761b344d3522698bd656154e
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 04:10:18 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 04:10:18 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -61,6 +61,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	if (!skb_make_writable(pskb, (*pskb)->len))
 		return NF_DROP;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, out == NULL))
+		return NF_DROP;
+
 	iph = (*pskb)->nh.iph;
 	tcplen = (*pskb)->len - iph->ihl*4;
 
@@ -186,9 +190,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	       newmss);
 
  retmodified:
-	/* We never hw checksum SYN packets.  */
-	BUG_ON((*pskb)->ip_summed == CHECKSUM_HW);
-
 	return IPT_CONTINUE;
 }
 

--------------090306080109020201030705--
