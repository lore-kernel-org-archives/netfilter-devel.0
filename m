From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] fine grain locking for tcp helper
Date: Sun, 02 May 2004 05:51:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4094705E.6010007@eurodev.net>
References: <40946DB9.6050705@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070103050706060901050207"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
In-Reply-To: <40946DB9.6050705@eurodev.net>
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
--------------070103050706060901050207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira wrote:

> This patch provides a fine-grain locking for the tcp helper in 
> conntrack. A per-conntrack lock is used, instead of having a global 
> lock to protect tcp specific data. If I'm missing something, please 
> let me know.


oops, sorry, wrong patch, it doesn't compile, I made a mistake in the .h 
file, please review this patch instead.

regards,
Pablo

--------------070103050706060901050207
Content-Type: text/plain;
 name="locking_tcp_proto_helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="locking_tcp_proto_helper.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-05-02 04:19:30.000000000 +0200
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-05-02 04:18:18.000000000 +0200
@@ -28,9 +28,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-/* Protects conntrack->proto.tcp */
-static DECLARE_RWLOCK(tcp_lock);
-
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
    closely.  They're more complex. --RR */
 
@@ -151,9 +148,9 @@
 {
 	enum tcp_conntrack state;
 
-	READ_LOCK(&tcp_lock);
+	READ_LOCK(&conntrack->proto.tcp.lock);
 	state = conntrack->proto.tcp.state;
-	READ_UNLOCK(&tcp_lock);
+	READ_UNLOCK(&conntrack->proto.tcp.lock);
 
 	return sprintf(buffer, "%s ", tcp_conntrack_names[state]);
 }
@@ -188,7 +185,7 @@
 		return NF_ACCEPT;
 	}
 
-	WRITE_LOCK(&tcp_lock);
+	WRITE_LOCK(&conntrack->proto.tcp.lock);
 	oldtcpstate = conntrack->proto.tcp.state;
 	newconntrack
 		= tcp_conntracks
@@ -200,7 +197,7 @@
 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
 		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
 		       conntrack->proto.tcp.state);
-		WRITE_UNLOCK(&tcp_lock);
+		WRITE_UNLOCK(&conntrack->proto.tcp.lock);
 		return -1;
 	}
 
@@ -222,7 +219,7 @@
 	    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
-out:	WRITE_UNLOCK(&tcp_lock);
+out:	WRITE_UNLOCK(&conntrack->proto.tcp.lock);
 	ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 
 	return NF_ACCEPT;
@@ -249,6 +246,9 @@
 	}
 
 	conntrack->proto.tcp.state = newconntrack;
+	/* make sure that lock is correctly initialized */
+	conntrack->proto.tcp.lock = RW_LOCK_UNLOCKED;
+
 	return 1;
 }
 
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-02-18 04:57:29.000000000 +0100
+++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-05-02 05:48:49.000000000 +0200
@@ -18,6 +18,9 @@
 
 struct ip_ct_tcp
 {
+	/* Protects conntrack tcp protocol specific information */
+	rwlock_t lock;
+
 	enum tcp_conntrack state;
 
 	/* Poor man's window tracking: sequence number of valid ACK

--------------070103050706060901050207--
