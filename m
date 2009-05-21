From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack and RSTs received during CLOSE_WAIT
Date: Thu, 21 May 2009 17:31:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905211729090.13699@blackhole.kfki.hu>
References: <4A0DE859.7000209@tigertech.com> <alpine.DEB.2.00.0905162348430.4156@blackhole.kfki.hu> <4A0F7FEE.3010405@tigertech.com> <4A139222.2020505@tigertech.com> <alpine.DEB.2.00.0905200904310.10018@blackhole.kfki.hu> <4A1466F6.8070304@tigertech.com>
 <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 20 May 2009, Jozsef Kadlecsik wrote:

> Because connlimit/connbytes rely on conntrack, the latter should be 
> "fixed". However I do not see any way to make it resistant against such 
> attacks: if we shrink the window (by which alogrithm?) we may block valid 
> RST segments and thus cause connections to hang instead of termination.

OK, here is a patch. Could you test it with your script and in your 
environment?

The patch below introduces a new flag for TCP conntrack to mark that RST 
segment was seen. If retransmitted packets detected from the other 
direction after the RST segment detected, the timeout of the conntrack 
entry is linearly increased up to a hardcoded value. Thus we can both 
catch the retransmitted packets and preserve the effectiveness of 
connlimit/connbytes.
---
diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 3066789..465d346 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -35,6 +35,9 @@ enum tcp_conntrack {
 /* Has unacknowledged data */
 #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
 
+/* Has seen RST */
+#define IP_CT_TCP_FLAG_RST_SEEN			0x20
+
 struct nf_ct_tcp_flags {
 	__u8 flags;
 	__u8 mask;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b5ccf2b..fca7caa 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -84,6 +84,10 @@ static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
 	[TCP_CONNTRACK_CLOSE]		= 10 SECS,
 };
 
+/* Max timeout when retransmitted packets detected after RST was seen
+   from the other direction */
+#define TCP_TIMEOUT_RETRANS_AFTER_RST		2 MINS
+
 #define sNO TCP_CONNTRACK_NONE
 #define sSS TCP_CONNTRACK_SYN_SENT
 #define sSR TCP_CONNTRACK_SYN_RECV
@@ -918,6 +922,8 @@ static int tcp_packet(struct nf_conn *ct,
 				  "nf_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_CLOSE:
+		if (index == TCP_RST_SET)
+			ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_RST_SEEN;
 		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
 			 && ct->proto.tcp.last_index == TCP_SYN_SET)
@@ -963,7 +969,12 @@ static int tcp_packet(struct nf_conn *ct,
 	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 
-	if (ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans &&
+	if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_RST_SEEN
+	    && ct->proto.tcp.retrans > 1)
+	    	timeout = min_t(unsigned int,
+	    			tcp_timeouts[sCL] * ct->proto.tcp.retrans,
+	    			TCP_TIMEOUT_RETRANS_AFTER_RST);
+	else if (ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans &&
 	    tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans)
 		timeout = nf_ct_tcp_timeout_max_retrans;
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
