From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] minor portability issue in ip_queue
Date: Thu, 15 Apr 2004 13:40:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407E7493.4020007@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070604050502050506050508"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
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
--------------070604050502050506050508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I think that there's a minor issue in ip_queue related to portability, 
actually most architectures use long as time_t and suseconds_t but some 
weird don't (parisc and sparc64).

So, If I'm not wrong, I think that maybe this could lead to some 
problems using ip_queue in those platforms. Whatever you think, please 
let me know.

regards,
Pablo

--------------070604050502050506050508
Content-Type: text/plain;
 name="ip_queue-portability.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_queue-portability.patch"

--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_queue.h	2004-02-18 04:59:25.000000000 +0100
+++ linux-2.6.3-patched/include/linux/netfilter_ipv4/ip_queue.h	2004-04-15 13:25:41.000000000 +0200
@@ -21,8 +21,8 @@
 typedef struct ipq_packet_msg {
 	unsigned long packet_id;	/* ID of queued packet */
 	unsigned long mark;		/* Netfilter mark value */
-	long timestamp_sec;		/* Packet arrival time (seconds) */
-	long timestamp_usec;		/* Packet arrvial time (+useconds) */
+	time_t timestamp_sec;		/* Packet arrival time (seconds) */
+	suseconds_t timestamp_usec;	/* Packet arrvial time (+useconds) */
 	unsigned int hook;		/* Netfilter hook we rode in on */
 	char indev_name[IFNAMSIZ];	/* Name of incoming interface */
 	char outdev_name[IFNAMSIZ];	/* Name of outgoing interface */

--------------070604050502050506050508--
