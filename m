From: Stephen Frost <sfrost@snowman.net>
Subject: [PATCH] ipt_recent 0.3.1 Released
Date: Mon, 31 Mar 2003 16:37:57 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331213757.GU18434@ns.snowman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ztQAJXOExAP3xDFw"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
   ipt_recent Users <ipt_recent@snowman.net>
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


--ztQAJXOExAP3xDFw
Content-Type: multipart/mixed; boundary="KSdtjhIkTRrb1Xsv"
Content-Disposition: inline


--KSdtjhIkTRrb1Xsv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey all,

  I've released ipt_recent version 0.3.1.  CVS has the tag for it and
  there are tarballs up on the website.  Attached is a patch against the
  latest netfilter CVS to bring it up to date with version 0.3.1.  The
  high-level changelog is not much different from what I posted to the
  ipt_recent list previously:

  - #ifdef'd out debugging code
  - Cleaned up procfs interaction/failure handling
  - Cleaned up procfs input processing
  - Modified static ints to be #define's in .h
  - Changed to use C99 initializers
  - Added GPL copyright notice
  - Modified libipt_recent.c to be able to compile against older kernels
    (this was actually in netfilter CVS already, not sure from where).

  For a more detailed changelog feel free to look at the CVS repository
  at http://cvs.snowman.net/cgi-bin/viewcvs.cgi/ipt_recent/

	Thanks,

		Stephen

--KSdtjhIkTRrb1Xsv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_recent-0.3.1-netfilter_update.patch"
Content-Transfer-Encoding: quoted-printable

diff -uNr netfilter-cvs/patch-o-matic/extra/recent.patch netfilter/patch-o-=
matic/extra/recent.patch
--- netfilter-cvs/patch-o-matic/extra/recent.patch	2003-03-31 16:16:15.0000=
00000 -0500
+++ netfilter/patch-o-matic/extra/recent.patch	2003-03-31 16:23:14.00000000=
0 -0500
@@ -1,21 +1,21 @@
 diff -uNr linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_recent.h lin=
ux-2.4.20/include/linux/netfilter_ipv4/ipt_recent.h
 --- linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_recent.h	1969-12-3=
1 19:00:00.000000000 -0500
-+++ linux-2.4.20/include/linux/netfilter_ipv4/ipt_recent.h	2003-03-02 13:4=
5:30.000000000 -0500
++++ linux-2.4.20/include/linux/netfilter_ipv4/ipt_recent.h	2003-03-31 16:1=
9:16.000000000 -0500
 @@ -0,0 +1,27 @@
 +#ifndef _IPT_RECENT_H
 +#define _IPT_RECENT_H
 +
 +#define RECENT_NAME	"ipt_recent"
-+#define RECENT_VER	"v0.3.0"
++#define RECENT_VER	"v0.3.1"
 +
-+const static int IPT_RECENT_CHECK =3D 1;
-+const static int IPT_RECENT_SET =3D 2;
-+const static int IPT_RECENT_UPDATE =3D 4;
-+const static int IPT_RECENT_REMOVE =3D 8;
-+const static int IPT_RECENT_TTL =3D 16;
++#define IPT_RECENT_CHECK  1
++#define IPT_RECENT_SET    2
++#define IPT_RECENT_UPDATE 4
++#define IPT_RECENT_REMOVE 8
++#define IPT_RECENT_TTL   16
 +
-+const static int IPT_RECENT_SOURCE =3D 0;
-+const static int IPT_RECENT_DEST =3D 1;
++#define IPT_RECENT_SOURCE 0
++#define IPT_RECENT_DEST   1
 +
 +#define IPT_RECENT_NAME_LEN 200
 +
@@ -31,9 +31,16 @@
 +#endif /*_IPT_RECENT_H*/
 diff -uNr linux-2.4.20-clean/net/ipv4/netfilter/ipt_recent.c linux-2.4.20/=
net/ipv4/netfilter/ipt_recent.c
 --- linux-2.4.20-clean/net/ipv4/netfilter/ipt_recent.c	1969-12-31 19:00:00=
.000000000 -0500
-+++ linux-2.4.20/net/ipv4/netfilter/ipt_recent.c	2003-03-02 13:45:46.00000=
0000 -0500
-@@ -0,0 +1,828 @@
++++ linux-2.4.20/net/ipv4/netfilter/ipt_recent.c	2003-03-31 16:19:01.00000=
0000 -0500
+@@ -0,0 +1,990 @@
 +/* Kernel module to check if the source address has been seen recently. */
++/* Copyright 2002-2003, Stephen Frost */
++/* Author: Stephen Frost <sfrost@snowman.net> */
++/* Project Page: http://snowman.net/projects/ipt_recent/ */
++/* This software is distributed under the terms of the GPL, Version 2 */
++/* This copyright does not cover user programs that use kernel services
++ * by normal system calls. */
++
 +#include <linux/module.h>
 +#include <linux/skbuff.h>
 +#include <linux/proc_fs.h>
@@ -47,6 +54,7 @@
 +#include <linux/netfilter_ipv4/ip_tables.h>
 +#include <linux/netfilter_ipv4/ipt_recent.h>
 +
++#undef DEBUG
 +#define HASH_LOG 9
 +
 +/* Defaults, these can be overridden on the module command-line. */
@@ -54,7 +62,9 @@
 +static int ip_pkt_list_tot =3D 20;
 +static int ip_list_hash_size =3D 0;
 +static int ip_list_perms =3D 0644;
-+static int debug =3D 0;
++#ifdef DEBUG
++static int debug =3D 1;
++#endif
 +
 +static char version[] =3D
 +KERN_INFO RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net=
>.  http://snowman.net/projects/ipt_recent/\n";
@@ -66,7 +76,10 @@
 +MODULE_PARM(ip_pkt_list_tot,"i");
 +MODULE_PARM(ip_list_hash_size,"i");
 +MODULE_PARM(ip_list_perms,"i");
++#ifdef DEBUG
 +MODULE_PARM(debug,"i");
++MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
++#endif
 +MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
 +MODULE_PARM_DESC(ip_pkt_list_tot,"number of packets per IP to remember");
 +MODULE_PARM_DESC(ip_list_hash_size,"size of hash table used to look up IP=
s");
@@ -88,20 +101,6 @@
 +	u_int32_t time;
 +};
 +
-+int hash_func(unsigned int addr, int table_size)
-+{
-+	int result =3D 0;
-+	unsigned int value =3D addr;
-+	do { result ^=3D value; } while((value >>=3D HASH_LOG));
-+
-+	if(debug) printk(KERN_INFO "RECENT_NAME: %d =3D hash_func(%u,%d)\n",
-+			 result & (table_size - 1),
-+			 addr,
-+			 table_size);
-+
-+	return(result & (table_size - 1));
-+}
-+
 +/* Structure of our linked list of tables of recent lists. */
 +struct recent_ip_tables {
 +	char name[IPT_RECENT_NAME_LEN];
@@ -110,9 +109,11 @@
 +	struct recent_ip_list *table;
 +	struct recent_ip_tables *next;
 +	spinlock_t list_lock;
-+	struct proc_dir_entry *status_proc;
 +	int *hash_table;
 +	struct time_info_list *time_info;
++#ifdef CONFIG_PROC_FS
++	struct proc_dir_entry *status_proc;
++#endif /* CONFIG_PROC_FS */
 +};
 +
 +/* Our current list of addresses we have recently seen.
@@ -139,6 +140,24 @@
 +      u_int16_t datalen,
 +      int *hotdrop);
 +
++/* Function to hash a given address into the hash table of table_size siz=
e */
++int hash_func(unsigned int addr, int table_size)
++{
++	int result =3D 0;
++	unsigned int value =3D addr;
++	do { result ^=3D value; } while((value >>=3D HASH_LOG));
++
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": %d =3D hash_func(%u,%d)\n",
++			 result & (table_size - 1),
++			 addr,
++			 table_size);
++#endif
++
++	return(result & (table_size - 1));
++}
++
++#ifdef CONFIG_PROC_FS
 +/* This is the function which produces the output for our /proc output
 + * interface which lists each IP address, the last seen time and the=20
 + * other recent times the address was seen.
@@ -195,7 +214,7 @@
 +{
 +	static const u_int32_t max[4] =3D { 0xffffffff, 0xffffff, 0xffff, 0xff };
 +	u_int32_t val;
-+	int base;
++	int base, used =3D 0;
 +	char c, *cp;
 +	union iaddr {
 +		uint8_t bytes[4];
@@ -204,23 +223,31 @@
 +	uint8_t *pp =3D res.bytes;
 +	int digit;
 +
-+	char buffer[1024];
++	char buffer[20];
 +	int len, check_set =3D 0, count;
 +	u_int32_t addr =3D 0;
-+	struct sk_buff skb;
-+	struct ipt_recent_info info;
++	struct sk_buff *skb;
++	struct ipt_recent_info *info;
 +	struct recent_ip_tables *curr_table;
 +
 +	curr_table =3D (struct recent_ip_tables*) data;
 +
-+	if(size > 1024) len =3D 1024; else len =3D size;
++	if(size > 20) len =3D 20; else len =3D size;
 +
 +	if(copy_from_user(buffer,input,len)) return -EFAULT;
 +
-+	buffer[len-1] =3D '\0';
++	if(len < 20) buffer[len] =3D '\0';
++
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl len: %d, input:=
 `%.20s'\n",len,buffer);
++#endif
++
++	cp =3D buffer;
++	while(isspace(*cp)) { cp++; used++; if(used >=3D len-5) return used; }
 +
 +	/* Check if we are asked to flush the entire table */
-+	if(!strncmp(buffer,"clear",len)) {
++	if(!memcmp(cp,"clear",5)) {
++		used +=3D 5;
 +		spin_lock_bh(&curr_table->list_lock);
 +		curr_table->time_pos =3D 0;
 +		for(count =3D 0; count < ip_list_hash_size; count++) {
@@ -237,15 +264,19 @@
 +			curr_table->time_info[count].time =3D 0;
 +		}
 +		spin_unlock_bh(&curr_table->list_lock);
-+		return len;
++		return used;
 +	}
 +
-+	cp =3D buffer;
-+	if(buffer[0] =3D=3D '+') { check_set =3D IPT_RECENT_SET; cp++; }
-+	if(buffer[0] =3D=3D '-') { check_set =3D IPT_RECENT_REMOVE; cp++; }
-+	if(buffer[0] >=3D '0' && buffer[0] <=3D '9') check_set =3D IPT_RECENT_SE=
T;
-+	if(!check_set) return len;
++        check_set =3D IPT_RECENT_SET;
++	switch(*cp) {
++		case '+': check_set =3D IPT_RECENT_SET; cp++; used++; break;
++		case '-': check_set =3D IPT_RECENT_REMOVE; cp++; used++; break;
++		default: if(!isdigit(*cp)) return (used+1); break;
++	}
 +
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl cp: `%c', check=
_set: %d\n",*cp,check_set);
++#endif
 +	/* Get addr (effectively inet_aton()) */
 +	/* Shamelessly stolen from libc, a function in the kernel for doing
 +	 * this would, of course, be greatly preferred, but our options appear
@@ -255,7 +286,7 @@
 +
 +	c =3D *cp;
 +	for(;;) {
-+		if(!isdigit(c)) return len;
++		if(!isdigit(c)) return used;
 +		val =3D 0; base =3D 10; digit =3D 0;
 +		if(c =3D=3D '0') {
 +			c =3D *++cp;
@@ -264,7 +295,7 @@
 +		}
 +		for(;;) {
 +			if(isascii(c) && isdigit(c)) {
-+				if(base =3D=3D 8 && (c =3D=3D '8' || c =3D=3D '0')) return len;
++				if(base =3D=3D 8 && (c =3D=3D '8' || c =3D=3D '0')) return used;
 +				val =3D (val * base) + (c - '0');
 +				c =3D *++cp;
 +				digit =3D 1;
@@ -275,38 +306,59 @@
 +			} else break;
 +		}
 +		if(c =3D=3D '.') {
-+			if(pp > res.bytes + 2 || val > 0xff) return len;
++			if(pp > res.bytes + 2 || val > 0xff) return used;
 +			*pp++ =3D val;
 +			c =3D *++cp;
 +		} else break;
 +	}
-+	if(c !=3D '\0' && (!isascii(c) || !isspace(c))) return len;
-+	if(!digit) return len;
++	used =3D cp - buffer;
++	if(c !=3D '\0' && (!isascii(c) || !isspace(c))) return used;
++	if(c =3D=3D '\n') used++;
++	if(!digit) return used;
 +
-+	if(val > max[pp - res.bytes]) return len;
++	if(val > max[pp - res.bytes]) return used;
 +	addr =3D res.word | htonl(val);
 +
-+	if(!addr && check_set =3D=3D IPT_RECENT_SET) return len;
++	if(!addr && check_set =3D=3D IPT_RECENT_SET) return used;
 +
-+	/* Set up and just call match */
-+	info.seconds =3D 0;
-+	info.hit_count =3D 0;
-+	info.check_set =3D check_set;
-+	info.invert =3D 0;
-+	strncpy(info.name,curr_table->name,IPT_RECENT_NAME_LEN);
-+	info.name[IPT_RECENT_NAME_LEN-1] =3D '\0';
-+
-+	skb.nh.iph =3D kmalloc(sizeof(struct iphdr),GFP_ATOMIC);
-+	if(!skb.nh.iph) { return -ENOMEM; }
-+
-+	skb.nh.iph->saddr =3D addr;
-+	skb.nh.iph->daddr =3D addr;
-+	match(&skb,NULL,NULL,&info,0,NULL,sizeof(info),NULL);
-+	kfree(skb.nh.iph);
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": ip_recent_ctrl c: %c, addr: %u=
 used: %d\n",c,addr,used);
++#endif
 +
-+	return len;
++	/* Set up and just call match */
++	info =3D kmalloc(sizeof(struct ipt_recent_info),GFP_KERNEL);
++	if(!info) { return -ENOMEM; }
++	info->seconds =3D 0;
++	info->hit_count =3D 0;
++	info->check_set =3D check_set;
++	info->invert =3D 0;
++	info->side =3D IPT_RECENT_SOURCE;
++	strncpy(info->name,curr_table->name,IPT_RECENT_NAME_LEN);
++	info->name[IPT_RECENT_NAME_LEN-1] =3D '\0';
++
++	skb =3D kmalloc(sizeof(struct sk_buff),GFP_KERNEL);
++	if(!skb) { return -ENOMEM; }
++	skb->nh.iph =3D kmalloc(sizeof(struct iphdr),GFP_KERNEL);
++	if(!skb->nh.iph) { return -ENOMEM; }
++
++	skb->nh.iph->saddr =3D addr;
++	skb->nh.iph->daddr =3D 0;
++	/* Clear ttl since we have no way of knowing it */
++	skb->nh.iph->ttl =3D 0;
++	match(skb,NULL,NULL,info,0,NULL,sizeof(struct ipt_recent_info),NULL);
++
++	kfree(skb->nh.iph);
++	kfree(skb);
++	kfree(info);
++
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": Leaving ip_recent_ctrl addr: %=
u used: %d\n",addr,used);
++#endif
++	return used;
 +}
 +
++#endif /* CONFIG_PROC_FS */
++
 +/* 'match' is our primary function, called by the kernel whenever a rule =
is
 + * hit with our module as an option to it.
 + * What this function does depends on what was specifically asked of it by
@@ -347,12 +399,16 @@
 +	struct recent_ip_tables *last_table;
 +	struct recent_ip_list *r_list;
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: match() called\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": match() called\n");
++#endif
 +
 +	/* Default is false ^ info->invert */
 +	ans =3D info->invert;
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: match(): name =3D '%s'\n",info-=
>name);
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": match(): name =3D '%s'\n",info=
->name);
++#endif
 +
 +	/* if out !=3D NULL then routing has been done and TTL changed.
 +	 * We change it back here internally for match what came in before routi=
ng. */
@@ -363,7 +419,9 @@
 +	curr_table =3D r_tables;
 +	while( (last_table =3D curr_table) && strncmp(info->name,curr_table->nam=
e,IPT_RECENT_NAME_LEN) && (curr_table =3D curr_table->next) );
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: match(): table found('%s')\n",i=
nfo->name);
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": match(): table found('%s')\n",=
info->name);
++#endif
 +
 +	spin_unlock_bh(&recent_lock);
 +
@@ -377,11 +435,17 @@
 +	if(info->side =3D=3D IPT_RECENT_DEST) addr =3D skb->nh.iph->daddr; else =
addr =3D skb->nh.iph->saddr;
 +
 +	if(!addr) {=20
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match() address (%u) invalid, =
leaving.\n",addr);
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match() address (%u) invalid,=
 leaving.\n",addr);
++#endif
 +		spin_unlock_bh(&curr_table->list_lock);
 +		return ans;
 +	}
 +
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": match(): checking table, addr:=
 %u, ttl: %u, orig_ttl: %u\n",addr,ttl,skb->nh.iph->ttl);
++#endif
++
 +	/* Get jiffies now in case they changed while we were waiting for a lock=
 */
 +	now =3D jiffies;
 +	hash_table =3D curr_table->hash_table;
@@ -395,7 +459,7 @@
 +	 * first TTL we get for that IP address. */
 +	if(info->check_set & IPT_RECENT_TTL) {
 +		while(hash_table[hash_result] !=3D -1 && !(r_list[hash_table[hash_resul=
t]].addr =3D=3D addr &&
-+			(!r_list[location].ttl || r_list[location].ttl =3D=3D ttl))) {
++			(!r_list[hash_table[hash_result]].ttl || r_list[hash_table[hash_result=
]].ttl =3D=3D ttl))) {
 +			/* Collision in hash table */
 +			hash_result =3D (hash_result + 1) % ip_list_hash_size;
 +		}
@@ -414,24 +478,32 @@
 +
 +	/* Check if we need to handle the collision, do not need to on REMOVE */
 +	if(orig_hash_result !=3D hash_result && !(info->check_set & IPT_RECENT_R=
EMOVE)) {
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Collision in hash tab=
le. (or: %d,hr: %d,oa: %u,ha: %u)\n",
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision in hash ta=
ble. (or: %d,hr: %d,oa: %u,ha: %u)\n",
 +				 orig_hash_result,
 +				 hash_result,
 +				 r_list[hash_table[orig_hash_result]].addr,
 +				 addr);
++#endif
 +
 +		/* We had a collision.
 +		 * orig_hash_result is where we started, hash_result is where we ended =
up.
 +		 * So, swap them because we are likely to see the same guy again sooner=
 */
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Collision; hash_table=
[orig_hash_result] =3D %d\n",hash_table[orig_hash_result]);
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Collision; r_list[has=
h_table[orig_hash_result]].hash_entry =3D %d\n",
++#ifdef DEBUG
++		if(debug) {
++		  printk(KERN_INFO RECENT_NAME ": match(): Collision; hash_table[orig_h=
ash_result] =3D %d\n",hash_table[orig_hash_result]);
++		  printk(KERN_INFO RECENT_NAME ": match(): Collision; r_list[hash_table=
[orig_hash_result]].hash_entry =3D %d\n",
 +				r_list[hash_table[orig_hash_result]].hash_entry);
++		}
++#endif
 +
 +		r_list[hash_table[orig_hash_result]].hash_entry =3D hash_result;
 +
 +
 +		temp =3D hash_table[orig_hash_result];
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Collision; hash_table=
[hash_result] =3D %d\n",hash_table[hash_result]);
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision; hash_tabl=
e[hash_result] =3D %d\n",hash_table[hash_result]);
++#endif
 +		hash_table[orig_hash_result] =3D hash_table[hash_result];
 +		hash_table[hash_result] =3D temp;
 +		temp =3D hash_result;
@@ -443,12 +515,16 @@
 +			time_info[r_list[hash_table[hash_result]].time_pos].position =3D hash_=
table[hash_result];
 +		}
 +
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Collision handled.\n"=
);
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Collision handled.\n=
");
++#endif
 +	}
 +
 +	if(hash_table[hash_result] =3D=3D -1) {
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): New table entry. (hr:=
 %d,ha: %u)\n",
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match(): New table entry. (hr=
: %d,ha: %u)\n",
 +				 hash_result, addr);
++#endif
 +
 +		/* New item found and IPT_RECENT_SET, so we need to add it */
 +		location =3D time_info[curr_table->time_pos].position;
@@ -467,9 +543,11 @@
 +
 +		ans =3D !info->invert;
 +	} else {
-+		if(debug) printk(KERN_INFO "RECENT_NAME: match(): Existing table entry.=
 (hr: %d,ha: %u)\n",
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": match(): Existing table entry=
. (hr: %d,ha: %u)\n",
 +				 hash_result,
 +				 addr);
++#endif
 +
 +		/* Existing item found */
 +		location =3D hash_table[hash_result];
@@ -494,17 +572,21 @@
 +				if(hits_found >=3D info->hit_count) ans =3D !info->invert; else ans =
=3D info->invert;
 +			}
 +		}
++#ifdef DEBUG
 +		if(debug) {
 +			if(ans)
-+				printk(KERN_INFO "RECENT_NAME: match(): match addr: %u\n",addr);
++				printk(KERN_INFO RECENT_NAME ": match(): match addr: %u\n",addr);
 +			else
-+				printk(KERN_INFO "RECENT_NAME: match(): no match addr: %u\n",addr);
++				printk(KERN_INFO RECENT_NAME ": match(): no match addr: %u\n",addr);
 +		}
++#endif
 +
 +		/* If and only if we have been asked to SET, or to UPDATE (on match) do=
 we add the
 +		 * current timestamp to the last_seen. */
 +		if((info->check_set & IPT_RECENT_SET && (ans =3D !info->invert)) || (in=
fo->check_set & IPT_RECENT_UPDATE && ans)) {
-+			if(debug) printk(KERN_INFO "RECENT_NAME: match(): SET or UPDATE; updat=
ing time info.\n");
++#ifdef DEBUG
++			if(debug) printk(KERN_INFO RECENT_NAME ": match(): SET or UPDATE; upda=
ting time info.\n");
++#endif
 +			/* Have to update our time info */
 +			time_loc =3D r_list[location].time_pos;
 +			time_info[time_loc].time =3D now;
@@ -528,18 +610,24 @@
 +		}
 +		/* If we have been asked to remove the entry from the list, just set it=
 to 0 */
 +		if(info->check_set & IPT_RECENT_REMOVE) {
-+			if(debug) printk(KERN_INFO "RECENT_NAME: match(): REMOVE; clearing ent=
ry (or: %d, hr: %d).\n",orig_hash_result,hash_result);
++#ifdef DEBUG
++			if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; clearing en=
try (or: %d, hr: %d).\n",orig_hash_result,hash_result);
++#endif
 +			/* Check if this is part of a collision chain */
 +			while(hash_table[(orig_hash_result+1) % ip_list_hash_size] !=3D -1) {
 +				orig_hash_result++;
 +				if(hash_func(r_list[hash_table[orig_hash_result]].addr,ip_list_hash_s=
ize) =3D=3D hash_result) {
 +					/* Found collision chain, how deep does this rabbit hole go? */
-+					if(debug) printk(KERN_INFO "RECENT_NAME: match(): REMOVE; found coll=
ision chain.\n");
++#ifdef DEBUG
++					if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; found col=
lision chain.\n");
++#endif
 +					end_collision_chain =3D orig_hash_result;
 +				}
 +			}
 +			if(end_collision_chain !=3D -1) {
-+				if(debug) printk(KERN_INFO "RECENT_NAME: match(): REMOVE; part of col=
lision chain, moving to end.\n");
++#ifdef DEBUG
++				if(debug) printk(KERN_INFO RECENT_NAME ": match(): REMOVE; part of co=
llision chain, moving to end.\n");
++#endif
 +				/* Part of a collision chain, swap it with the end of the chain
 +				 * before removing. */
 +				r_list[hash_table[end_collision_chain]].hash_entry =3D hash_result;
@@ -580,7 +668,9 @@
 +	}
 +
 +	spin_unlock_bh(&curr_table->list_lock);
-+	if(debug) printk(KERN_INFO "RECENT_NAME: match() left.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": match() left.\n");
++#endif
 +	return ans;
 +}
 +
@@ -601,7 +691,9 @@
 +	const struct ipt_recent_info *info =3D matchinfo;
 +	struct recent_ip_tables *curr_table, *find_table, *last_table;
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry() entered.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() entered.\n");
++#endif
 +
 +	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_recent_info))) return 0;
 +
@@ -628,7 +720,9 @@
 +
 +	/* If a table already exists just increment the count on that table and =
return */
 +	if(find_table) {=20
-+		if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: table found (%s), =
incrementing count.\n",info->name);
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: table found (%s),=
 incrementing count.\n",info->name);
++#endif
 +		find_table->count++;
 +		spin_unlock_bh(&recent_lock);
 +		return 1;
@@ -639,9 +733,12 @@
 +	/* Table with this name not found */
 +	/* Allocate memory for new linked list item */
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: no table found (%s)=
\n",info->name);
-+
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: Allocationg %d for =
link-list entry.\n",sizeof(struct recent_ip_tables));
++#ifdef DEBUG
++	if(debug) {
++		printk(KERN_INFO RECENT_NAME ": checkentry: no table found (%s)\n",info=
->name);
++		printk(KERN_INFO RECENT_NAME ": checkentry: Allocationg %d for link-lis=
t entry.\n",sizeof(struct recent_ip_tables));
++	}
++#endif
 +
 +	curr_table =3D vmalloc(sizeof(struct recent_ip_tables));
 +	if(curr_table =3D=3D NULL) return -ENOMEM;
@@ -654,20 +751,26 @@
 +	curr_table->name[IPT_RECENT_NAME_LEN-1] =3D '\0';
 +
 +	/* Allocate memory for this table and the list of packets in each entry.=
 */
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: Allocating %d for t=
able (%s).\n",
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for =
table (%s).\n",
 +			sizeof(struct recent_ip_list)*ip_list_tot,
 +			info->name);
++#endif
 +
 +	curr_table->table =3D vmalloc(sizeof(struct recent_ip_list)*ip_list_tot);
 +	if(curr_table->table =3D=3D NULL) { vfree(curr_table); return -ENOMEM; }
 +	memset(curr_table->table,0,sizeof(struct recent_ip_list)*ip_list_tot);
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: Allocating %d for p=
kt_list.\n",
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for =
pkt_list.\n",
 +			sizeof(u_int32_t)*ip_pkt_list_tot*ip_list_tot);
++#endif
 +
 +	hold =3D vmalloc(sizeof(u_int32_t)*ip_pkt_list_tot*ip_list_tot);
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: After pkt_list allo=
cation.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: After pkt_list all=
ocation.\n");
++#endif
 +	if(hold =3D=3D NULL) {=20
-+		printk(KERN_INFO "RECENT_NAME: checkentry: unable to allocate for pkt_l=
ist.\n");
++		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for pkt_=
list.\n");
 +		vfree(curr_table->table);=20
 +		vfree(curr_table);
 +		return -ENOMEM;
@@ -677,12 +780,14 @@
 +	}
 +
 +	/* Allocate memory for the hash table */
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: Allocating %d for h=
ash_table.\n",
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for =
hash_table.\n",
 +			sizeof(int)*ip_list_hash_size);
++#endif
 +
 +	curr_table->hash_table =3D vmalloc(sizeof(int)*ip_list_hash_size);
 +	if(!curr_table->hash_table) {
-+		printk(KERN_INFO "RECENT_NAME: checkentry: unable to allocate for hash_=
table.\n");
++		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for hash=
_table.\n");
 +		vfree(hold);
 +		vfree(curr_table->table);=20
 +		vfree(curr_table);
@@ -694,12 +799,14 @@
 +	}
 +
 +	/* Allocate memory for the time info */
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: Allocating %d for t=
ime_info.\n",
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for =
time_info.\n",
 +			sizeof(struct time_info_list)*ip_list_tot);
++#endif
 +
 +	curr_table->time_info =3D vmalloc(sizeof(struct time_info_list)*ip_list_=
tot);
 +	if(!curr_table->time_info) {
-+		printk(KERN_INFO "RECENT_NAME: checkentry: unable to allocate for time_=
info.\n");
++		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for time=
_info.\n");
 +		vfree(curr_table->hash_table);
 +		vfree(hold);
 +		vfree(curr_table->table);=20
@@ -718,8 +825,11 @@
 +
 +	/* If a table already exists just increment the count on that table and =
return */
 +	if(find_table) {=20
++		find_table->count++;=09
 +		spin_unlock_bh(&recent_lock);
-+		if(debug) printk(KERN_INFO "RECENT_NAME: checkentry: table found (%s), =
created by other process.\n",info->name);
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: table found (%s),=
 created by other process.\n",info->name);
++#endif
 +		vfree(curr_table->time_info);
 +		vfree(curr_table->hash_table);
 +		vfree(hold);
@@ -731,19 +841,50 @@
 +
 +	spin_unlock_bh(&recent_lock);
 +
++#ifdef CONFIG_PROC_FS
 +	/* Create our proc 'status' entry. */
 +	curr_table->status_proc =3D create_proc_entry(curr_table->name, ip_list_=
perms, proc_net_ipt_recent);
-+	if (curr_table->status_proc) curr_table->status_proc->owner =3D THIS_MOD=
ULE;
-+	else {
-+		/* The proc entry is not that important, if everything else works,
-+		 * just ignore that it failed */
-+		return 1;
++	if (!curr_table->status_proc) {
++		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for /pro=
c entry.\n");
++		/* Destroy the created table */
++		spin_lock_bh(&recent_lock);
++		last_table =3D NULL;
++		curr_table =3D r_tables;
++		if(!curr_table) {
++#ifdef DEBUG
++			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc fai=
led, no tables.\n");
++#endif
++			spin_unlock_bh(&recent_lock);
++			return -ENOMEM;
++		}
++		while( strncmp(info->name,curr_table->name,IPT_RECENT_NAME_LEN) && (las=
t_table =3D curr_table) && (curr_table =3D curr_table->next) );
++		if(!curr_table) {
++#ifdef DEBUG
++			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc fai=
led, table already destroyed.\n");
++#endif
++			spin_unlock_bh(&recent_lock);
++			return -ENOMEM;
++		}
++		if(last_table) last_table->next =3D curr_table->next; else r_tables =3D=
 curr_table->next;
++		spin_unlock_bh(&recent_lock);
++		vfree(curr_table->time_info);
++		vfree(curr_table->hash_table);
++		vfree(hold);
++		vfree(curr_table->table);
++		vfree(curr_table);
++		return -ENOMEM;
 +	}
++=09
++	curr_table->status_proc->owner =3D THIS_MODULE;
++	curr_table->status_proc->data =3D curr_table;
++	wmb();
 +	curr_table->status_proc->read_proc =3D ip_recent_get_info;
 +	curr_table->status_proc->write_proc =3D ip_recent_ctrl;
-+	curr_table->status_proc->data =3D curr_table;
++#endif /* CONFIG_PROC_FS */
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: checkentry() left.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() left.\n");
++#endif
 +
 +	return 1;
 +}
@@ -760,7 +901,9 @@
 +	const struct ipt_recent_info *info =3D matchinfo;
 +	struct recent_ip_tables *curr_table, *last_table;
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: destroy() entered.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() entered.\n");
++#endif
 +
 +	if(matchsize !=3D IPT_ALIGN(sizeof(struct ipt_recent_info))) return;
 +
@@ -772,7 +915,9 @@
 +	last_table =3D NULL;
 +	curr_table =3D r_tables;
 +	if(!curr_table) {=20
-+		if(debug) printk(KERN_INFO "RECENT_NAME: destroy() No tables found, lea=
ving.\n");
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() No tables found, le=
aving.\n");
++#endif
 +		spin_unlock_bh(&recent_lock);
 +		return;
 +	}
@@ -780,7 +925,9 @@
 +
 +	/* If a table does not exist then do nothing and return */
 +	if(!curr_table) {=20
-+		if(debug) printk(KERN_INFO "RECENT_NAME: destroy() table not found, lea=
ving.\n");
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table not found, le=
aving.\n");
++#endif
 +		spin_unlock_bh(&recent_lock);
 +		return;
 +	}
@@ -789,12 +936,16 @@
 +
 +	/* If count is still non-zero then there are still rules referenceing it=
 so we do nothing */
 +	if(curr_table->count) {=20
-+		if(debug) printk(KERN_INFO "RECENT_NAME: destroy() table found, non-zer=
o count, leaving.\n");
++#ifdef DEBUG
++		if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table found, non-ze=
ro count, leaving.\n");
++#endif
 +		spin_unlock_bh(&recent_lock);
 +		return;
 +	}
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: destroy() table found, zero cou=
nt, removing.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() table found, zero co=
unt, removing.\n");
++#endif
 +
 +	/* Count must be zero so we remove this table from the list */
 +	if(last_table) last_table->next =3D curr_table->next; else r_tables =3D =
curr_table->next;
@@ -806,14 +957,18 @@
 +	spin_lock_bh(&curr_table->list_lock);
 +	spin_unlock_bh(&curr_table->list_lock);
 +
++#ifdef CONFIG_PROC_FS
 +	if(curr_table->status_proc) remove_proc_entry(curr_table->name,proc_net_=
ipt_recent);
++#endif /* CONFIG_PROC_FS */
 +	vfree(curr_table->table[0].last_pkts);
 +	vfree(curr_table->table);
 +	vfree(curr_table->hash_table);
 +	vfree(curr_table->time_info);
 +	vfree(curr_table);
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: destroy() left.\n");
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": destroy() left.\n");
++#endif
 +
 +	return;
 +}
@@ -821,8 +976,13 @@
 +/* This is the structure we pass to ipt_register to register our
 + * module with iptables.
 + */
-+static struct ipt_match recent_match
-+=3D { { NULL, NULL }, "recent", &match, &checkentry, &destroy, THIS_MODUL=
E };
++static struct ipt_match recent_match =3D {=20
++  .name =3D "recent",=20
++  .match =3D &match,=20
++  .checkentry =3D &checkentry,=20
++  .destroy =3D &destroy,=20
++  .me =3D THIS_MODULE
++};
 +
 +/* Kernel module initialization. */
 +static int __init init(void)
@@ -834,7 +994,7 @@
 +	if(!proc_net_ipt_recent) return -ENOMEM;
 +
 +	if(ip_list_hash_size && ip_list_hash_size <=3D ip_list_tot) {
-+	  printk(KERN_WARNING "RECENT_NAME: ip_list_hash_size too small, resetti=
ng to default.\n");
++	  printk(KERN_WARNING RECENT_NAME ": ip_list_hash_size too small, resett=
ing to default.\n");
 +	  ip_list_hash_size =3D 0;
 +	}
 +
@@ -845,7 +1005,9 @@
 +		ip_list_hash_size =3D count;
 +	}
 +
-+	if(debug) printk(KERN_INFO "RECENT_NAME: ip_list_hash_size: %d\n",ip_lis=
t_hash_size);
++#ifdef DEBUG
++	if(debug) printk(KERN_INFO RECENT_NAME ": ip_list_hash_size: %d\n",ip_li=
st_hash_size);
++#endif
 +
 +	return ipt_register_match(&recent_match);
 +}
diff -uNr netfilter-cvs/patch-o-matic/extra/recent.patch.configure.help net=
filter/patch-o-matic/extra/recent.patch.configure.help
--- netfilter-cvs/patch-o-matic/extra/recent.patch.configure.help	2003-03-3=
1 16:16:15.000000000 -0500
+++ netfilter/patch-o-matic/extra/recent.patch.configure.help	2003-03-31 16=
:18:02.000000000 -0500
@@ -1,11 +1,22 @@
 CONFIG_IP_NF_MATCH_TOS
 recent match support
 CONFIG_IP_NF_MATCH_RECENT
-  This option allows you to create lists of recently seen IP
-  addresses and then match against that list based on number of
-  times seen and the time since last seen.  An option is also
-  availible to require a match against TTL in addition to source
-  address.
+  This option allows you to create lists of IP addresses and=20
+  then match against those lists based on if the IP address is=20
+  in the list at all, the number of times seen and the time=20
+  since last seen.  An option is also availible to require a=20
+  match against TTL in addition to source address.  You can=20
+  also read and modify the lists through a /proc filesystem=20
+  interface, if CONFIG_PROC_FS is enabled.  The intent of this
+  module is for it to be used to have dynamically modified IP
+  address lists based on some criteria and for matches to be
+  time-based.  This module can be used for static IP lists
+  too but be sure to use --rcheck instead of --update when
+  checking to avoid extra unnecessary overhead.
+
+  Additional documentation, options, updates and examples are
+  available at the official website:
+  http://snowman.net/projects/ipt_recent/
=20
   If you want to compile it as a module, say M here and read
   Documentation/modules.txt.  If unsure, say `N'.
diff -uNr netfilter-cvs/userspace/extensions/libipt_recent.c netfilter/user=
space/extensions/libipt_recent.c
--- netfilter-cvs/userspace/extensions/libipt_recent.c	2003-03-31 16:16:17.=
000000000 -0500
+++ netfilter/userspace/extensions/libipt_recent.c	2003-03-31 16:30:15.0000=
00000 -0500
@@ -8,17 +8,34 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_recent.h>
=20
-/* need thos two to not fail compilation with old kernel, new userspace */
+/* Need these in order to not fail when compiling against an older kernel.=
 */
 #ifndef RECENT_NAME
 #define RECENT_NAME	"ipt_recent"
 #endif /* RECENT_NAME */
+
 #ifndef RECENT_VER
 #define RECENT_VER	"unknown"
 #endif /* RECENT_VER */
+
 #ifndef IPT_RECENT_NAME_LEN
-#define	IPT_RECENT_NAME_LEN	200
+#define IPT_RECENT_NAME_LEN	200
 #endif /* IPT_RECENT_NAME_LEN */
=20
+/* Options for this module */
+static struct option opts[] =3D {
+	{ .name =3D "set",      .has_arg =3D 0, .flag =3D 0, .val =3D 201 },=20
+	{ .name =3D "rcheck",   .has_arg =3D 0, .flag =3D 0, .val =3D 202 },=20
+	{ .name =3D "update",   .has_arg =3D 0, .flag =3D 0, .val =3D 203 },
+	{ .name =3D "seconds",  .has_arg =3D 1, .flag =3D 0, .val =3D 204 },=20
+	{ .name =3D "hitcount", .has_arg =3D 1, .flag =3D 0, .val =3D 205 },
+	{ .name =3D "remove",   .has_arg =3D 0, .flag =3D 0, .val =3D 206 },
+	{ .name =3D "rttl",     .has_arg =3D 0, .flag =3D 0, .val =3D 207 },
+	{ .name =3D "name",     .has_arg =3D 1, .flag =3D 0, .val =3D 208 },
+	{ .name =3D "rsource",  .has_arg =3D 0, .flag =3D 0, .val =3D 209 },
+	{ .name =3D "rdest",    .has_arg =3D 0, .flag =3D 0, .val =3D 210 },
+	{ .name =3D 0,          .has_arg =3D 0, .flag =3D 0, .val =3D 0   }
+};
+
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -41,28 +58,14 @@
 "                                Useful if you have problems with people s=
poofing their source address in order\n"
 "                                to DoS you via this module.\n"
 "    --name name                 Name of the recent list to be used.  DEFA=
ULT used if none given.\n"
-"    --rsource                   Save the source address of each packet in=
 the recent list table (default).\n"
-"    --rdest                     Save the destination address of each pack=
et in the recent list table.\n"
+"    --rsource                   Match/Save the source address of each pac=
ket in the recent list table (default).\n"
+"    --rdest                     Match/Save the destination address of eac=
h packet in the recent list table.\n"
 RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  http://=
snowman.net/projects/ipt_recent/\n"
 ,
 IPTABLES_VERSION);
=20
 }
  =20
-static struct option opts[] =3D {
-	{ "set", 0, 0, 201 },=20
-	{ "rcheck", 0, 0, 202 },=20
-	{ "update", 0, 0, 203 },
-	{ "seconds", 1, 0, 204 },=20
-	{ "hitcount", 1, 0, 205 },
-	{ "remove",0, 0, 206 },
-	{ "rttl",0, 0, 207},
-	{ "name", 1, 0, 208},
-	{ "rsource", 0, 0, 209},
-	{ "rdest", 0, 0, 210},
-	{0}
-};
-
 /* Initialize the match. */
 static void
 init(struct ipt_entry_match *match, unsigned int *nfcache)
@@ -205,26 +208,26 @@
 	if(info->check_set & IPT_RECENT_REMOVE) printf("--remove ");
 	if(info->seconds) printf("--seconds %d ",info->seconds);
 	if(info->hit_count) printf("--hitcount %d ",info->hit_count);
-	if(info->check_set & IPT_RECENT_TTL) printf("-rttl ");
+	if(info->check_set & IPT_RECENT_TTL) printf("--rttl ");
 	if(info->name) printf("--name %s ",info->name);
 	if(info->side =3D=3D IPT_RECENT_SOURCE) printf("--rsource ");
 	if(info->side =3D=3D IPT_RECENT_DEST) printf("--rdest ");
 }
=20
-static
-struct iptables_match recent
-=3D { NULL,
-    "recent",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+/* Structure for iptables to use to communicate with module */
+static struct iptables_match recent =3D {=20
+    .next          =3D NULL,
+    .name          =3D "recent",
+    .version       =3D IPTABLES_VERSION,
+    .size          =3D IPT_ALIGN(sizeof(struct ipt_recent_info)),
+    .userspacesize =3D IPT_ALIGN(sizeof(struct ipt_recent_info)),
+    .help          =3D &help,
+    .init          =3D &init,
+    .parse         =3D &parse,
+    .final_check   =3D &final_check,
+    .print         =3D &print,
+    .save          =3D &save,
+    .extra_opts    =3D opts
 };
=20
 void _init(void)

--KSdtjhIkTRrb1Xsv--

--ztQAJXOExAP3xDFw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+iLU1rzgMPqB3kigRAr/6AJwLnES3ZNBSq0F1vyqf9V0ZeIfgyQCeOIsy
xApB+M4EZWN7Y1PD1Up5cZE=
=Hlaa
-----END PGP SIGNATURE-----

--ztQAJXOExAP3xDFw--
