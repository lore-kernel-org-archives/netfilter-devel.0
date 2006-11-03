From: Patrick McHardy <kaber@trash.net>
Subject: Re: problem with connection tracking with fragmentation needed icmp
 error
Date: Fri, 03 Nov 2006 11:44:16 +0100
Message-ID: <454B1D80.2010500@trash.net>
References: <013a01c6fe4b$c5032dc0$4c01a8c0@elitecore26>	<454B17C8.1010904@trash.net>
	<022501c6ff34$f842d6b0$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070307080107040806010803"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nishit Shah <nishit@elitecore.com>
In-Reply-To: <022501c6ff34$f842d6b0$4c01a8c0@elitecore26>
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
--------------070307080107040806010803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Nishit Shah wrote:
> Well,
>             router and firewall both running with kernel 2.6.16.13 and one
> more thing, i got invalid state on firewall not on router, i am not running
> conntrack on router machine.(i guess firewall machine is not able to relate
> this error msg with existing conntrack entry)

The reason for this is that ICMP connection tracking entries get
destroyed once a reply has been seen for every outstanding request.
So when the ICMP error arrives there is no connection it relates
to, so it is considered invalid. We could change this to keep
it alive for some short period of time.

Does this patch help?

--------------070307080107040806010803
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 295b6fa..b62f8bb 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -21,6 +21,7 @@ #include <linux/netfilter_ipv4/ip_conntr
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
+unsigned int ip_ct_icmp_timeout_replied __read_mostly = HZ + HZ/2;
 unsigned int ip_ct_icmp_timeout __read_mostly = 30*HZ;
 
 #if 0
@@ -98,9 +99,9 @@ static int icmp_packet(struct ip_conntra
            means this will only run once even if count hits zero twice
            (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		if (atomic_dec_and_test(&ct->proto.icmp.count))
+			ip_ct_refresh_acct(ct, ctinfo, skb,
+					   ip_ct_icmp_timeout_replied);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);

--------------070307080107040806010803--
