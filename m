From: Martijn Lievaart <m@rtij.nl>
Subject: [PATCH] psd ported to 2.6
Date: Tue, 11 May 2004 08:43:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A07613.5060502@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_ma.rtij.nl-12116-1084257814-0001-2"
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_ma.rtij.nl-12116-1084257814-0001-2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Attached a patch to port the psd module to 2.6. I also removed an 
erroneous use of HZ as the constant 100, which precluded compiling under 
uml.

Regards,
Martijn Lievaart


--=_ma.rtij.nl-12116-1084257814-0001-2
Content-Type: text/plain; name="psd.2.6.patch"; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="psd.2.6.patch"
X-Mime-Autoconverted: from 8bit to quoted-printable by courier 0.44.2

diff --exclude=3D'*~*' -U 3 -r -N patch-o-matic-ng/psd/info patch-o-mati=
c-ng.new/psd/info
--- patch-o-matic-ng/psd/info=092004-02-22 19:14:52.000000000 +0100
+++ patch-o-matic-ng.new/psd/info=092004-05-05 17:05:00.000000000 +0200
@@ -1,4 +1,3 @@
 Author: Dennis Koslowski <dkoslowski@astaro.de>
 Status: Experimental
 Repository: base
-Requires: linux < 2.6.0
diff --exclude=3D'*~*' -U 3 -r -N patch-o-matic-ng/psd/linux/include/lin=
ux/netfilter_ipv4/ipt_psd.h patch-o-matic-ng.new/psd/linux/include/linux=
/netfilter_ipv4/ipt_psd.h
--- patch-o-matic-ng/psd/linux/include/linux/netfilter_ipv4/ipt_psd.h=09=
2003-12-18 19:28:43.000000000 +0100
+++ patch-o-matic-ng.new/psd/linux/include/linux/netfilter_ipv4/ipt_psd.=
h=092004-05-08 14:27:09.000000000 +0200
@@ -18,7 +18,7 @@
 #define SCAN_MIN_COUNT=09=09=097
 #define SCAN_MAX_COUNT=09=09=09(SCAN_MIN_COUNT * PORT_WEIGHT_PRIV)
 #define SCAN_WEIGHT_THRESHOLD=09=09SCAN_MAX_COUNT
-#define SCAN_DELAY_THRESHOLD=09=09(HZ * 3)
+#define SCAN_DELAY_THRESHOLD=09=09(300) /* old usage of HZ here was err=
oneously and broke under uml */
 
 /*
  * Keep track of up to LIST_SIZE source addresses, using a hash table o=
f
diff --exclude=3D'*~*' -U 3 -r -N patch-o-matic-ng/psd/linux/net/ipv4/ne=
tfilter/Kconfig.ladd patch-o-matic-ng.new/psd/linux/net/ipv4/netfilter/K=
config.ladd
--- patch-o-matic-ng/psd/linux/net/ipv4/netfilter/Kconfig.ladd=092003-12=
-21 21:09:35.000000000 +0100
+++ patch-o-matic-ng.new/psd/linux/net/ipv4/netfilter/Kconfig.ladd=09200=
4-05-05 17:18:23.000000000 +0200
@@ -1,3 +1,9 @@
 config IP_NF_MATCH_PSD
 =09tristate  'psd match support'
 =09depends on IP_NF_IPTABLES
+        help
+=09  This option adds a `psd' match, which allows you to create rules i=
n
+=09  any iptables table wich will detect TCP and UDP port scans.
+
+=09  If you want to compile it as a module, say M here and read
+=09  Documentation/modules.txt.  If unsure, say `N'.
diff --exclude=3D'*~*' -U 3 -r -N patch-o-matic-ng/psd/linux-2.6/include=
/linux/netfilter_ipv4/ipt_psd.h patch-o-matic-ng.new/psd/linux-2.6/inclu=
de/linux/netfilter_ipv4/ipt_psd.h
--- patch-o-matic-ng/psd/linux-2.6/include/linux/netfilter_ipv4/ipt_psd.=
h=091970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.new/psd/linux-2.6/include/linux/netfilter_ipv4/ipt_=
psd.h=092004-05-08 14:27:38.000000000 +0200
@@ -0,0 +1,40 @@
+#ifndef _IPT_PSD_H
+#define _IPT_PSD_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+/*
+ * High port numbers have a lower weight to reduce the frequency of fal=
se
+ * positives, such as from passive mode FTP transfers.
+ */
+#define PORT_WEIGHT_PRIV=09=093
+#define PORT_WEIGHT_HIGH=09=091
+
+/*
+ * Port scan detection thresholds: at least COUNT ports need to be scan=
ned
+ * from the same source, with no longer than DELAY ticks between ports.
+ */
+#define SCAN_MIN_COUNT=09=09=097
+#define SCAN_MAX_COUNT=09=09=09(SCAN_MIN_COUNT * PORT_WEIGHT_PRIV)
+#define SCAN_WEIGHT_THRESHOLD=09=09SCAN_MAX_COUNT
+#define SCAN_DELAY_THRESHOLD=09=09(300) /* old usage of HZ here was err=
oneously and broke under uml */
+
+/*
+ * Keep track of up to LIST_SIZE source addresses, using a hash table o=
f
+ * HASH_SIZE entries for faster lookups, but limiting hash collisions t=
o
+ * HASH_MAX source addresses per the same hash value.
+ */
+#define LIST_SIZE=09=09=090x100
+#define HASH_LOG=09=09=099
+#define HASH_SIZE=09=09=09(1 << HASH_LOG)
+#define HASH_MAX=09=09=090x10
+
+struct ipt_psd_info {
+=09unsigned int weight_threshold;
+=09unsigned int delay_threshold;
+=09unsigned short lo_ports_weight;
+=09unsigned short hi_ports_weight;
+};
+
+#endif /*_IPT_PSD_H*/
diff --exclude=3D'*~*' -U 3 -r -N patch-o-matic-ng/psd/linux-2.6/net/ipv=
4/netfilter/ipt_psd.c patch-o-matic-ng.new/psd/linux-2.6/net/ipv4/netfil=
ter/ipt_psd.c
--- patch-o-matic-ng/psd/linux-2.6/net/ipv4/netfilter/ipt_psd.c=091970-0=
1-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.new/psd/linux-2.6/net/ipv4/netfilter/ipt_psd.c=0920=
04-05-05 16:57:45.000000000 +0200
@@ -0,0 +1,358 @@
+/*
+  This is a module which is used for PSD (portscan detection)
+  Derived from scanlogd v2.1 written by Solar Designer <solar@false.com=
>
+  and LOG target module.
+
+  Copyright (C) 2000,2001 astaro AG
+
+  This file is distributed under the terms of the GNU General Public
+  License (GPL). Copies of the GPL can be obtained from:
+     ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+  2000-05-04 Markus Hennig <hennig@astaro.de> : initial
+  2000-08-18 Dennis Koslowski <koslowski@astaro.de> : first release
+  2000-12-01 Dennis Koslowski <koslowski@astaro.de> : UDP scans detecti=
on added
+  2001-01-02 Dennis Koslowski <koslowski@astaro.de> : output modified
+  2001-02-04 Jan Rekorajski <baggins@pld.org.pl> : converted from targe=
t to match
+  2004-05-05 Martijn Lievaart <m@rtij.nl> : ported to 2.6
+*/
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/tcp.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_psd.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dennis Koslowski <koslowski@astaro.com>");
+
+#define HF_DADDR_CHANGING   0x01
+#define HF_SPORT_CHANGING   0x02
+#define HF_TOS_CHANGING=09    0x04
+#define HF_TTL_CHANGING=09    0x08
+            
+/*
+ * Information we keep per each target port
+ */
+struct port {
+=09u_int16_t number;      /* port number */ 
+=09u_int8_t proto;        /* protocol number */
+=09u_int8_t and_flags;    /* tcp ANDed flags */
+=09u_int8_t or_flags;     /* tcp ORed flags */
+};
+
+/*
+ * Information we keep per each source address.
+ */
+struct host {
+=09struct host *next;=09=09/* Next entry with the same hash */
+=09clock_t timestamp;=09=09/* Last update time */
+=09struct in_addr src_addr;=09/* Source address */
+=09struct in_addr dest_addr;=09/* Destination address */
+=09unsigned short src_port;=09/* Source port */
+=09int count;=09=09=09/* Number of ports in the list */
+=09int weight;=09=09=09/* Total weight of ports in the list */
+=09struct port ports[SCAN_MAX_COUNT - 1];=09/* List of ports */
+=09unsigned char tos;=09=09/* TOS */
+=09unsigned char ttl;=09=09/* TTL */
+=09unsigned char flags;=09=09/* HF_ flags bitmask */
+};
+
+/*
+ * State information.
+ */
+static struct {
+=09spinlock_t lock;
+=09struct host list[LIST_SIZE];=09/* List of source addresses */
+=09struct host *hash[HASH_SIZE];=09/* Hash: pointers into the list */
+=09int index;=09=09=09/* Oldest entry to be replaced */
+} state;
+
+/*
+ * Convert an IP address into a hash table index.
+ */
+static inline int hashfunc(struct in_addr addr)
+{
+=09unsigned int value;
+=09int hash;
+
+=09value =3D addr.s_addr;
+=09hash =3D 0;
+=09do {
+=09=09hash ^=3D value;
+=09} while ((value >>=3D HASH_LOG));
+
+=09return hash & (HASH_SIZE - 1);
+}
+
+static int
+ipt_psd_match(const struct sk_buff *pskb,
+=09      const struct net_device *in,
+=09      const struct net_device *out,
+=09      const void *matchinfo,
+=09      int offset,
+=09      int *hotdrop)
+{
+=09struct iphdr *ip_hdr;
+=09struct tcphdr *tcp_hdr;
+=09struct in_addr addr;
+=09u_int16_t src_port,dest_port;
+  =09u_int8_t tcp_flags, proto;
+=09clock_t now;
+=09struct host *curr, *last, **head;
+=09int hash, index, count;
+
+=09/* Parameters from userspace */
+=09const struct ipt_psd_info *psdinfo =3D matchinfo;
+
+=09/* IP header */
+=09ip_hdr =3D pskb->nh.iph;
+
+=09/* Sanity check */
+=09if (ntohs(ip_hdr->frag_off) & IP_OFFSET) {
+=09=09DEBUGP("PSD: sanity check failed\n");
+=09=09return 0;
+=09}
+
+=09/* TCP or UDP ? */
+=09proto =3D ip_hdr->protocol;
+
+=09if (proto !=3D IPPROTO_TCP && proto !=3D IPPROTO_UDP) {
+=09=09DEBUGP("PSD: protocol not supported\n");
+=09=09return 0;
+=09}
+
+=09/* Get the source address, source & destination ports, and TCP flags=
 */
+
+=09addr.s_addr =3D ip_hdr->saddr;
+
+=09tcp_hdr =3D (struct tcphdr*)((u_int32_t *)ip_hdr + ip_hdr->ihl);
+
+=09/* Yep, it=B4s dirty */
+=09src_port =3D tcp_hdr->source;
+=09dest_port =3D tcp_hdr->dest;
+
+=09if (proto =3D=3D IPPROTO_TCP) {
+=09=09tcp_flags =3D *((u_int8_t*)tcp_hdr + 13);
+=09}
+=09else {
+=09=09tcp_flags =3D 0x00;
+=09}
+
+=09/* We're using IP address 0.0.0.0 for a special purpose here, so don=
't let
+=09 * them spoof us. [DHCP needs this feature - HW] */
+=09if (!addr.s_addr) {
+=09=09DEBUGP("PSD: spoofed source address (0.0.0.0)\n");
+=09=09return 0;
+=09}
+
+=09/* Use jiffies here not to depend on someone setting the time while =
we're
+=09 * running; we need to be careful with possible return value overflo=
ws. */
+=09now =3D jiffies;
+
+=09spin_lock(&state.lock);
+
+=09/* Do we know this source address already? */
+=09count =3D 0;
+=09last =3D NULL;
+=09if ((curr =3D *(head =3D &state.hash[hash =3D hashfunc(addr)])))
+=09=09do {
+=09=09=09if (curr->src_addr.s_addr =3D=3D addr.s_addr) break;
+=09=09=09count++;
+=09=09=09if (curr->next) last =3D curr;
+=09=09} while ((curr =3D curr->next));
+
+=09if (curr) {
+
+=09=09/* We know this address, and the entry isn't too old. Update it. =
*/
+=09=09if (now - curr->timestamp <=3D (psdinfo->delay_threshold*HZ)/100 =
&&
+=09=09    time_after_eq(now, curr->timestamp)) {
+
+=09=09=09/* Just update the appropriate list entry if we've seen this p=
ort already */
+=09=09=09for (index =3D 0; index < curr->count; index++) {
+=09=09=09=09if (curr->ports[index].number =3D=3D dest_port) {
+=09=09=09=09=09curr->ports[index].proto =3D proto;
+=09=09=09=09=09curr->ports[index].and_flags &=3D tcp_flags;
+=09=09=09=09=09curr->ports[index].or_flags |=3D tcp_flags;
+=09=09=09=09=09goto out_no_match;
+=09=09=09=09}
+=09=09=09}
+
+=09=09=09/* TCP/ACK and/or TCP/RST to a new port? This could be an outg=
oing connection. */
+=09=09=09if (proto =3D=3D IPPROTO_TCP && (tcp_hdr->ack || tcp_hdr->rst)=
)
+=09=09=09=09goto out_no_match;
+
+=09=09=09/* Packet to a new port, and not TCP/ACK: update the timestamp=
 */
+=09=09=09curr->timestamp =3D now;
+
+=09=09=09/* Logged this scan already? Then drop the packet. */
+=09=09=09if (curr->weight >=3D psdinfo->weight_threshold)
+=09=09=09=09goto out_match;
+
+=09=09=09/* Specify if destination address, source port, TOS or TTL are=
 not fixed */
+=09=09=09if (curr->dest_addr.s_addr !=3D ip_hdr->daddr)
+=09=09=09=09curr->flags |=3D HF_DADDR_CHANGING;
+=09=09=09if (curr->src_port !=3D src_port)
+=09=09=09=09curr->flags |=3D HF_SPORT_CHANGING;
+=09=09=09if (curr->tos !=3D ip_hdr->tos)
+=09=09=09=09curr->flags |=3D HF_TOS_CHANGING;
+=09=09=09if (curr->ttl !=3D ip_hdr->ttl)
+=09=09=09=09curr->flags |=3D HF_TTL_CHANGING;
+
+=09=09=09/* Update the total weight */
+=09=09=09curr->weight +=3D (ntohs(dest_port) < 1024) ?
+=09=09=09=09psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
+
+=09=09=09/* Got enough destination ports to decide that this is a scan?=
 */
+=09=09=09/* Then log it and drop the packet. */
+=09=09=09if (curr->weight >=3D psdinfo->weight_threshold)
+=09=09=09=09goto out_match;
+
+=09=09=09/* Remember the new port */
+=09=09=09if (curr->count < SCAN_MAX_COUNT) {
+=09=09=09=09curr->ports[curr->count].number =3D dest_port;
+=09=09=09=09curr->ports[curr->count].proto =3D proto;
+=09=09=09=09curr->ports[curr->count].and_flags =3D tcp_flags;
+=09=09=09=09curr->ports[curr->count].or_flags =3D tcp_flags;
+=09=09=09=09curr->count++;
+=09=09=09}
+
+=09=09=09goto out_no_match;
+=09=09}
+
+=09=09/* We know this address, but the entry is outdated. Mark it unuse=
d, and
+=09=09 * remove from the hash table. We'll allocate a new entry instead=
 since
+=09=09 * this one might get re-used too soon. */
+=09=09curr->src_addr.s_addr =3D 0;
+=09=09if (last)
+=09=09=09last->next =3D last->next->next;
+=09=09else if (*head)
+=09=09=09*head =3D (*head)->next;
+=09=09last =3D NULL;
+=09}
+
+=09/* We don't need an ACK from a new source address */
+=09if (proto =3D=3D IPPROTO_TCP && tcp_hdr->ack)
+=09=09goto out_no_match;
+
+=09/* Got too many source addresses with the same hash value? Then remo=
ve the
+=09 * oldest one from the hash table, so that they can't take too much =
of our
+=09 * CPU time even with carefully chosen spoofed IP addresses. */
+=09if (count >=3D HASH_MAX && last) last->next =3D NULL;
+
+=09/* We're going to re-use the oldest list entry, so remove it from th=
e hash
+=09 * table first (if it is really already in use, and isn't removed fr=
om the
+=09 * hash table already because of the HASH_MAX check above). */
+
+=09/* First, find it */
+=09if (state.list[state.index].src_addr.s_addr)
+=09=09head =3D &state.hash[hashfunc(state.list[state.index].src_addr)];
+=09else
+=09=09head =3D &last;
+=09last =3D NULL;
+=09if ((curr =3D *head))
+=09do {
+=09=09if (curr =3D=3D &state.list[state.index]) break;
+=09=09last =3D curr;
+=09} while ((curr =3D curr->next));
+
+=09/* Then, remove it */
+=09if (curr) {
+=09=09if (last)
+=09=09=09last->next =3D last->next->next;
+=09=09else if (*head)
+=09=09=09*head =3D (*head)->next;
+=09}
+
+=09/* Get our list entry */
+=09curr =3D &state.list[state.index++];
+=09if (state.index >=3D LIST_SIZE) state.index =3D 0;
+
+=09/* Link it into the hash table */
+=09head =3D &state.hash[hash];
+=09curr->next =3D *head;
+=09*head =3D curr;
+
+=09/* And fill in the fields */
+=09curr->timestamp =3D now;
+=09curr->src_addr =3D addr;
+=09curr->dest_addr.s_addr =3D ip_hdr->daddr;
+=09curr->src_port =3D src_port;
+=09curr->count =3D 1;
+=09curr->weight =3D (ntohs(dest_port) < 1024) ?
+=09=09psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
+=09curr->ports[0].number =3D dest_port;
+=09curr->ports[0].proto =3D proto;
+=09curr->ports[0].and_flags =3D tcp_flags;
+=09curr->ports[0].or_flags =3D tcp_flags;
+=09curr->tos =3D ip_hdr->tos;
+=09curr->ttl =3D ip_hdr->ttl;
+
+out_no_match:
+=09spin_unlock(&state.lock);
+=09return 0;
+
+out_match:
+=09spin_unlock(&state.lock);
+=09return 1;
+}
+
+static int ipt_psd_checkentry(const char *tablename,
+=09=09=09      const struct ipt_ip *e,
+=09=09=09      void *matchinfo,
+=09=09=09      unsigned int matchsize,
+=09=09=09      unsigned int hook_mask)
+{
+/*=09const struct ipt_psd_info *psdinfo =3D targinfo;*/
+
+=09/* we accept TCP only */
+/*  =09if (e->ip.proto !=3D IPPROTO_TCP) { */
+/*  =09=09DEBUGP("PSD: specified protocol may be TCP only\n"); */
+/*  =09=09return 0; */
+/*  =09} */
+
+=09if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_psd_info))) {
+=09=09DEBUGP("PSD: matchsize %u !=3D %u\n",
+=09=09       matchsize,
+=09=09       IPT_ALIGN(sizeof(struct ipt_psd_info)));
+=09=09return 0;
+=09}
+
+=09return 1;
+}
+
+static struct ipt_match ipt_psd_reg =3D { 
+=09.name =3D "psd",
+=09.match =3D ipt_psd_match,
+=09.checkentry =3D ipt_psd_checkentry,
+=09.me =3D THIS_MODULE };
+
+static int __init init(void)
+{
+=09if (ipt_register_match(&ipt_psd_reg))
+=09=09return -EINVAL;
+
+=09memset(&state, 0, sizeof(state));
+
+=09spin_lock_init(&(state.lock));
+
+=09printk("netfilter PSD loaded - (c) astaro AG\n");
+=09return 0;
+}
+
+static void __exit fini(void)
+{
+=09ipt_unregister_match(&ipt_psd_reg);
+=09printk("netfilter PSD unloaded - (c) astaro AG\n");
+}
+
+module_init(init);
+module_exit(fini);

--=_ma.rtij.nl-12116-1084257814-0001-2--
