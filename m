From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 01:35:53 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4159F559.3040400@trash.net>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090300080703070408030700"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20040928220532.GN29961@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090300080703070408030700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:

>The conntrack message basically means that at NF_IP_PRE_ROUTING we
>suddenly see fragmented packets.  This "can never happen" since at the
>same PRE_ROUTING hook we defragment just before
>via ip_conntrack_defrag() -> ip_ct_gather_frags() -> ip_defrag()
>  
>

Here is the patch. Untracked and already tracked (loopback) packets
are not defragmented, but the check in ip_conntrack_in for
untracked/already tracked is after the check for fragments.
This patch moves it up.




--------------090300080703070408030700
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/29 01:26:22+02:00 kaber@coreworks.de 
#   [NETFILTER]: move check for already tracked/untracked before fragment check
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/29 01:25:49+02:00 kaber@coreworks.de +6 -6
#   [NETFILTER]: move check for already tracked/untracked before fragment check
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-29 01:27:34 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-29 01:27:34 +02:00
@@ -688,6 +688,12 @@
 	int set_reply;
 	int ret;
 
+	/* Previously seen (loopback or untracked)?  Ignore. */
+	if ((*pskb)->nfct) {
+		CONNTRACK_STAT_INC(ignore);
+		return NF_ACCEPT;
+	}
+
 	/* Never happen */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
 		if (net_ratelimit()) {
@@ -714,12 +720,6 @@
 		       (*pskb)->sk, (*pskb)->pkt_type);
 	}
 #endif
-
-	/* Previously seen (loopback or untracked)?  Ignore. */
-	if ((*pskb)->nfct) {
-		CONNTRACK_STAT_INC(ignore);
-		return NF_ACCEPT;
-	}
 
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 

--------------090300080703070408030700--
