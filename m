From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: NEW: ctstat
Date: 12 May 2003 23:11:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052773872.7215.19.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Azcz+/CDzewDuTM9vrSf"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Azcz+/CDzewDuTM9vrSf
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi

Here's a small patch I wrote a week ago (5 min before the first machine
it's used on went into production so it will have bugs :)

It's a complete ripoff of rtstat but for conntrack.
(rtstat userspace can be found here:
ftp://robur.slu.se/pub/Linux/net-development/rt_cache_stat/rtstat.c
kernelspace has been included in kernel for a long time now)

What it does is to keep per-cpu statistics of diffrent conntrack events
such as connection found in hashtable, new entry allocated etc, in
/proc/net/ip_conntrack_stat

I've attached the patch and userspace-program to make sense of it.

example output:
$ ctstat -i 1
  size  found   new   ins   del     ign   inv  insf    drop edrop    ie      en    ec    ed
 16062   3782    91    81   115       2     7    32       0     0     0       0     0     0
 16051   4000    96    88   107       2     5    42       0     0     0       0     0     0
 16058   4042    89    80    82       0     4    33       0     0     0       0     0     0
 16065   4065    97    85    90       4    11    35       0     0     0       0     0     0
 16079   3589   103    99    89       0    11    48       0     0     0       0     0     0

A description of the diffrent fields can be found in the usage-message
of ctstat.

I can't get some values to add up, like the insf (insert into hashtable
failed because one of the tuples already exists) values.
ins + insf <= new should be true but what I'm seeing is
ins + insf > new.
I havn't looked into it yet.

del should be split up into two fields, removal from hashtable and
deallocation, right now it's just deallocation.

There's probably more that should be changed. This is something I'd like
to see in kernel some day since it makes it a lot easier to see what's
going on and if some extra tuning is needed. It shouldn't add many
cycles to the processing of a packet.

-- 
/Martin

--=-Azcz+/CDzewDuTM9vrSf
Content-Disposition: attachment; filename=ctstat.patch
Content-Type: text/x-patch; name=ctstat.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

diff -x '*.orig' -urpN testpom/linux-2.4.21-rc2/include/linux/netfilter_ipv=
4/ip_conntrack.h linux-2.4.21-rc2.test/include/linux/netfilter_ipv4/ip_conn=
track.h
--- testpom/linux-2.4.21-rc2/include/linux/netfilter_ipv4/ip_conntrack.h	20=
03-05-11 16:35:33.000000000 +0200
+++ linux-2.4.21-rc2.test/include/linux/netfilter_ipv4/ip_conntrack.h	2003-=
05-12 22:49:47.000000000 +0200
@@ -266,5 +266,23 @@ static inline int is_confirmed(struct ip
 }
=20
 extern unsigned int ip_conntrack_htable_size;
+
+struct ip_conntrack_stat
+{
+	unsigned int found;
+	unsigned int new;
+	unsigned int invalid;
+	unsigned int ignore;
+	unsigned int delete;
+	unsigned int insert;
+	unsigned int insert_failed;
+	unsigned int drop;
+	unsigned int early_drop;
+	unsigned int icmp_error;
+	unsigned int expect_new;
+	unsigned int expect_create;
+	unsigned int expect_delete;
+} ____cacheline_aligned_in_smp;
+
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -x '*.orig' -urpN testpom/linux-2.4.21-rc2/net/ipv4/netfilter/ip_connt=
rack_core.c linux-2.4.21-rc2.test/net/ipv4/netfilter/ip_conntrack_core.c
--- testpom/linux-2.4.21-rc2/net/ipv4/netfilter/ip_conntrack_core.c	2003-05=
-11 16:35:34.000000000 +0200
+++ linux-2.4.21-rc2.test/net/ipv4/netfilter/ip_conntrack_core.c	2003-05-12=
 22:49:47.000000000 +0200
@@ -61,10 +61,12 @@ LIST_HEAD(protocol_list);
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size =3D 0;
 static int ip_conntrack_max =3D 0;
-static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
+atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
=20
+struct ip_conntrack_stat ip_conntrack_stat[NR_CPUS];
+
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
=20
 static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
@@ -179,6 +181,7 @@ destroy_expect(struct ip_conntrack_expec
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
=20
 	kfree(exp);
+	ip_conntrack_stat[smp_processor_id()].expect_delete++;
 }
=20
=20
@@ -342,6 +345,7 @@ destroy_conntrack(struct nf_conntrack *n
 	DEBUGP("destroy_conntrack: returning ct=3D%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
+	ip_conntrack_stat[smp_processor_id()].delete++;
 }
=20
 static void death_by_timeout(unsigned long ul_conntrack)
@@ -469,10 +473,12 @@ __ip_conntrack_confirm(struct nf_ct_info
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		ip_conntrack_stat[smp_processor_id()].insert++;
 		return NF_ACCEPT;
 	}
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
+	ip_conntrack_stat[smp_processor_id()].insert_failed++;
 	return NF_DROP;
 }
=20
@@ -607,6 +613,7 @@ static int early_drop(struct list_head *
 	if (del_timer(&h->ctrack->timeout)) {
 		death_by_timeout((unsigned long)h->ctrack);
 		dropped =3D 1;
+		ip_conntrack_stat[smp_processor_id()].early_drop++;
 	}
 	ip_conntrack_put(h->ctrack);
 	return dropped;
@@ -731,12 +738,16 @@ init_conntrack(const struct ip_conntrack
 		LIST_DELETE(&ip_conntrack_expect_list, expected);
 		expected->expectant->expecting--;
 		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
-	}
+		ip_conntrack_stat[smp_processor_id()].expect_new++;
+	} else
+		ip_conntrack_stat[smp_processor_id()].new++;
+
 	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
 	if (expected && expected->expectfn)
 		expected->expectfn(conntrack);
+
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
=20
@@ -764,7 +775,8 @@ resolve_normal_ct(struct sk_buff *skb,
 			return NULL;
 		if (IS_ERR(h))
 			return (void *)h;
-	}
+	} else
+		ip_conntrack_stat[smp_processor_id()].found++;
=20
 	/* It exists; we have (non-exclusive) reference. */
 	if (DIRECTION(h) =3D=3D IP_CT_DIR_REPLY) {
@@ -825,8 +837,10 @@ unsigned int ip_conntrack_in(unsigned in
=20
 	/* Previously seen (loopback)?  Ignore.  Do this before
            fragment check. */
-	if ((*pskb)->nfct)
+	if ((*pskb)->nfct) {
+		ip_conntrack_stat[smp_processor_id()].ignore++;
 		return NF_ACCEPT;
+	}
=20
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
@@ -839,22 +853,29 @@ unsigned int ip_conntrack_in(unsigned in
=20
 	/* It may be an icmp error... */
 	if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP=20
-	    && icmp_error_track(*pskb, &ctinfo, hooknum))
+	    && icmp_error_track(*pskb, &ctinfo, hooknum)) {
+		ip_conntrack_stat[smp_processor_id()].icmp_error++;
 		return NF_ACCEPT;
+	}
=20
-	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
+	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))=
 {
 		/* Not valid part of a connection */
+		ip_conntrack_stat[smp_processor_id()].invalid++;
 		return NF_ACCEPT;
+	}
=20
-	if (IS_ERR(ct))
+	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
+		ip_conntrack_stat[smp_processor_id()].drop;
 		return NF_DROP;
+	}
=20
 	IP_NF_ASSERT((*pskb)->nfct);
=20
 	ret =3D proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
 	if (ret =3D=3D -1) {
 		/* Invalid */
+		ip_conntrack_stat[smp_processor_id()].invalid++;
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct =3D NULL;
 		return NF_ACCEPT;
@@ -865,6 +886,7 @@ unsigned int ip_conntrack_in(unsigned in
 				       ct, ctinfo);
 		if (ret =3D=3D -1) {
 			/* Invalid */
+			ip_conntrack_stat[smp_processor_id()].invalid++;
 			nf_conntrack_put((*pskb)->nfct);
 			(*pskb)->nfct =3D NULL;
 			return NF_ACCEPT;
@@ -1063,6 +1085,8 @@ int ip_conntrack_expect_related(struct i
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
+	ip_conntrack_stat[smp_processor_id()].expect_create++;
+
 	return ret;
 }
=20
diff -x '*.orig' -urpN testpom/linux-2.4.21-rc2/net/ipv4/netfilter/ip_connt=
rack_standalone.c linux-2.4.21-rc2.test/net/ipv4/netfilter/ip_conntrack_sta=
ndalone.c
--- testpom/linux-2.4.21-rc2/net/ipv4/netfilter/ip_conntrack_standalone.c	2=
003-05-11 16:35:34.000000000 +0200
+++ linux-2.4.21-rc2.test/net/ipv4/netfilter/ip_conntrack_standalone.c	2003=
-05-12 22:49:47.000000000 +0200
@@ -36,6 +36,9 @@
 struct module *ip_conntrack_module =3D THIS_MODULE;
 MODULE_LICENSE("GPL");
=20
+extern atomic_t ip_conntrack_count;
+extern struct ip_conntrack_stat ip_conntrack_stat[NR_CPUS];
+
 static int kill_proto(const struct ip_conntrack *i, void *data)
 {
 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum =3D=3D=20
@@ -176,6 +179,44 @@ list_conntracks(char *buffer, char **sta
 	return len;
 }
=20
+static int ip_conntrack_get_stat(char *buffer, char **start, off_t offset,=
 int length)
+{
+	unsigned int nr_conntracks =3D atomic_read(&ip_conntrack_count);
+	int i, lcpu;
+	int len =3D 0;
+
+	for (lcpu =3D 0; lcpu < smp_num_cpus; lcpu++) {
+		i =3D cpu_logical_map(lcpu);
+
+		len +=3D sprintf(buffer+len, "%08x  %08x %08x %08x %08x %08x %08x %08x %=
08x %08x %08x  %08x %08x %08x \n",
+				nr_conntracks,
+				ip_conntrack_stat[i].found,
+				ip_conntrack_stat[i].new,
+				ip_conntrack_stat[i].invalid,
+				ip_conntrack_stat[i].ignore,
+				ip_conntrack_stat[i].delete,
+				ip_conntrack_stat[i].insert,
+				ip_conntrack_stat[i].insert_failed,
+				ip_conntrack_stat[i].drop,
+				ip_conntrack_stat[i].early_drop,
+				ip_conntrack_stat[i].icmp_error,
+
+				ip_conntrack_stat[i].expect_new,
+				ip_conntrack_stat[i].expect_create,
+				ip_conntrack_stat[i].expect_delete
+			);
+	}
+	len -=3D offset;
+
+	if (len > length)
+		len =3D length;
+	if (len < 0)
+		len =3D 0;
+
+	*start =3D buffer + offset;
+	return len;
+}
+
 static unsigned int ip_confirm(unsigned int hooknum,
 			       struct sk_buff **pskb,
 			       const struct net_device *in,
@@ -241,7 +282,7 @@ static struct nf_hook_ops ip_conntrack_l
=20
 static int init_or_cleanup(int init)
 {
-	struct proc_dir_entry *proc;
+	struct proc_dir_entry *proc, *procstat;
 	int ret =3D 0;
=20
 	if (!init) goto cleanup;
@@ -251,13 +292,19 @@ static int init_or_cleanup(int init)
 		goto cleanup_nothing;
=20
 	proc =3D proc_net_create("ip_conntrack",0,list_conntracks);
-	if (!proc) goto cleanup_init;
+	if (!proc)
+		goto cleanup_init;
 	proc->owner =3D THIS_MODULE;
=20
+	procstat =3D proc_net_create("ip_conntrack_stat", 0, ip_conntrack_get_sta=
t);
+	if (!procstat)
+		goto cleanup_proc;
+	procstat->owner =3D THIS_MODULE;
+
 	ret =3D nf_register_hook(&ip_conntrack_in_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_proc;
+		goto cleanup_procstat;
 	}
 	ret =3D nf_register_hook(&ip_conntrack_local_out_ops);
 	if (ret < 0) {
@@ -285,6 +332,8 @@ static int init_or_cleanup(int init)
 	nf_unregister_hook(&ip_conntrack_local_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_conntrack_in_ops);
+ cleanup_procstat:
+	proc_net_remove("ip_conntrack_stat");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:

--=-Azcz+/CDzewDuTM9vrSf
Content-Disposition: attachment; filename=ctstat.c
Content-Type: text/x-c; name=ctstat.c; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/* ctstat.c:  A program for ip_conntrack monitoring
 *
 * Copyright 2001 by Robert Olsson <robert.olsson@its.uu.se>
 *                                 Uppsala University, Sweden
 * Modified from rtstat.c into ctstat.c by Martin Josefsson
 * 					   <gandalf@wlug.westbo.se>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Additional credits:
 * Martin Josefsson <gandalf@wlug.westbo.se> 010828 bug fix
 *					     030420 cleanup
 *=20
 */

#include <stdio.h>
#include <unistd.h>
#include <getopt.h>

#define VERSION "0.35-ct1 030430"

extern char *optarg;
extern int optind, opterr, optopt;

FILE *fp;
unsigned ct_size, found[2], new[2], invalid[2],=20
  ignore[2], delete[2], insert[2], insert_failed[2],
  drop[2], early_drop[2], icmp_error[2], expect_new[2],=20
  expect_create[2], expect_delete[2];


/* Read (and summarize for SMP) the different stats vars. */

void scan_line(int i)
{
	unsigned temp[14];
=09
	i %=3D 2;

	found[i] =3D 0;
	new[i] =3D 0;
	invalid[i] =3D 0;
	ignore[i] =3D 0;
	delete[i] =3D 0;
	insert[i] =3D 0;
	insert_failed[i] =3D 0;
	drop[i] =3D 0;
	early_drop[i] =3D 0;
	icmp_error[i] =3D 0;
	expect_new[i] =3D 0;
	expect_create[i] =3D 0;
	expect_delete[i] =3D 0;


	while(!feof(fp)) {
		fscanf(fp, "%x %x %x %x %x %x %x %x %x %x %x %x %x %x\n",=20
		       &ct_size,
		       &temp[0],     /* found */
		       &temp[1],     /* new */
		       &temp[2],     /* invalid */
		       &temp[3],     /* ignore */
		       &temp[4],     /* delete */
		       &temp[5],     /* insert */
		       &temp[6],     /* insert_failed */
		       &temp[7],     /* drop */
		       &temp[8],     /* early_drop */
		       &temp[9],      /* icmp_error */
		       &temp[10],     /* expect_new */
		       &temp[11],     /* expect_create */
		       &temp[12]      /* expect_delete */
		       );

		found[i] +=3D temp[0];
		new[i] +=3D temp[1];
		invalid[i] +=3D temp[2];
		ignore[i] +=3D temp[3];
		delete[i] +=3D temp[4];
		insert[i] +=3D temp[5];
		insert_failed[i] +=3D temp[6];
		drop[i] +=3D temp[7];
		early_drop[i] +=3D temp[8];
		icmp_error[i] +=3D temp[9];
		expect_new[i] +=3D temp[10];
		expect_create[i] +=3D temp[11];
		expect_delete[i] +=3D temp[12];
	}
}

void print_hdr_line(void)
{	=09
	printf("  size  found   new   ins   del     ign   inv  insf    drop edrop =
   ie      en    ec    ed\n");
}

int usage(int exit_code)
{
	fprintf(stderr, "ctstat        Version %s\n", VERSION);
	fprintf(stderr, "              -help\n");
	fprintf(stderr, "              -i interval\n");
	fprintf(stderr, "              -s subject [0-2]\n");=09
	fprintf(stderr, "\n");=09
	print_hdr_line();
	fprintf(stderr, "\n");=09
	fprintf(stderr, "size   =3D=3D ip_conntrack size\n");=09
	fprintf(stderr, "found  =3D=3D found conntrack entries per sec\n");=09
	fprintf(stderr, "new    =3D=3D newly allocated entries per sec\n");
	fprintf(stderr, "ins    =3D=3D inserts into hashtable per sec\n");
	fprintf(stderr, "del    =3D=3D deletions from hashtable per sec\n");
	fprintf(stderr, "ign    =3D=3D ignored packets per sec\n");
	fprintf(stderr, "inv    =3D=3D invalid packets per sec\n");
	fprintf(stderr, "insf   =3D=3D failed inserts into hashtable per sec\n");
	fprintf(stderr, "drop   =3D=3D dropped packets per sec\n");=09
	fprintf(stderr, "edrop  =3D=3D early_dropped packets per sec\n");
	fprintf(stderr, "ie     =3D=3D icmp errors per sec\n");
	fprintf(stderr, "en     =3D=3D expectations used per sec\n");
	fprintf(stderr, "ec     =3D=3D expectations created per sec\n");
	fprintf(stderr, "ed     =3D=3D expectations (unused) deleted per sec\n");

	exit(exit_code);
}

void print(int i, int interval)
{		 =20
	int val_new =3D i % 2;
	int val_old =3D !val_new;

	printf("%6u %6u %5u %5u %5u %7u %5u %5u %7u %5u %5u %7u %5u %5u\n",
	       ct_size,
	       (found[val_new] - found[val_old])/interval,
	       (new[val_new] - new[val_old])/interval,
	       (insert[val_new] - insert[val_old])/interval,
	       (delete[val_new] - delete[val_old])/interval,

	       (ignore[val_new] - ignore[val_old])/interval,
	       (invalid[val_new] - invalid[val_old])/interval,
	       (icmp_error[val_new] - icmp_error[val_old])/interval,

	       (insert_failed[val_new] - insert_failed[val_old])/interval,
	       (drop[val_new] - drop[val_old])/interval,
	       (early_drop[val_new] - early_drop[val_old])/interval,

	       (expect_new[val_new] - expect_new[val_old])/interval,
	       (expect_create[val_new] - expect_create[val_old])/interval,
	       (expect_delete[val_new] - expect_delete[val_old])/interval);
}

int main(int argc, char **argv)
{
	int c, i, interval =3D 2, hdr =3D 2;
 =20
	while ((c=3Dgetopt(argc, argv,"h?s:i:")) !=3D EOF) {
		switch (c)
		{
			case '?':
			case 'h':
				usage(0);
				break;
			=09
			case 'i':
				sscanf(optarg, "%u", &interval);
				break;
=09
			case 's':
				sscanf(optarg, "%u", &hdr);
				break;
=09
			default:
				usage(1);
		}
	}

	if (interval < 1)
		interval =3D 1;

	fp =3D fopen("/proc/net/ip_conntrack_stat", "r");
	if (!fp) {
		perror("fopen");
		exit(-1);
	}

	if (hdr > 0)
		print_hdr_line();

	for(i =3D 0;;i++) {
		if(hdr > 1 && i !=3D 0 && (i % 20) =3D=3D 0)
			print_hdr_line();

		scan_line(i);
		rewind(fp);
		if (i !=3D 0)
			print(i, interval);
		sleep(interval);
	}
	return 1;
}

/*
 * Compile:=20
  gcc -g -O2 -Wall -o ctstat  ctstat.c
*/




--=-Azcz+/CDzewDuTM9vrSf--
