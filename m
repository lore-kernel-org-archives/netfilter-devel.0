From: Evrim ULU <evrim@core.gen.tr>
Subject: IP Queue Conntrack info patch
Date: Fri, 18 Apr 2003 18:19:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA01795.8070301@core.gen.tr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030804000900010907070305"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------030804000900010907070305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

First post so, flames>>/dev/null ehe:-)


We were coding a userspace firewall and saw there exists no conntrack 
info in ipq_packet_msg_t so added it in an ugly fashion. (with my dear 
*friend* Aycan Irican<aycan@core.gen.tr>) Maybe someone will publish a 
better patch in future.

My question is about arp packets.

I'm trying to process arp packets via ip_queue. I couldn't make the 
below code segment work. I've looked into ip_queue module and saw 
payload is taken from skb->data. I don't know what the skb->data pointer 
really points but i know that if packet is an ip_protocol pack, i can make

iphdr = (struct iphdr *)p->payload

Also, i know that iphdr and arphdr are both network layer headers in 
skbuff structure so, it must run correctly.  When i run it, if protocol 
is ARP, i'm getting 40 bytes of payload which does not fit into arphdr 
(also not in struct ether_arp *) correctly.

void handle_packet(ipq_packet_msg_t *p)
{
proto = ntohs(p->hw_protocol);
switch(proto) {
	case ETH_P_ARP:
         case ETH_P_RARP:
             g_message("got ARP packet");
	    process_arp(p);
}

int process_arp(ipq_packet_msg_t *p)
{
     struct arphdr *arp = p->payload;
     /* PROBLEM , arphdr is not correct */
     switch(ntohs(arp->ar_op)) {
     case ARPOP_REQUEST:
	g_message("Got arp request");
	break;
     }
}

Thnx.
Evrim.

--------------030804000900010907070305
Content-Type: text/plain;
 name="ip_queue_conntrack.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_queue_conntrack.diff"

--- /usr/src/linux-2.4.20/net/ipv4/netfilter/ip_queue.c	2003-02-15 00:04:41.000000000 +0200
+++ /usr/src/linux/net/ipv4/netfilter/ip_queue.c	2003-04-01 20:23:21.000000000 +0300
@@ -252,6 +252,10 @@
 				                                   pmsg->hw_addr);
 	}
 	
+	if (!ip_conntrack_get(entry->skb, &pmsg->conntrack)) {
+		printk("Matrix has you!\n");
+		goto nlmsg_failure;
+	}
 	if (data_len)
 		memcpy(pmsg->payload, entry->skb->data, data_len);
 		
--- /usr/src/linux-2.4.20/include/linux/netfilter_ipv4/ip_queue.h	2003-02-15 00:04:41.000000000 +0200
+++ /usr/src/linux/include/linux/netfilter_ipv4/ip_queue.h	2003-04-01 20:12:17.000000000 +0300
@@ -17,6 +17,8 @@
 #include <net/if.h>
 #endif	/* ! __KERNEL__ */
 
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
 /* Messages sent from kernel */
 typedef struct ipq_packet_msg {
 	unsigned long packet_id;	/* ID of queued packet */
@@ -30,6 +32,7 @@
 	unsigned short hw_type;		/* Hardware type */
 	unsigned char hw_addrlen;	/* Hardware address length */
 	unsigned char hw_addr[8];	/* Hardware address */
+	enum ip_conntrack_info conntrack;
 	size_t data_len;		/* Length of packet data */
 	unsigned char payload[0];	/* Optional packet data */
 } ipq_packet_msg_t;

--------------030804000900010907070305--
