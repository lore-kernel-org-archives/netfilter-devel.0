From: garana@uolsinectis.com.ar
Subject: [PATCH] New target: SWITCH
Date: Wed, 4 Sep 2002 20:34:14 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209042334.g84NYEg03822@gonzalo.arana>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

  I am developing a new target which should redirect
packets to a given host, no matter what routing table
says.
  This, with the aid of the random_patch (written by
<fabrice@celestix.com>) should enable a Linux box
to do a layer 3,4 switch work.
  When I try to add a rule with this target:

# iptables -t nat -A PREROUTING -p tcp --dport 80 \
	-j SWITCH --to 1.2.3.4

  I get:

iptables: Invalid argument

  I would need a hand here.  Could body one help me?

A couple of notes:
 + ipt_SWITCH.c (kernel module): is not finished but
   this error is not caused by this one (I think).
 + I placed ipt_SWITCH.c on netfilter/ directory
   (didn't know where else).
 + modprobe ipt_SWITCH works ok (but doesn't get
   loaded automatically)
 + libipt_SWITCH.c: is loaded, and the last function
   that gets called is final_check.

I previously submitted these files, but mime-encoded
it (sory!, I read the FAQ too late).

The patch:
diff -ru --new-file netfilter/ipt_SWITCH.c netfilter-new/ipt_SWITCH.c
--- netfilter/ipt_SWITCH.c	Wed Dec 31 21:00:00 1969
+++ netfilter-new/ipt_SWITCH.c	Wed Sep  4 20:11:24 2002
@@ -0,0 +1,293 @@
+//////////////////////////////////////////////////////////////////////////////
+// garana@uolsinectis.com.ar
+//   Implementation of SWITCH target for iptables (kernelside).
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/list.h>
+#include <linux/ghash.h>
+#include <linux/sched.h>
+#include <linux/if.h>
+#include <linux/if_ether.h>
+#include <net/arp.h>
+
+#include <linux/netfilter_ipv4/ipt_SWITCH.h>
+
+#define WHERE  printk(KERN_INFO __FILE__ "(%d):" __PRETTY_FUNCTION__ "\n", \
+					  __LINE__);
+
+//////////////////////////////////////////////////////////////////////////////
+// include/linux/ghash.h
+//   hashfn -> HASHFN
+// NO tiene sentido combinarlo con SNAT (enmascararia la IP origen)
+// NO tiene sentido combinarlo con DNAT (setearia entradas al pedo en ARP)
+// SE puede poner en iptables? => SI
+// After all filters (POST ROUTING)
+
+//TODO: connection tracking
+//  wall_jiffies / HZ => segundos
+//  + una lista (se insertan siempre al final y se agregan al ppio)
+//    con los paquetes enviados a c/u.
+//  + una tabla de hashing (usando como clave las ips origen y destino).
+//    apuntando a la lista en cuestion.
+//  + al aparecer un nuevo paquete con ip origen y destino ya presentes en
+//    la tabla de hashing, mover el nodo de la lista al final.
+//  + Cada vez que se llame a "-j SWITCH" se trata de eliminar una regla
+//    de bridging que haya dado timeout.  Como esta funcion se llama al menos
+//    dos veces por paquete, mientras siga habiendo trafico, las reglas que
+//    den timeout se iran eliminando como minimo dos veces mas rapido de lo
+//    que se crearon.
+//  + TODOCada un segundo se eliminan las reglas que hayan dado timeout.
+
+// I just can't use connection tracking since it may be possible that this
+// module will only process one-way traffic.
+//
+// It could be used interacting with connection-tracking-iptables module (I
+// think), but it may be possible that the KERNEL only see one-way traffic
+// (transparent proxy for large LAN/WAN, very busy web servers).
+//
+// Timeout for switch_timeout: 30 seconds
+static int switch_timeout = 30;//TODO allow this value to be changed
+
+// En que hook del netfilter lo pongo?
+//  Candidatos: 
+//     NF_IP_FORWARD       : LUEGO DE FILTER, ver CONNTRACK
+//     NF_IP_POST_ROUTING  : LUEGO DE SNAT y CONNTRACK
+// 
+//  NF_ACCEPT: continue traversal as normal.
+//  NF_DROP: drop the packet; don't continue traversal.
+//  NF_STOLEN: I've taken over the packet; don't continue traversal.
+//  NF_QUEUE: queue the packet (usually for userspace handling).
+//  NF_REPEAT: call this hook again.
+//  IPT_CONTINUE:
+
+//  NF_BR_FORWARD
+//  NF_BR_POST_ROUTING
+
+// Uso una tabla aparte? depende de que me permita eso.
+// Uso la conntrack?
+// Solo en POSTROUTING?
+
+//////////////////////////////////////////////////////////////////////////////
+// Local functions & structures
+// these should be able to handle about 16K connections every 30 seconds
+// (~550/sec) with no serious overhead 
+//TODO allow TABLE_SIZE to be changed
+#define TABLE_SIZE 4096
+
+DEF_HASH_STRUCTS(conn,TABLE_SIZE,struct bridge_rule);
+
+struct bridge_rule {
+  struct list_head conn_list;
+  struct conn_ptrs hptrs;
+  unsigned char sips[8]; // ip[0-3]: src_ip, ip[4-7]: dst_ip
+  unsigned char mac[6]; // who sould I send this
+  unsigned long second; // on which second this record was created/updated
+  // could process 136 years, 70 days, and a couple of hours with out
+  // overflowing.  Eventhough, it is considered.
+};
+
+static spinlock_t ipt_switch_rule_lock;
+static spinlock_t ipt_switch_queue_lock;
+
+struct conn_table hconns; // hash table with connections
+LIST_HEAD(lconns); // list with connections
+
+inline int ipvcmp (unsigned char* x, unsigned char* y) {
+  return memcmp(x, y, 8);
+}
+
+inline int ipveq  (unsigned char* x, unsigned char* y) {
+  return !memcmp(x, y, 8);
+}
+
+// Example: 1.2.3.4 -> 5.6.7.8 => return 4 ^ 8 + (3 << 8)
+// src ip address usually varies a lot (on diferent aplications:
+// NAS -> proxys, internet -> web servers, etc).
+inline int conn_hash(char* x) {
+  return ((x[3] ^ x[7]) + (x[2] << 8)) % TABLE_SIZE;
+}
+
+DEF_HASH(static,conn,TABLE_SIZE,struct bridge_rule,\
+hptrs,unsigned char*,sips,ipvcmp,ipveq,conn_hash)\
+
+//////////////////////////////////////////////////////////////////////////////
+// Clean connection queue
+static void Clean1TimedOutPacket(struct list_head* lconns) {
+  struct bridge_rule* ibrule = (struct bridge_rule*)lconns;
+  unsigned long now = jiffies / HZ;
+
+  if (lconns->prev == lconns->next) return;
+
+  spin_lock(&ipt_switch_rule_lock);
+  spin_lock(&ipt_switch_queue_lock);
+
+  // Considero el caso en que haya habido overflow
+  if ((ibrule->second > now &&
+	   ibrule->second - now > switch_timeout) ||
+	  (ibrule->second < now &&
+	   ~(now - ibrule->second) + 1 > switch_timeout)) {
+	list_del(lconns);
+	remove_conn_hash(&hconns, ibrule);
+	kfree(lconns);
+  }
+
+  spin_unlock(&ipt_switch_queue_lock);
+  spin_unlock(&ipt_switch_rule_lock);
+
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// iptables functions
+
+///////////////
+// Actually, this is the core of layer 4,5 switching
+// It is not finished.  Actually, it does nothing useful yet.
+static unsigned do_switch(struct sk_buff **pskb, unsigned hooknum,
+						  const struct net_device* in,
+						  const struct net_device* out,
+						  const void* targinfo, void* userdata) {
+  struct ipt_switch_info* info = 
+	(struct ipt_switch_info*)targinfo;
+  // IF there is any error, just continue with rest of rules
+  char* mac = NULL;
+  //TODO: if this conn is present, handle it where corresponds
+  //      and put it on the tail of de queue.
+  //TODO: if this conn is not present on connection htable, queue
+  //      it and place it on the htable also.
+  //TODO: Discard all timeout packets
+  //TODO: If it was already handled, return IPT_ACCEPT, or let iptables
+  //      continue with other chain
+  struct bridge_rule this_rule = { { NULL, NULL }, { NULL, NULL }, };
+  memcpy(this_rule.sips, &(*pskb)->h.ipiph->saddr, 4);
+  memcpy(this_rule.sips+3, &(*pskb)->h.ipiph->daddr, 4);
+  memset(this_rule.mac, 0, sizeof(this_rule.mac));
+  this_rule.second = jiffies / HZ;
+
+  if (!info) { // must check if already handled
+	struct bridge_rule* on_table;
+
+	spin_lock(&ipt_switch_rule_lock);
+	on_table = find_conn_hash(&hconns, this_rule.sips);
+	spin_unlock(&ipt_switch_rule_lock);
+
+	if (!on_table)
+	  return IPT_CONTINUE;
+	// ok, already handled
+	mac = on_table->mac;
+
+	spin_lock(&ipt_switch_queue_lock);
+	list_del(&on_table->conn_list);
+	list_add_tail(&on_table->conn_list, &lconns);
+	spin_unlock(&ipt_switch_queue_lock);
+
+	on_table->second = jiffies / HZ;
+
+  } else {
+	//TODO: ver GFP_ATOMIC
+	struct bridge_rule* on_table = kmalloc(sizeof(*on_table), GFP_ATOMIC);
+	if (!on_table) {
+	  printk(KERN_INFO "ipt_switch: not enough memory: "
+			 "forwarding packet to next rule\n");
+	  return IPT_CONTINUE;
+	}
+
+	// si no tengo la mac del host en cuestion
+	if (! *(int*)info->mac &&
+		!info->mac[4] && !info->mac[5]) {
+	  if (!out) {
+		printk(KERN_INFO "ipt_switch: output device not known\n");
+		return IPT_CONTINUE;
+	  }
+	  if (arp_find(info->mac, *pskb)) {
+		printk(KERN_INFO "ipt_switch: could not find mac for host\n");
+		return IPT_CONTINUE;
+	  }
+	}
+	memcpy(mac = this_rule.mac, info->mac, ETH_ALEN);
+
+	spin_lock(&ipt_switch_rule_lock);
+	insert_conn_hash(&hconns, &this_rule);
+	spin_unlock(&ipt_switch_rule_lock);
+
+	memcpy(on_table, &this_rule, sizeof(*on_table));
+
+	spin_lock(&ipt_switch_queue_lock);
+	list_add_tail(&on_table->conn_list, &lconns);
+	spin_unlock(&ipt_switch_queue_lock);
+  }
+
+
+  // set the destination host for the packet
+  if ((*pskb)->mac.ethernet)
+	memcpy((*pskb)->mac.ethernet->h_dest, mac, ETH_ALEN);
+  else
+	printk(KERN_INFO "ipt_switch: sk_buff is not ethernet\n");
+
+  // Now I remove one timed out packet
+  // This sould remove timed out packets quite quickly as long as there are
+  // new packets.  Check documentation.
+  Clean1TimedOutPacket(&lconns);
+  return NF_ACCEPT;
+}
+
+///////////////
+// Check data when adding a new entry
+// "-j SWITCH --to 00:D0:09:E2:2F:81
+// "-j SWITCH --to 1.2.3.4
+// if "-j SWITCH" and nothing else, it means that
+// here should verify if is there any pending connection
+static int ipt_switch_check_entry (const char* tablename,
+								  const struct ipt_entry *e,
+								  void* targinfo,
+								  unsigned int targinfosize,
+								  unsigned int hook_mask) {
+  struct ipt_switch_info* switch_info = targinfo;
+  WHERE;
+  if (targinfosize != IPT_ALIGN(sizeof(struct ipt_switch_info))) {
+	printk(KERN_INFO "SWITCH: targinfosize %u != 0\n", targinfosize);
+	return 0;
+  }
+  WHERE;
+  if (strcmp(tablename, "nat")) {
+	printk(KERN_INFO "SWITCH: bad table '%s'\n", tablename);
+	return 0;
+  }
+  WHERE;
+  // Only in IP_FORWARD and IP_POST_ROUTING
+  if (hook_mask & ~((1 << NF_IP_FORWARD) |
+					(1 << NF_IP_POST_ROUTING))) {
+	printk(KERN_INFO "SWITCH: bad hook_mask '%X'\n", hook_mask);
+	return 0;
+  }
+  WHERE;
+  //TODO: check if not multicast ip/mac
+  return 1;
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Loading & unloading module
+static struct ipt_target l45switch_target = {
+  { NULL, NULL }, "SWITCH", do_switch, ipt_switch_check_entry,
+  NULL, THIS_MODULE
+};
+
+static int __init l45switch_init(void) {
+  printk(KERN_INFO "Loading ipt_switch\n");
+  spin_lock_init(&ipt_switch_rule_lock);
+  if (ipt_register_target(&l45switch_target))
+	return -EINVAL;
+  return 0;
+}
+
+static void __exit l45switch_deinit(void) {
+  printk(KERN_INFO "Unloading ipt_switch\n");
+  ipt_unregister_target(&l45switch_target);
+}
+
+module_init(l45switch_init)
+module_exit(l45switch_deinit)
+MODULE_LICENSE("GPL");
diff -ru --new-file netfilter/userspace/extensions/Makefile netfilter-new/userspace/extensions/Makefile
--- netfilter/userspace/extensions/Makefile	Wed May 29 12:11:49 2002
+++ netfilter-new/userspace/extensions/Makefile	Wed Sep  4 20:07:33 2002
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-PF_EXT_SLIB:=ah conntrack dscp ecn esp icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG
+PF_EXT_SLIB:=ah conntrack dscp ecn esp icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG SWITCH
 PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
 
 # The following may not be present, but compile them anyway.
diff -ru --new-file netfilter/userspace/extensions/libipt_SWITCH.c netfilter-new/userspace/extensions/libipt_SWITCH.c
--- netfilter/userspace/extensions/libipt_SWITCH.c	Wed Dec 31 21:00:00 1969
+++ netfilter-new/userspace/extensions/libipt_SWITCH.c	Sun Sep  1 21:22:58 2002
@@ -0,0 +1,119 @@
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include "ipt_SWITCH.h"
+
+#define WHERE   (printf("%s(%d): %s\n",__FILE__,__LINE__,__PRETTY_FUNCTION__))
+
+//////////////////////////////////////////////////////////////////////////////
+// help function
+static void help(void) {
+  printf(
+"SWITCH v%s options:\n"
+"--to  IP     (xxx.yyy.zzz.ttt) forces nexthop (warning, it must be on\n"
+"             arp table).  ARP questions will not be sent.\n"
+"\n", NETFILTER_VERSION);
+}
+
+static struct option opts[] = {
+  { "to-ip", 1, 0, 'i' },
+  { "to", 1, 0, 'i' },
+  { NULL, 0, 0, 0 }
+};
+
+//////////////////////////////////////////////////////////////////////////////
+// Initialize the module.
+static void init(struct ipt_entry_target* m, unsigned int* nfcache) {
+  struct ipt_switch_info* info = (struct ipt_switch_info*) m;
+  info->uip = 0;
+  WHERE;;
+  *nfcache |= NFC_UNKNOWN;
+}
+
+
+static int ip_address_atoi(unsigned* uip, char* str) {
+  WHERE;;
+  return !inet_aton(str, (struct in_addr*)uip);
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Parses command options; returns true if it ate an option
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+				 const struct ipt_entry *entry,
+				 struct ipt_entry_target **target) {
+  struct ipt_switch_info* info = (struct ipt_switch_info*)(*target)->data;
+  int dev = 0;
+  WHERE;;
+  memset(info, 0, sizeof(*info));
+  switch (c) {
+  case 'i':
+	if (ip_address_atoi(&info->uip, optarg)) {
+	  WHERE;;
+	  exit_error(PARAMETER_PROBLEM, "Bad IP");
+	} else dev = 1;
+	WHERE;;
+	break;
+  default:
+	WHERE;;
+	break;
+  }
+  printf("\treturning %d\n", dev);
+  return dev;
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Final check
+//   What should I do?
+static void final_check(unsigned int flags) {
+  WHERE;;
+  printf("\tflags = %x\n", flags);
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Prints out target info
+static void print(const struct ipt_ip* ip,
+				  const struct ipt_entry_target* target,
+				  int numeric) {
+  struct ipt_switch_info* info = (struct ipt_switch_info*) target;
+  char sip[16];
+  struct in_addr _ip = { info-> uip };
+  strcpy(sip, inet_ntoa(_ip));
+  printf ("to %s", sip);
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Saves ipt_SWITCH in parseable form to stdout
+static void save(const struct ipt_ip* ip,
+				 const struct ipt_entry_target* target) {
+  struct ipt_switch_info* info = (struct ipt_switch_info*) target;
+  char sip[16];
+  struct in_addr _ip = { info-> uip };
+  strcpy(sip, inet_ntoa(_ip));
+  printf("--to %s", sip);
+}
+
+//////////////////////////////////////////////////////////////////////////////
+// Describe this module
+static struct iptables_target SWITCH_TARGET = {
+  next: NULL,
+  name: "SWITCH",
+  version: NETFILTER_VERSION,
+  size: IPT_ALIGN(sizeof(struct ipt_switch_info)),
+  userspacesize: IPT_ALIGN(sizeof(struct ipt_switch_info)),
+  help: help,
+  init: init,
+  parse: parse,
+  final_check: final_check,
+  print: print,
+  save: save,
+  extra_opts: opts
+};
+
+void _init(void) {
+  WHERE;;
+  register_target(&SWITCH_TARGET);
+}
diff -ru --new-file netfilter/userspace/include/linux/netfilter_ipv4/ipt_SWITCH.h netfilter-new/userspace/include/linux/netfilter_ipv4/ipt_SWITCH.h
--- netfilter/userspace/include/linux/netfilter_ipv4/ipt_SWITCH.h	Wed Dec 31 21:00:00 1969
+++ netfilter-new/userspace/include/linux/netfilter_ipv4/ipt_SWITCH.h	Mon Aug 19 20:53:01 2002
@@ -0,0 +1,13 @@
+
+#ifndef __IPT_SWITCH_
+#define __IPT_SWITCH_
+
+/*  #include <linux/if.h> */
+/*  #include <linux/if_ether.h> */
+
+struct ipt_switch_info {
+  int uip;
+  unsigned char mac[6];
+};
+
+#endif
