From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.5.x iptables enhancement: add new 'recent' match
Date: Tue, 24 Jun 2003 21:10:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624191059.GC2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8TMLq6GPUuN4DysL"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8TMLq6GPUuN4DysL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here it comes, the very popular iptables 'recent' match, this time the
version for the 2.5.x kernel.

Yes, this is the last patch I'm I'm going to send you today.  Thanks for
your time.

=3D=3D=3D
=20
Author: Stephen Frost <sfrost@snowman.net>

This module is used for creating one or many list(s) of recently seen IP=20
addresses and then matching against that/those list(s).


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-enh_ipt/include/linux/=
netfilter_ipv4/ipt_recent.h linux-2.5.73-ipt_recent/include/linux/netfilter=
_ipv4/ipt_recent.h
--- linux-2.5.73-enh_ipt/include/linux/netfilter_ipv4/ipt_recent.h	1970-01-=
01 01:00:00.000000000 +0100
+++ linux-2.5.73-ipt_recent/include/linux/netfilter_ipv4/ipt_recent.h	2003-=
06-24 20:48:29.000000000 +0200
@@ -0,0 +1,27 @@
+#ifndef _IPT_RECENT_H
+#define _IPT_RECENT_H
+
+#define RECENT_NAME	"ipt_recent"
+#define RECENT_VER	"v0.3.1"
+
+#define IPT_RECENT_CHECK  1
+#define IPT_RECENT_SET    2
+#define IPT_RECENT_UPDATE 4
+#define IPT_RECENT_REMOVE 8
+#define IPT_RECENT_TTL   16
+
+#define IPT_RECENT_SOURCE 0
+#define IPT_RECENT_DEST   1
+
+#define IPT_RECENT_NAME_LEN 200
+
+struct ipt_recent_info {
+	u_int32_t   seconds;
+	u_int32_t   hit_count;
+	u_int8_t    check_set;
+	u_int8_t    invert;
+	char        name[IPT_RECENT_NAME_LEN];
+	u_int8_t    side;
+};
+
+#endif /*_IPT_RECENT_H*/
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-enh_ipt/net/ipv4/netfi=
lter/Kconfig linux-2.5.73-ipt_recent/net/ipv4/netfilter/Kconfig
--- linux-2.5.73-enh_ipt/net/ipv4/netfilter/Kconfig	2003-06-22 20:33:09.000=
000000 +0200
+++ linux-2.5.73-ipt_recent/net/ipv4/netfilter/Kconfig	2003-06-24 20:52:20.=
000000000 +0200
@@ -63,7 +63,7 @@
 	tristate "Amanda backup protocol support"
 	depends on IP_NF_CONNTRACK
 	help
-	  If you are running the Amanda backup package (http://www.amanda.org/)
+	  If you are running the Amanda backup package <http://www.amanda.org/>
 	  on this machine or machines that will be MASQUERADED through this
 	  machine, then you may want to enable this feature.  This allows the
 	  connection tracking and natting code to allow the sub-channels that
@@ -161,6 +161,19 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config IP_NF_MATCH_RECENT
+	tristate "recent match support"
+	depends on IP_NF_IPTABLES
+	help
+	  This match is used for creating one or many lists of recently
+	  used addresses and then matching against that/those list(s).
+
+	  Short options are available by using 'iptables -m recent -h'
+	  Official Website: <http://snowman.net/projects/ipt_recent/>
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config IP_NF_MATCH_ECN
 	tristate "ECN match support"
 	depends on IP_NF_IPTABLES
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-enh_ipt/net/ipv4/netfi=
lter/Makefile linux-2.5.73-ipt_recent/net/ipv4/netfilter/Makefile
--- linux-2.5.73-enh_ipt/net/ipv4/netfilter/Makefile	2003-06-22 20:32:37.00=
0000000 +0200
+++ linux-2.5.73-ipt_recent/net/ipv4/netfilter/Makefile	2003-06-24 20:48:44=
=2E000000000 +0200
@@ -49,6 +49,9 @@
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) +=3D ipt_multiport.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+
+obj-$(CONFIG_IP_NF_MATCH_RECENT) +=3D ipt_recent.o
+
 obj-$(CONFIG_IP_NF_MATCH_ECN) +=3D ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) +=3D ipt_dscp.o
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) +=3D ipt_ah.o ipt_esp.o
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-enh_ipt/net/ipv4/netfi=
lter/ipt_recent.c linux-2.5.73-ipt_recent/net/ipv4/netfilter/ipt_recent.c
--- linux-2.5.73-enh_ipt/net/ipv4/netfilter/ipt_recent.c	1970-01-01 01:00:0=
0.000000000 +0100
+++ linux-2.5.73-ipt_recent/net/ipv4/netfilter/ipt_recent.c	2003-06-24 21:0=
5:59.000000000 +0200
@@ -0,0 +1,986 @@
+/* Kernel module to check if the source address has been seen recently. */
+/* Copyright 2002-2003, Stephen Frost, 2.5.x port by laforge@netfilter.org=
 */
+/* Author: Stephen Frost <sfrost@snowman.net> */
+/* Project Page: http://snowman.net/projects/ipt_recent/ */
+/* This software is distributed under the terms of the GPL, Version 2 */
+/* This copyright does not cover user programs that use kernel services
+ * by normal system calls. */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <asm/uaccess.h>
+#include <linux/ctype.h>
+#include <linux/ip.h>
+#include <linux/vmalloc.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_recent.h>
+
+#undef DEBUG
+#define HASH_LOG 9
+
+/* Defaults, these can be overridden on the module command-line. */
+static int ip_list_tot =3D 100;
+static int ip_pkt_list_tot =3D 20;
+static int ip_list_hash_size =3D 0;
+static int ip_list_perms =3D 0644;
+#ifdef DEBUG
+static int debug =3D 1;
+#endif
+
+static char version[] =3D
+KERN_INFO RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>=
=2E  http://snowman.net/projects/ipt_recent/\n";
+
+MODULE_AUTHOR("Stephen Frost <sfrost@snowman.net>");
+MODULE_DESCRIPTION("IP tables recently seen matching module " RECENT_VER);
+MODULE_LICENSE("GPL");
+MODULE_PARM(ip_list_tot,"i");
+MODULE_PARM(ip_pkt_list_tot,"i");
+MODULE_PARM(ip_list_hash_size,"i");
+MODULE_PARM(ip_list_perms,"i");
+#ifdef DEBUG
+MODULE_PARM(debug,"i");
+MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
+#endif
+MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
+MODULE_PARM_DESC(ip_pkt_list_tot,"number of packets per IP to remember");
+MODULE_PARM_DESC(ip_list_hash_size,"size of hash table used to look up IPs=
");
+MODULE_PARM_DESC(ip_list_perms,"permissions on /proc/net/ipt_recent/* file=
s");
+
+/* Structure of our list of recently seen addresses. */
+struct recent_ip_list {
+	u_int32_t addr;
+	u_int8_t  ttl;
+	unsigned long last_seen;
+	unsigned long *last_pkts;
+	u_int32_t oldest_pkt;
+	u_int32_t hash_entry;
+	u_int32_t time_pos;
+};
+
+struct time_info_list {
+	u_int32_t position;
+	u_int32_t time;
+};
+
+/* Structure of our linked list of tables of recent lists. */
+struct recent_ip_tables {
+	char name[IPT_RECENT_NAME_LEN];
+	int count;
+	int time_pos;
+	struct recent_ip_list *table;
+	struct recent_ip_tables *next;
+	spinlock_t list_lock;
+	int *hash_table;
+	struct time_info_list *time_info;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *status_proc;
+#endif /* CONFIG_PROC_FS */
+};
+
+/* Our current list of addresses we have recently seen.
+ * Only added to on a --set, and only updated on --set || --update=20
+ */
+static struct recent_ip_tables *r_tables =3D NULL;
+
+/* We protect r_list with this spinlock so two processors are not modifying
+ * the list at the same time.=20
+ */
+static spinlock_t recent_lock =3D SPIN_LOCK_UNLOCKED;
+
+/* Our /proc/net/ipt_recent entry */
+static struct proc_dir_entry *proc_net_ipt_recent =3D NULL;
+
+/* Function declaration for later. */
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop);
+
+/* Function to hash a given address into the hash table of table_size size=
 */
+int hash_func(unsigned int addr, int table_size)
+{
+	int result =3D 0;
+	unsigned int value =3D addr;
+	do { result ^=3D value; } while((value >>=3D HASH_LOG));
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": %d =3D hash_func(%u,%d)\n",
+			 result & (table_size - 1),
+			 addr,
+			 table_size);
+#endif
+
+	return(result & (table_size - 1));
+}
+
+#ifdef CONFIG_PROC_FS
+/* This is the function which produces the output for our /proc output
+ * interface which lists each IP address, the last seen time and the=20
+ * other recent times the address was seen.
+ */
+
+static int ip_recent_get_info(char *buffer, char **start, off_t offset, in=
t length, int *eof, void *data)
+{
+	int len =3D 0, count, last_len =3D 0, pkt_count;
+	off_t pos =3D 0;
+	off_t begin =3D 0;
+	struct recent_ip_tables *curr_table;
+
+	curr_table =3D (struct recent_ip_tables*) data;
+
+	spin_lock_bh(&curr_table->list_lock);
+	for(count =3D 0; count < ip_list_tot; count++) {
+		if(!curr_table->table[count].addr) continue;
+		last_len =3D len;
+		len +=3D sprintf(buffer+len,"src=3D%u.%u.%u.%u ",NIPQUAD(curr_table->tab=
le[count].addr));
+		len +=3D sprintf(buffer+len,"ttl: %u ",curr_table->table[count].ttl);
+		len +=3D sprintf(buffer+len,"last_seen: %lu ",curr_table->table[count].l=
ast_seen);
+		len +=3D sprintf(buffer+len,"oldest_pkt: %u ",curr_table->table[count].o=
ldest_pkt);
+		len +=3D sprintf(buffer+len,"last_pkts: %lu",curr_table->table[count].la=
st_pkts[0]);
+		for(pkt_count =3D 1; pkt_count < ip_pkt_list_tot; pkt_count++) {
+			if(!curr_table->table[count].last_pkts[pkt_count]) break;
+			len +=3D sprintf(buffer+len,", %lu",curr_table->table[count].last_pkts[=
pkt_count]);
+		}
+		len +=3D sprintf(buffer+len,"\n");
+		pos =3D begin + len;
+		if(pos < offset) { len =3D 0; begin =3D pos; }
+		if(pos > offset + length) { len =3D last_len; break; }
+	}
+
+	*start =3D buffer + (offset - begin);
+	len -=3D (offset - begin);
+	if(len > length) len =3D length;
+
+	spin_unlock_bh(&curr_table->list_lock);
+	return len;
+}
+
+/* ip_recent_ctrl provides an interface for users to modify the table
+ * directly.  This allows adding entries, removing entries, and
+ * flushing the entire table.
+ * This is done by opening up the appropriate table for writing and
+ * sending one of:
+ * xx.xx.xx.xx   -- Add entry to table with current time
+ * +xx.xx.xx.xx  -- Add entry to table with current time
+ * -xx.xx.xx.xx  -- Remove entry from table
+ * clear         -- Flush table, remove all entries
+ */
+
+static int ip_recent_ctrl(struct file *file, const char *input, unsigned l=
ong size, void *data)
+{
+	static const u_int32_t max[4] =3D { 0xffffffff, 0xffffff, 0xffff, 0xff };
+	u_int32_t val;
+	int base, used =3D 0;
+	char c, *cp;
+	union iaddr {
+		uint8_t bytes[4];
+		uint32_t word;
+	} res;
+	uint8_t *pp =3D res.bytes;
+	int digit;
+
+	char buffer[20];
+	int len, check_set =3D 0, count;
+	u_int32_t addr =3D 0;
+	struct sk_buff *skb;
+	struct ipt_recent_info *info;
+	struct recent_ip_tables *curr_table;
+
+	curr_table =3D (struct recent_ip_tables*) data;
+
+	if(size > 20) len =3D 20; else len =3D size;
+
+	if(copy_from_user(buffer,input,len)) return -EFAULT;
+
+	if(len < 20) buffer[len] =3D '\0';
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl len: %d, input: =
`%.20s'\n",len,buffer);
+#endif
+
+	cp =3D buffer;
+	while(isspace(*cp)) { cp++; used++; if(used >=3D len-5) return used; }
+
+	/* Check if we are asked to flush the entire table */
+	if(!memcmp(cp,"clear",5)) {
+		used +=3D 5;
+		spin_lock_bh(&curr_table->list_lock);
+		curr_table->time_pos =3D 0;
+		for(count =3D 0; count < ip_list_hash_size; count++) {
+			curr_table->hash_table[count] =3D -1;
+		}
+		for(count =3D 0; count < ip_list_tot; count++) {
+			curr_table->table[count].last_seen =3D 0;
+			curr_table->table[count].addr =3D 0;
+			curr_table->table[count].ttl =3D 0;
+			memset(curr_table->table[count].last_pkts,0,ip_pkt_list_tot*sizeof(u_in=
t32_t));
+			curr_table->table[count].oldest_pkt =3D 0;
+			curr_table->table[count].time_pos =3D 0;
+			curr_table->time_info[count].position =3D count;
+			curr_table->time_info[count].time =3D 0;
+		}
+		spin_unlock_bh(&curr_table->list_lock);
+		return used;
+	}
+
+        check_set =3D IPT_RECENT_SET;
+	switch(*cp) {
+		case '+': check_set =3D IPT_RECENT_SET; cp++; used++; break;
+		case '-': check_set =3D IPT_RECENT_REMOVE; cp++; used++; break;
+		default: if(!isdigit(*cp)) return (used+1); break;
+	}
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl cp: `%c', check_=
set: %d\n",*cp,check_set);
+#endif
+	/* Get addr (effectively inet_aton()) */
+	/* Shamelessly stolen from libc, a function in the kernel for doing
+	 * this would, of course, be greatly preferred, but our options appear
+	 * to be rather limited, so we will just do it ourselves here.
+	 */
+	res.word =3D 0;
+
+	c =3D *cp;
+	for(;;) {
+		if(!isdigit(c)) return used;
+		val =3D 0; base =3D 10; digit =3D 0;
+		if(c =3D=3D '0') {
+			c =3D *++cp;
+			if(c =3D=3D 'x' || c =3D=3D 'X') base =3D 16, c =3D *++cp;
+			else { base =3D 8; digit =3D 1; }
+		}
+		for(;;) {
+			if(isascii(c) && isdigit(c)) {
+				if(base =3D=3D 8 && (c =3D=3D '8' || c =3D=3D '0')) return used;
+				val =3D (val * base) + (c - '0');
+				c =3D *++cp;
+				digit =3D 1;
+			} else if(base =3D=3D 16 && isascii(c) && isxdigit(c)) {
+				val =3D (val << 4) | (c + 10 - (islower(c) ? 'a' : 'A'));
+				c =3D *++cp;
+				digit =3D 1;
+			} else break;
+		}
+		if(c =3D=3D '.') {
+			if(pp > res.bytes + 2 || val > 0xff) return used;
+			*pp++ =3D val;
+			c =3D *++cp;
+		} else break;
+	}
+	used =3D cp - buffer;
+	if(c !=3D '\0' && (!isascii(c) || !isspace(c))) return used;
+	if(c =3D=3D '\n') used++;
+	if(!digit) return used;
+
+	if(val > max[pp - res.bytes]) return used;
+	addr =3D res.word | htonl(val);
+
+	if(!addr && check_set =3D=3D IPT_RECENT_SET) return used;
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl c: %c, addr: %u =
used: %d\n",c,addr,used);
+#endif
+
+	/* Set up and just call match */
+	info =3D kmalloc(sizeof(struct ipt_recent_info),GFP_KERNEL);
+	if(!info) { return -ENOMEM; }
+	info->seconds =3D 0;
+	info->hit_count =3D 0;
+	info->check_set =3D check_set;
+	info->invert =3D 0;
+	info->side =3D IPT_RECENT_SOURCE;
+	strncpy(info->name,curr_table->name,IPT_RECENT_NAME_LEN);
+	info->name[IPT_RECENT_NAME_LEN-1] =3D '\0';
+
+	skb =3D kmalloc(sizeof(struct sk_buff),GFP_KERNEL);
+	if(!skb) { return -ENOMEM; }
+	skb->nh.iph =3D kmalloc(sizeof(struct iphdr),GFP_KERNEL);
+	if(!skb->nh.iph) { return -ENOMEM; }
+
+	skb->nh.iph->saddr =3D addr;
+	skb->nh.iph->daddr =3D 0;
+	/* Clear ttl since we have no way of knowing it */
+	skb->nh.iph->ttl =3D 0;
+	match(skb,NULL,NULL,info,0,NULL);
+
+	kfree(skb->nh.iph);
+	kfree(skb);
+	kfree(info);
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": Leaving ip_recent_ctrl addr: %u=
 used: %d\n",addr,used);
+#endif
+	return used;
+}
+
+#endif /* CONFIG_PROC_FS */
+
+/* 'match' is our primary function, called by the kernel whenever a rule is
+ * hit with our module as an option to it.
+ * What this function does depends on what was specifically asked of it by
+ * the user:
+ * --set -- Add or update last seen time of the source address of the pack=
et
+ *   -- matchinfo->check_set =3D=3D IPT_RECENT_SET
+ * --rcheck -- Just check if the source address is in the list
+ *   -- matchinfo->check_set =3D=3D IPT_RECENT_CHECK
+ * --update -- If the source address is in the list, update last_seen
+ *   -- matchinfo->check_set =3D=3D IPT_RECENT_UPDATE
+ * --remove -- If the source address is in the list, remove it
+ *   -- matchinfo->check_set =3D=3D IPT_RECENT_REMOVE
+ * --seconds -- Option to --rcheck/--update, only match if last_seen withi=
n seconds
+ *   -- matchinfo->seconds
+ * --hitcount -- Option to --rcheck/--update, only match if seen hitcount =
times
+ *   -- matchinfo->hit_count
+ * --seconds and --hitcount can be combined
+ */
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	int pkt_count, hits_found, ans;
+	unsigned long now;
+	const struct ipt_recent_info *info =3D matchinfo;
+	u_int32_t addr =3D 0, time_temp;
+	u_int8_t ttl =3D skb->nh.iph->ttl;
+	int *hash_table;
+	int orig_hash_result, hash_result, temp, location =3D 0, time_loc, end_co=
llision_chain =3D -1;
+	struct time_info_list *time_info;
+	struct recent_ip_tables *curr_table;
+	struct recent_ip_tables *last_table;
+	struct recent_ip_list *r_list;
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": match() called\n");
+#endif
+
+	/* Default is false ^ info->invert */
+	ans =3D info->invert;
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": match(): name =3D '%s'\n",info-=
>name);
+#endif
+
+	/* if out !=3D NULL then routing has been done and TTL changed.
+	 * We change it back here internally for match what came in before routin=
g. */
+	if(out) ttl++;
+
+	/* Find the right table */
+	spin_lock_bh(&recent_lock);
+	curr_table =3D r_tables;
+	while( (last_table =3D curr_table) && strncmp(info->name,curr_table->name=
,IPT_RECENT_NAME_LEN) && (curr_table =3D curr_table->next) );
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": match(): table found('%s')\n",i=
nfo->name);
+#endif
+
+	spin_unlock_bh(&recent_lock);
+
+	/* Table with this name not found, match impossible */
+	if(!curr_table) { return ans; }
+
+	/* Make sure no one is changing the list while we work with it */
+	spin_lock_bh(&curr_table->list_lock);
+
+	r_list =3D curr_table->table;
+	if(info->side =3D=3D IPT_RECENT_DEST) addr =3D skb->nh.iph->daddr; else a=
ddr =3D skb->nh.iph->saddr;
+
+	if(!addr) {=20
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match() address (%u) invalid, =
leaving.\n",addr);
+#endif
+		spin_unlock_bh(&curr_table->list_lock);
+		return ans;
+	}
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": match(): checking table, addr: =
%u, ttl: %u, orig_ttl: %u\n",addr,ttl,skb->nh.iph->ttl);
+#endif
+
+	/* Get jiffies now in case they changed while we were waiting for a lock =
*/
+	now =3D jiffies;
+	hash_table =3D curr_table->hash_table;
+	time_info =3D curr_table->time_info;
+
+	orig_hash_result =3D hash_result =3D hash_func(addr,ip_list_hash_size);
+	/* Hash entry at this result used */
+	/* Check for TTL match if requested.  If TTL is zero then a match would n=
ever
+	 * happen, so match regardless of existing TTL in that case.  Zero means =
the
+	 * entry was added via the /proc interface anyway, so we will just use the
+	 * first TTL we get for that IP address. */
+	if(info->check_set & IPT_RECENT_TTL) {
+		while(hash_table[hash_result] !=3D -1 && !(r_list[hash_table[hash_result=
]].addr =3D=3D addr &&
+			(!r_list[hash_table[hash_result]].ttl || r_list[hash_table[hash_result]=
].ttl =3D=3D ttl))) {
+			/* Collision in hash table */
+			hash_result =3D (hash_result + 1) % ip_list_hash_size;
+		}
+	} else {
+		while(hash_table[hash_result] !=3D -1 && r_list[hash_table[hash_result]]=
=2Eaddr !=3D addr) {
+			/* Collision in hash table */
+			hash_result =3D (hash_result + 1) % ip_list_hash_size;
+		}
+	}
+
+	if(hash_table[hash_result] =3D=3D -1 && !(info->check_set & IPT_RECENT_SE=
T)) {
+		/* IP not in list and not asked to SET */
+		spin_unlock_bh(&curr_table->list_lock);
+		return ans;
+	}
+
+	/* Check if we need to handle the collision, do not need to on REMOVE */
+	if(orig_hash_result !=3D hash_result && !(info->check_set & IPT_RECENT_RE=
MOVE)) {
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision in hash tab=
le. (or: %d,hr: %d,oa: %u,ha: %u)\n",
+				 orig_hash_result,
+				 hash_result,
+				 r_list[hash_table[orig_hash_result]].addr,
+				 addr);
+#endif
+
+		/* We had a collision.
+		 * orig_hash_result is where we started, hash_result is where we ended u=
p.
+		 * So, swap them because we are likely to see the same guy again sooner =
*/
+#ifdef DEBUG
+		if(debug) {
+		  printk(KERN_INFO RECENT_NAME ": match(): Collision; hash_table[orig_ha=
sh_result] =3D %d\n",hash_table[orig_hash_result]);
+		  printk(KERN_INFO RECENT_NAME ": match(): Collision; r_list[hash_table[=
orig_hash_result]].hash_entry =3D %d\n",
+				r_list[hash_table[orig_hash_result]].hash_entry);
+		}
+#endif
+
+		r_list[hash_table[orig_hash_result]].hash_entry =3D hash_result;
+
+
+		temp =3D hash_table[orig_hash_result];
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision; hash_table=
[hash_result] =3D %d\n",hash_table[hash_result]);
+#endif
+		hash_table[orig_hash_result] =3D hash_table[hash_result];
+		hash_table[hash_result] =3D temp;
+		temp =3D hash_result;
+		hash_result =3D orig_hash_result;
+		orig_hash_result =3D temp;
+		time_info[r_list[hash_table[orig_hash_result]].time_pos].position =3D ha=
sh_table[orig_hash_result];
+		if(hash_table[hash_result] !=3D -1) {
+			r_list[hash_table[hash_result]].hash_entry =3D hash_result;
+			time_info[r_list[hash_table[hash_result]].time_pos].position =3D hash_t=
able[hash_result];
+		}
+
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision handled.\n"=
);
+#endif
+	}
+
+	if(hash_table[hash_result] =3D=3D -1) {
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match(): New table entry. (hr:=
 %d,ha: %u)\n",
+				 hash_result, addr);
+#endif
+
+		/* New item found and IPT_RECENT_SET, so we need to add it */
+		location =3D time_info[curr_table->time_pos].position;
+		hash_table[r_list[location].hash_entry] =3D -1;
+		hash_table[hash_result] =3D location;
+		memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
+		r_list[location].time_pos =3D curr_table->time_pos;
+		r_list[location].addr =3D addr;
+		r_list[location].ttl =3D ttl;
+		r_list[location].last_seen =3D now;
+		r_list[location].oldest_pkt =3D 1;
+		r_list[location].last_pkts[0] =3D now;
+		r_list[location].hash_entry =3D hash_result;
+		time_info[curr_table->time_pos].time =3D r_list[location].last_seen;
+		curr_table->time_pos =3D (curr_table->time_pos + 1) % ip_list_tot;
+
+		ans =3D !info->invert;
+	} else {
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Existing table entry.=
 (hr: %d,ha: %u)\n",
+				 hash_result,
+				 addr);
+#endif
+
+		/* Existing item found */
+		location =3D hash_table[hash_result];
+		/* We have a match on address, now to make sure it meets all requirement=
s for a
+		 * full match. */
+		if(info->check_set & IPT_RECENT_CHECK || info->check_set & IPT_RECENT_UP=
DATE) {
+			if(!info->seconds && !info->hit_count) ans =3D !info->invert; else ans =
=3D info->invert;
+			if(info->seconds && !info->hit_count) {
+				if(time_before_eq(now,r_list[location].last_seen+info->seconds*HZ)) an=
s =3D !info->invert; else ans =3D info->invert;
+			}
+			if(info->seconds && info->hit_count) {
+				for(pkt_count =3D 0, hits_found =3D 0; pkt_count < ip_pkt_list_tot; pk=
t_count++) {
+					if(time_before_eq(now,r_list[location].last_pkts[pkt_count]+info->sec=
onds*HZ)) hits_found++;
+				}
+				if(hits_found >=3D info->hit_count) ans =3D !info->invert; else ans =
=3D info->invert;
+			}
+			if(info->hit_count && !info->seconds) {
+				for(pkt_count =3D 0, hits_found =3D 0; pkt_count < ip_pkt_list_tot; pk=
t_count++) {
+					if(r_list[location].last_pkts[pkt_count] =3D=3D 0) break;
+					hits_found++;
+				}
+				if(hits_found >=3D info->hit_count) ans =3D !info->invert; else ans =
=3D info->invert;
+			}
+		}
+#ifdef DEBUG
+		if(debug) {
+			if(ans)
+				printk(KERN_INFO RECENT_NAME ": match(): match addr: %u\n",addr);
+			else
+				printk(KERN_INFO RECENT_NAME ": match(): no match addr: %u\n",addr);
+		}
+#endif
+
+		/* If and only if we have been asked to SET, or to UPDATE (on match) do =
we add the
+		 * current timestamp to the last_seen. */
+		if((info->check_set & IPT_RECENT_SET && (ans =3D !info->invert)) || (inf=
o->check_set & IPT_RECENT_UPDATE && ans)) {
+#ifdef DEBUG
+			if(debug) printk(KERN_INFO RECENT_NAME ": match(): SET or UPDATE; updat=
ing time info.\n");
+#endif
+			/* Have to update our time info */
+			time_loc =3D r_list[location].time_pos;
+			time_info[time_loc].time =3D now;
+			time_info[time_loc].position =3D location;
+			while((time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc]=
=2Etime) && ((time_loc+1) % ip_list_tot) !=3D curr_table->time_pos) {
+				time_temp =3D time_info[time_loc].time;
+				time_info[time_loc].time =3D time_info[(time_loc+1)%ip_list_tot].time;
+				time_info[(time_loc+1)%ip_list_tot].time =3D time_temp;
+				time_temp =3D time_info[time_loc].position;
+				time_info[time_loc].position =3D time_info[(time_loc+1)%ip_list_tot].p=
osition;
+				time_info[(time_loc+1)%ip_list_tot].position =3D time_temp;
+				r_list[time_info[time_loc].position].time_pos =3D time_loc;
+				r_list[time_info[(time_loc+1)%ip_list_tot].position].time_pos =3D (tim=
e_loc+1)%ip_list_tot;
+				time_loc =3D (time_loc+1) % ip_list_tot;
+			}
+			r_list[location].time_pos =3D time_loc;
+			r_list[location].ttl =3D ttl;
+			r_list[location].last_pkts[r_list[location].oldest_pkt] =3D now;
+			r_list[location].oldest_pkt =3D ++r_list[location].oldest_pkt % ip_pkt_=
list_tot;
+			r_list[location].last_seen =3D now;
+		}
+		/* If we have been asked to remove the entry from the list, just set it =
to 0 */
+		if(info->check_set & IPT_RECENT_REMOVE) {
+#ifdef DEBUG
+			if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; clearing ent=
ry (or: %d, hr: %d).\n",orig_hash_result,hash_result);
+#endif
+			/* Check if this is part of a collision chain */
+			while(hash_table[(orig_hash_result+1) % ip_list_hash_size] !=3D -1) {
+				orig_hash_result++;
+				if(hash_func(r_list[hash_table[orig_hash_result]].addr,ip_list_hash_si=
ze) =3D=3D hash_result) {
+					/* Found collision chain, how deep does this rabbit hole go? */
+#ifdef DEBUG
+					if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; found coll=
ision chain.\n");
+#endif
+					end_collision_chain =3D orig_hash_result;
+				}
+			}
+			if(end_collision_chain !=3D -1) {
+#ifdef DEBUG
+				if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; part of col=
lision chain, moving to end.\n");
+#endif
+				/* Part of a collision chain, swap it with the end of the chain
+				 * before removing. */
+				r_list[hash_table[end_collision_chain]].hash_entry =3D hash_result;
+				temp =3D hash_table[end_collision_chain];
+				hash_table[end_collision_chain] =3D hash_table[hash_result];
+				hash_table[hash_result] =3D temp;
+				time_info[r_list[hash_table[hash_result]].time_pos].position =3D hash_=
table[hash_result];
+				hash_result =3D end_collision_chain;
+				r_list[hash_table[hash_result]].hash_entry =3D hash_result;
+				time_info[r_list[hash_table[hash_result]].time_pos].position =3D hash_=
table[hash_result];
+			}
+			location =3D hash_table[hash_result];
+			hash_table[r_list[location].hash_entry] =3D -1;
+			time_loc =3D r_list[location].time_pos;
+			time_info[time_loc].time =3D 0;
+			time_info[time_loc].position =3D location;
+			while((time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc]=
=2Etime) && ((time_loc+1) % ip_list_tot) !=3D curr_table->time_pos) {
+				time_temp =3D time_info[time_loc].time;
+				time_info[time_loc].time =3D time_info[(time_loc+1)%ip_list_tot].time;
+				time_info[(time_loc+1)%ip_list_tot].time =3D time_temp;
+				time_temp =3D time_info[time_loc].position;
+				time_info[time_loc].position =3D time_info[(time_loc+1)%ip_list_tot].p=
osition;
+				time_info[(time_loc+1)%ip_list_tot].position =3D time_temp;
+				r_list[time_info[time_loc].position].time_pos =3D time_loc;
+				r_list[time_info[(time_loc+1)%ip_list_tot].position].time_pos =3D (tim=
e_loc+1)%ip_list_tot;
+				time_loc =3D (time_loc+1) % ip_list_tot;
+			}
+			r_list[location].time_pos =3D time_loc;
+			r_list[location].last_seen =3D 0;
+			r_list[location].addr =3D 0;
+			r_list[location].ttl =3D 0;
+			memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
+			r_list[location].oldest_pkt =3D 0;
+			ans =3D !info->invert;
+		}
+		spin_unlock_bh(&curr_table->list_lock);
+		return ans;
+	}
+
+	spin_unlock_bh(&curr_table->list_lock);
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": match() left.\n");
+#endif
+	return ans;
+}
+
+/* This function is to verify that the rule given during the userspace ipt=
ables
+ * command is correct.
+ * If the command is valid then we check if the table name referred to by =
the
+ * rule exists, if not it is created.
+ */
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	int flag =3D 0, c;
+	unsigned long *hold;
+	const struct ipt_recent_info *info =3D matchinfo;
+	struct recent_ip_tables *curr_table, *find_table, *last_table;
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() entered.\n");
+#endif
+
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_recent_info))) return 0;
+
+	/* seconds and hit_count only valid for CHECK/UPDATE */
+	if(info->check_set & IPT_RECENT_SET) { flag++; if(info->seconds || info->=
hit_count) return 0; }
+	if(info->check_set & IPT_RECENT_REMOVE) { flag++; if(info->seconds || inf=
o->hit_count) return 0; }
+	if(info->check_set & IPT_RECENT_CHECK) flag++;
+	if(info->check_set & IPT_RECENT_UPDATE) flag++;
+
+	/* One and only one of these should ever be set */
+	if(flag !=3D 1) return 0;
+
+	/* Name must be set to something */
+	if(!info->name || !info->name[0]) return 0;
+
+	/* Things look good, create a list for this if it does not exist */
+	/* Lock the linked list while we play with it */
+	spin_lock_bh(&recent_lock);
+
+	/* Look for an entry with this name already created */
+	/* Finds the end of the list and the entry before the end if current name=
 does not exist */
+	find_table =3D r_tables;
+	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_RECENT_NAME_LEN) && (find_table =3D find_table->next) );
+
+	/* If a table already exists just increment the count on that table and r=
eturn */
+	if(find_table) {=20
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: table found (%s), =
incrementing count.\n",info->name);
+#endif
+		find_table->count++;
+		spin_unlock_bh(&recent_lock);
+		return 1;
+	}
+
+	spin_unlock_bh(&recent_lock);
+
+	/* Table with this name not found */
+	/* Allocate memory for new linked list item */
+
+#ifdef DEBUG
+	if(debug) {
+		printk(KERN_INFO RECENT_NAME ": checkentry: no table found (%s)\n",info-=
>name);
+		printk(KERN_INFO RECENT_NAME ": checkentry: Allocationg %d for link-list=
 entry.\n",sizeof(struct recent_ip_tables));
+	}
+#endif
+
+	curr_table =3D vmalloc(sizeof(struct recent_ip_tables));
+	if(curr_table =3D=3D NULL) return -ENOMEM;
+
+	curr_table->list_lock =3D SPIN_LOCK_UNLOCKED;
+	curr_table->next =3D NULL;
+	curr_table->count =3D 1;
+	curr_table->time_pos =3D 0;
+	strncpy(curr_table->name,info->name,IPT_RECENT_NAME_LEN);
+	curr_table->name[IPT_RECENT_NAME_LEN-1] =3D '\0';
+
+	/* Allocate memory for this table and the list of packets in each entry. =
*/
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for t=
able (%s).\n",
+			sizeof(struct recent_ip_list)*ip_list_tot,
+			info->name);
+#endif
+
+	curr_table->table =3D vmalloc(sizeof(struct recent_ip_list)*ip_list_tot);
+	if(curr_table->table =3D=3D NULL) { vfree(curr_table); return -ENOMEM; }
+	memset(curr_table->table,0,sizeof(struct recent_ip_list)*ip_list_tot);
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for p=
kt_list.\n",
+			sizeof(u_int32_t)*ip_pkt_list_tot*ip_list_tot);
+#endif
+
+	hold =3D vmalloc(sizeof(u_int32_t)*ip_pkt_list_tot*ip_list_tot);
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: After pkt_list allo=
cation.\n");
+#endif
+	if(hold =3D=3D NULL) {=20
+		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for pkt_l=
ist.\n");
+		vfree(curr_table->table);=20
+		vfree(curr_table);
+		return -ENOMEM;
+	}
+	for(c =3D 0; c < ip_list_tot; c++) {
+		curr_table->table[c].last_pkts =3D hold + c*ip_pkt_list_tot;
+	}
+
+	/* Allocate memory for the hash table */
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for h=
ash_table.\n",
+			sizeof(int)*ip_list_hash_size);
+#endif
+
+	curr_table->hash_table =3D vmalloc(sizeof(int)*ip_list_hash_size);
+	if(!curr_table->hash_table) {
+		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for hash_=
table.\n");
+		vfree(hold);
+		vfree(curr_table->table);=20
+		vfree(curr_table);
+		return -ENOMEM;
+	}
+
+	for(c =3D 0; c < ip_list_hash_size; c++) {
+		curr_table->hash_table[c] =3D -1;
+	}
+
+	/* Allocate memory for the time info */
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for t=
ime_info.\n",
+			sizeof(struct time_info_list)*ip_list_tot);
+#endif
+
+	curr_table->time_info =3D vmalloc(sizeof(struct time_info_list)*ip_list_t=
ot);
+	if(!curr_table->time_info) {
+		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for time_=
info.\n");
+		vfree(curr_table->hash_table);
+		vfree(hold);
+		vfree(curr_table->table);=20
+		vfree(curr_table);
+		return -ENOMEM;
+	}
+	for(c =3D 0; c < ip_list_tot; c++) {
+		curr_table->time_info[c].position =3D c;
+		curr_table->time_info[c].time =3D 0;
+	}
+
+	/* Put the new table in place */
+	spin_lock_bh(&recent_lock);
+	find_table =3D r_tables;
+	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_RECENT_NAME_LEN) && (find_table =3D find_table->next) );
+
+	/* If a table already exists just increment the count on that table and r=
eturn */
+	if(find_table) {=20
+		find_table->count++;=09
+		spin_unlock_bh(&recent_lock);
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: table found (%s), =
created by other process.\n",info->name);
+#endif
+		vfree(curr_table->time_info);
+		vfree(curr_table->hash_table);
+		vfree(hold);
+		vfree(curr_table->table);
+		vfree(curr_table);
+		return 1;
+	}
+	if(!last_table) r_tables =3D curr_table; else last_table->next =3D curr_t=
able;
+
+	spin_unlock_bh(&recent_lock);
+
+#ifdef CONFIG_PROC_FS
+	/* Create our proc 'status' entry. */
+	curr_table->status_proc =3D create_proc_entry(curr_table->name, ip_list_p=
erms, proc_net_ipt_recent);
+	if (!curr_table->status_proc) {
+		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for /proc=
 entry.\n");
+		/* Destroy the created table */
+		spin_lock_bh(&recent_lock);
+		last_table =3D NULL;
+		curr_table =3D r_tables;
+		if(!curr_table) {
+#ifdef DEBUG
+			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc fail=
ed, no tables.\n");
+#endif
+			spin_unlock_bh(&recent_lock);
+			return -ENOMEM;
+		}
+		while( strncmp(info->name,curr_table->name,IPT_RECENT_NAME_LEN) && (last=
_table =3D curr_table) && (curr_table =3D curr_table->next) );
+		if(!curr_table) {
+#ifdef DEBUG
+			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc fail=
ed, table already destroyed.\n");
+#endif
+			spin_unlock_bh(&recent_lock);
+			return -ENOMEM;
+		}
+		if(last_table) last_table->next =3D curr_table->next; else r_tables =3D =
curr_table->next;
+		spin_unlock_bh(&recent_lock);
+		vfree(curr_table->time_info);
+		vfree(curr_table->hash_table);
+		vfree(hold);
+		vfree(curr_table->table);
+		vfree(curr_table);
+		return -ENOMEM;
+	}
+=09
+	curr_table->status_proc->owner =3D THIS_MODULE;
+	curr_table->status_proc->data =3D curr_table;
+	wmb();
+	curr_table->status_proc->read_proc =3D ip_recent_get_info;
+	curr_table->status_proc->write_proc =3D ip_recent_ctrl;
+#endif /* CONFIG_PROC_FS */
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() left.\n");
+#endif
+
+	return 1;
+}
+
+/* This function is called in the event that a rule matching this module is
+ * removed.
+ * When this happens we need to check if there are no other rules matching
+ * the table given.  If that is the case then we remove the table and clean
+ * up its memory.
+ */
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	const struct ipt_recent_info *info =3D matchinfo;
+	struct recent_ip_tables *curr_table, *last_table;
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() entered.\n");
+#endif
+
+	if(matchsize !=3D IPT_ALIGN(sizeof(struct ipt_recent_info))) return;
+
+	/* Lock the linked list while we play with it */
+	spin_lock_bh(&recent_lock);
+
+	/* Look for an entry with this name already created */
+	/* Finds the end of the list and the entry before the end if current name=
 does not exist */
+	last_table =3D NULL;
+	curr_table =3D r_tables;
+	if(!curr_table) {=20
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() No tables found, lea=
ving.\n");
+#endif
+		spin_unlock_bh(&recent_lock);
+		return;
+	}
+	while( strncmp(info->name,curr_table->name,IPT_RECENT_NAME_LEN) && (last_=
table =3D curr_table) && (curr_table =3D curr_table->next) );
+
+	/* If a table does not exist then do nothing and return */
+	if(!curr_table) {=20
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table not found, lea=
ving.\n");
+#endif
+		spin_unlock_bh(&recent_lock);
+		return;
+	}
+
+	curr_table->count--;
+
+	/* If count is still non-zero then there are still rules referenceing it =
so we do nothing */
+	if(curr_table->count) {=20
+#ifdef DEBUG
+		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table found, non-zer=
o count, leaving.\n");
+#endif
+		spin_unlock_bh(&recent_lock);
+		return;
+	}
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table found, zero cou=
nt, removing.\n");
+#endif
+
+	/* Count must be zero so we remove this table from the list */
+	if(last_table) last_table->next =3D curr_table->next; else r_tables =3D c=
urr_table->next;
+
+	spin_unlock_bh(&recent_lock);
+
+	/* lock to make sure any late-runners still using this after we removed i=
t from
+	 * the list finish up then remove everything */
+	spin_lock_bh(&curr_table->list_lock);
+	spin_unlock_bh(&curr_table->list_lock);
+
+#ifdef CONFIG_PROC_FS
+	if(curr_table->status_proc) remove_proc_entry(curr_table->name,proc_net_i=
pt_recent);
+#endif /* CONFIG_PROC_FS */
+	vfree(curr_table->table[0].last_pkts);
+	vfree(curr_table->table);
+	vfree(curr_table->hash_table);
+	vfree(curr_table->time_info);
+	vfree(curr_table);
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() left.\n");
+#endif
+
+	return;
+}
+
+/* This is the structure we pass to ipt_register to register our
+ * module with iptables.
+ */
+static struct ipt_match recent_match =3D {=20
+  .name =3D "recent",=20
+  .match =3D &match,=20
+  .checkentry =3D &checkentry,=20
+  .destroy =3D &destroy,=20
+  .me =3D THIS_MODULE
+};
+
+/* Kernel module initialization. */
+static int __init init(void)
+{
+	int count;
+
+	printk(version);
+	proc_net_ipt_recent =3D proc_mkdir("ipt_recent",proc_net);
+	if(!proc_net_ipt_recent) return -ENOMEM;
+
+	if(ip_list_hash_size && ip_list_hash_size <=3D ip_list_tot) {
+	  printk(KERN_WARNING RECENT_NAME ": ip_list_hash_size too small, resetti=
ng to default.\n");
+	  ip_list_hash_size =3D 0;
+	}
+
+	if(!ip_list_hash_size) {
+		ip_list_hash_size =3D ip_list_tot*3;
+		count =3D 2*2;
+		while(ip_list_hash_size > count) count =3D count*2;
+		ip_list_hash_size =3D count;
+	}
+
+#ifdef DEBUG
+	if(debug) printk(KERN_INFO RECENT_NAME ": ip_list_hash_size: %d\n",ip_lis=
t_hash_size);
+#endif
+
+	return ipt_register_match(&recent_match);
+}
+
+/* Kernel module destruction. */
+static void __exit fini(void)
+{
+	ipt_unregister_match(&recent_match);
+
+	remove_proc_entry("ipt_recent",proc_net);
+}
+
+/* Register our module with the kernel. */
+module_init(init);
+module_exit(fini);

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8TMLq6GPUuN4DysL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++KJDXaXGVTD0i/8RAm9dAJ9kvsIIQqFdkyO+FExiRZdFJrzxkwCZAVk4
tQ4jxzNEfswTNc5+sWKxx4Y=
=IagO
-----END PGP SIGNATURE-----

--8TMLq6GPUuN4DysL--
