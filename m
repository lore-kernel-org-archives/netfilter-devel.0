From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Cleanup returnvalues of protocolhandlers
Date: Mon, 20 Sep 2004 10:11:41 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414E90BD.6090005@trash.net>
References: <1095597972.8380.16.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010403010309070703050102"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1095597972.8380.16.camel@tux.rsn.bth.se>
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
--------------010403010309070703050102
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Martin Josefsson wrote:

>Hi Patrick
>
>Here's the second of two patches based on Pablo Neiras patch.
>
>This adds new defines to be returned from conntrack protocol modules in
>order to make it clear what they want. Most importantly, they get rid of
>the confusing mixing of positive and negative returnvalues.
>

We also need this patch on top of the last one to avoid ip_conntrack_in
from returning CONNTRACK_CONT (-1) to nf_hook_slow.

Regards
Patrick

>diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c
>--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-11 13:28:41.000000000 +0200
>+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-11 13:43:12.000000000 +0200
>@@ -786,14 +786,14 @@ unsigned int ip_conntrack_in(unsigned in
> 
> 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
> 
>-	/* It may be an special packet, error, unclean...
>-	 * inverse of the return code tells to the netfilter
>-	 * core what to do with the packet. */
>-	if (proto->error != NULL 
>-	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0) {
>-		CONNTRACK_STAT_INC(error);
>-		CONNTRACK_STAT_INC(invalid);
>-		return -ret;
>+	/* It may be an special packet, error, unclean... */
>+	if (proto->error != NULL) {
>+		ret = proto->error(*pskb, &ctinfo, hooknum);
>+		if (ret != CONNTRACK_CONT) {
>+			CONNTRACK_STAT_INC(error);
>+			CONNTRACK_STAT_INC(invalid);
>+			return ret;
>+		}
> 	}
> 
> 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
>@@ -811,16 +811,14 @@ unsigned int ip_conntrack_in(unsigned in
> 	IP_NF_ASSERT((*pskb)->nfct);
> 
> 	ret = proto->packet(ct, *pskb, ctinfo);
>-	if (ret < 0) {
>-		/* Invalid: inverse of the return code tells
>-		 * the netfilter core what to do*/
>+	if (ret != CONNTRACK_CONT) {
> 		nf_conntrack_put((*pskb)->nfct);
> 		(*pskb)->nfct = NULL;
> 		CONNTRACK_STAT_INC(invalid);
>-		return -ret;
>+		return ret;
> 	}
> 
>-	if (ret != NF_DROP && ct->helper) {
>+	if (ct->helper != NULL) {
> 		ret = ct->helper->help(*pskb, ct, ctinfo);
> 		if (ret == -1) {
> 			/* Invalid */
>
>  
>


--------------010403010309070703050102
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/20 10:05:19+02:00 kaber@coreworks.de 
#   [NETFILTER]: Fix invalid return values from ip_conntrack_in
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/20 10:04:56+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix invalid return values from ip_conntrack_in
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 10:08:05 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 10:08:05 +02:00
@@ -767,7 +767,7 @@
 	if (set_reply)
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
 
-	return ret;
+	return NF_ACCEPT;
 }
 
 int invert_tuplepr(struct ip_conntrack_tuple *inverse,

--------------010403010309070703050102--
