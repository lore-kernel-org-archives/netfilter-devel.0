From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Tue, 01 Jun 2004 14:26:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BC760B.4010705@eurodev.net>
References: <Pine.LNX.4.33.0406011128390.4755-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080908030602080509020407"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0406011128390.4755-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080908030602080509020407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef,

Jozsef Kadlecsik wrote:

>>- use of defined flags in tcp.h
>>    
>>
>
>As Patrick reminded us, we cannot use the TCPCB_FLAG_* flags. And I'm
>reluctant to use the enumerated values from include/linux/tcp.h because
>then I should have to add shifts to the window tracking code - just to
>eliminate the locally defined flags. What'd we gain by complicating the
>code?
>  
>

nothing, I agree with you and Patrick.

>>and pending that you give your ok:
>>- fine grain locking for private tcp helper info
>>    
>>
>
>First I added your code to the patch then removed it, sorry: it's overkill
>to add per entry locking. In the (near) future we'll have per bucket
>locking and then we can rely on that instead of a global tcp_lock.
>  
>

I agree, it doesn't make much sense adding that now, but it will after 
pushing forward your patches to improve locking stuff in conntrack.

Jozsef, I attached a patch to this email to clean up the way we handle 
trimmed off FIN packets, let me know if it's worth it. Still one 
question, should we update the timeout in this case?

regards,
Pablo

--------------080908030602080509020407
Content-Type: text/x-patch;
 name="tcp-win.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp-win.patch"

--- net/ipv4/netfilter/ip_conntrack_proto_tcp.c~	2004-06-01 13:33:39.000000000 +0200
+++ net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-06-01 14:18:43.000000000 +0200
@@ -485,7 +485,8 @@
                          enum ip_conntrack_dir dir,
                          const struct sk_buff *skb,
                          struct iphdr *iph,
-                         struct tcphdr *tcph)
+                         struct tcphdr *tcph,
+                         int *commit)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
@@ -592,7 +593,7 @@
 	    before(seq, sender->td_maxend)) {
 		end = sender->td_maxend;
 		if (state->stored_seq == TCP_FIN_SET)
-			state->stored_seq = TCP_ACK_SET;
+			*commit = 0;
 	}
 	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
 		before(end, sender->td_maxend + 1) 
@@ -784,6 +785,7 @@
 	struct tcphdr *tcph = (struct tcphdr *)buff;
 	unsigned long timeout;
 	unsigned int index, old_index;
+	int commit = 1;
 	
 	/* Smaller that minimal TCP header? */
 	if (skb_copy_bits(skb, iph->ihl * 4, buff, sizeof(*tcph)) != 0)
@@ -876,7 +878,7 @@
 
 	old_index =  conntrack->proto.tcp.stored_seq;
 	conntrack->proto.tcp.stored_seq = index;
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph)) {
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph, &commit)) {
 		/* Invalid packet, restore previous state */
 		conntrack->proto.tcp.stored_seq = old_index;
 		WRITE_UNLOCK(&tcp_lock);
@@ -884,15 +886,17 @@
 	}
 	/* From now on we have got in-window packets */
 	
-	/* If FIN was trimmed off, don't change state. */
-	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
-
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
 		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
 		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0), (tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
 		old_state, new_state);
 
-	conntrack->proto.tcp.state = new_state;
+	/* If FIN was trimmed off, don't change state. */
+	if (commit)
+		conntrack->proto.tcp.state = new_state;
+	else 
+		conntrack->proto.tcp.stored_seq = old_index;
+
 	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans ?
 		  ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];

--------------080908030602080509020407--
