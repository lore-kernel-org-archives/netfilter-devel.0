From: Pablo Neira <pablo@eurodev.net>
Subject: Re: REJECT using invalid data
Date: Tue, 07 Dec 2004 23:14:44 +0100
Message-ID: <41B62B54.8060003@eurodev.net>
References: <20041207010130.GC4757@netnation.com>
	<41B58EE3.5050709@eurodev.net>
	<20041207172823.GA31513@netnation.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030302070302060705040307"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Kirby <sim@netnation.com>
In-Reply-To: <20041207172823.GA31513@netnation.com>
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
--------------030302070302060705040307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Simon Kirby wrote:

>On Tue, Dec 07, 2004 at 12:07:15PM +0100, Pablo Neira wrote:
>  
>
>>not really, my ruleset drops it, actually another rule here is 
>>previously logging it.
>>
>>-A INPUT -m state --state INVALID -j DROP
>>    
>>
>
>That's all fine and dandy, except that we can't use state tracking in our
>configuration because of asymmetric routing (which is required due to
>BGP).  This is fairly common, and not an incorrect setup.
>  
>

Hm I thought that you were using state tracking... I agree your setup is 
correct.

>>>REJECT can be set to reject with a
>>>tcp-reset or some ICMP response at this point.  If so, it will actually
>>>use the possibly-incorrect information from the bad TCP packet and send a
>>>rejection packet.  As far as I can tell, this is a bug.
>>>      
>>>
>>yes, that's a bug, but in your ruleset, people should log/drop/let 
>>    
>>
>
>No!  It is not a bug in our ruleset, it is a bug in REJECT.
>
>It is incorrect to reply to packet layers that have bad checksums.
>REJECT in this case must DROP, because anything else would be broken.
>  
>
Now I see, if state tracking is not enable there's no way to avoid this 
problem. But I guess that we should drop all malformed packets, not only 
those which have bad checksums. Would you like to give a try to the 
patch attached?

--
Pablo

--------------030302070302060705040307
Content-Type: text/x-patch;
 name="reject.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reject.patch"

===== net/ipv4/netfilter/ipt_REJECT.c 1.32 vs edited =====
--- 1.32/net/ipv4/netfilter/ipt_REJECT.c	2004-11-13 14:41:07 +01:00
+++ edited/net/ipv4/netfilter/ipt_REJECT.c	2004-12-07 23:03:29 +01:00
@@ -352,6 +352,76 @@
 		ip_finish_output);
 }	
 
+#define TH_FIN  0x01
+#define TH_SYN  0x02
+#define TH_RST  0x04
+#define TH_PUSH 0x08
+#define TH_ACK  0x10
+#define TH_URG  0x20
+#define TH_ECE  0x40
+#define TH_CWR  0x80
+
+/* table of valid flag combinations - ECE and CWR are always valid */
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+{
+	[TH_SYN]                        = 1,
+	[TH_SYN|TH_ACK]                 = 1,
+	[TH_RST]                        = 1,
+	[TH_RST|TH_ACK]                 = 1,
+	[TH_RST|TH_ACK|TH_PUSH]         = 1,
+	[TH_FIN|TH_ACK]                 = 1,
+	[TH_ACK]                        = 1,
+	[TH_ACK|TH_PUSH]                = 1,
+	[TH_ACK|TH_URG]                 = 1,
+	[TH_ACK|TH_URG|TH_PUSH]         = 1,
+	[TH_FIN|TH_ACK|TH_PUSH]         = 1,
+	[TH_FIN|TH_ACK|TH_URG]          = 1,
+	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]  = 1,
+};
+
+/* Protect against broken packets. Reduced version of tcp_error, taken 
+ * from tcp connection tracking. 
+ * 
+ * If someone else needs this piece of code, we should move this elsewhere 
+ * instead of copying it over and over again --pablo 
+ */
+static int tcp_error(struct sk_buff *skb, unsigned int hooknum)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct tcphdr _tcph, *th;
+	unsigned int tcplen = skb->len - iph->ihl * 4;
+	u_int8_t tcpflags;
+
+	/* Smaller that minimal TCP header? */
+	th = skb_header_pointer(skb, iph->ihl * 4,
+				sizeof(_tcph), &_tcph);
+	if (th == NULL) 
+		return 1;
+  
+	/* Not whole TCP header or malformed packet */
+	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) 
+		return 1;
+  
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the semantic of CHECKSUM_HW is different there 
+	 * and moreover root might send raw packets.
+	 */
+	/* FIXME: Source route IP option packets --RR */
+	if (hooknum == NF_IP_PRE_ROUTING
+	    && csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
+			         skb->ip_summed == CHECKSUM_HW ? skb->csum
+			      	 : skb_checksum(skb, iph->ihl*4, tcplen, 0)))
+		return 1;
+
+	/* Check TCP flags. */
+	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR));
+	if (!tcp_valid_flags[tcpflags]) 
+		return 1;
+
+	return 0;
+}
+
 static unsigned int reject(struct sk_buff **pskb,
 			   const struct net_device *in,
 			   const struct net_device *out,
@@ -364,6 +434,12 @@
 	/* Our naive response construction doesn't deal with IP
            options, and probably shouldn't try. */
 	if ((*pskb)->nh.iph->ihl<<2 != sizeof(struct iphdr))
+		return NF_DROP;
+
+	/* It is incorrect to reply to malformed packet.
+	 * REJECT in this case must DROP, because anything
+	 * else would be broken. */
+	if (tcp_error(*pskb, hooknum))
 		return NF_DROP;
 
 	/* WARNING: This code causes reentry within iptables.

--------------030302070302060705040307--
