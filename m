From: Piotr =?iso-8859-2?Q?Gasid=B3o?= <quaker@ondraszek.eu.org>
Subject: [PATCH] Traffic accounting match
Date: Fri, 12 Dec 2003 19:23:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031212182346.GA21222@moon.ondraszek.ds.polsl.gliwice.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I attach patches for patch-o-matic and i iptables adding my ipt_account
match.=20

Sample description can be found in account.patch.help file.

Homepage (in polish, soon english version):
http://www.barbara.eu.org/~quaker/ipt_account/

Example of practical use:
http://stats.barbara.ds.polsl.gliwice.pl/hosts/

Source:
http://stats.barbara.ds.polsl.gliwice.pl/hosts/source/

This is my first patch for patch-o-matic. Comments welcome.
=20
--=20
Piotr 'QuakeR' Gasid=B3o, just another user @ ondraszek.eu.org
##################### sending lusers to /dev/null since 1998
############ Waiting for tomorrow, for a little ray of light
########## Waiting for tomorrow just to see your smile again

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="account.patch"
Content-Transfer-Encoding: quoted-printable

diff -uNr linux-2.4.22-clean/include/linux/netfilter_ipv4/ipt_account.h l=
inux-2.4.22/include/linux/netfilter_ipv4/ipt_account.h
--- linux-2.4.22-clean/include/linux/netfilter_ipv4/ipt_account.h	1970-01=
-01 01:00:00.000000000 +0100
+++ linux-2.4.22/include/linux/netfilter_ipv4/ipt_account.h	2003-09-06 22=
:23:07.000000000 +0200
@@ -0,0 +1,12 @@
+#ifndef _IPT_ACCOUNT_H_
+#define _IPT_ACCOUNT_H_
+
+#define IPT_ACCOUNT_NAME_LEN 64
+
+struct t_ipt_account_info {
+	char name[IPT_ACCOUNT_NAME_LEN];
+	u_int32_t network;
+	u_int32_t netmask;
+};
+
+#endif
diff -uNr linux-2.4.22-clean/net/ipv4/netfilter/ipt_account.c linux-2.4.2=
2/net/ipv4/netfilter/ipt_account.c
--- linux-2.4.22-clean/net/ipv4/netfilter/ipt_account.c	1970-01-01 01:00:=
00.000000000 +0100
+++ linux-2.4.22/net/ipv4/netfilter/ipt_account.c	2003-09-07 10:27:26.000=
000000 +0200
@@ -0,0 +1,611 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+
+#include <asm/uaccess.h>
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_account.h>
+
+static char version[] =3D
+KERN_INFO "ipt_account 0.1.4 : Piotr Gasid=B3o <quaker@barbara.eu.org>, =
http://www.barbara.eu.org/~quaker/ipt_account/\n";
+
+static int ip_list_perms =3D 0644;	/* prawa */
+static int ip_list_max_mask =3D 17;	/* maksymalna "bezpieczna" netmaska =
*/
+static int ip_list_max_hosts;
+static int debug =3D 0; 			/* tryb odpluskwiania :) */
+
+/* informacje o module */
+MODULE_AUTHOR("Piotr Gasid=B3o <quaker@barbara.eu.org>");
+MODULE_DESCRIPTION("Traffic accounting modules");
+MODULE_LICENSE("GPL");
+MODULE_PARM(ip_list_perms,"i");
+MODULE_PARM_DESC(ip_list_perms,"permissions on /proc/net/ipt_account/* f=
iles");
+MODULE_PARM(ip_list_max_hosts, "i");
+MODULE_PARM_DESC(ip_list_max_hosts, "maximum *save* size of one list (in=
 hosts)");
+#ifdef DEBUG
+MODULE_PARM(debug,"i");
+MODULE_PARM_DESC(debug,"debugging level, defaults to 0");
+#endif
+
+/* jednokierunkowe statystyki */
+struct t_ipt_account_stat {
+	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* statystyki w bajtac=
h */
+	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* statystyki w pakiet=
ach */
+};
+=20
+/* statystyki pojedy=F1czego ip */
+struct t_ipt_account_ip_list {
+	struct t_ipt_account_stat src;
+	struct t_ipt_account_stat dest;
+};
+
+/* struktura opisuj=B1ca pojedy=F1cz=B1 tabele */
+struct t_ipt_account_table {
+	char name[IPT_ACCOUNT_NAME_LEN];			/* nazwa tabeli */
+	struct t_ipt_account_ip_list *ip_list;			/* statystyki poszczeg=F3lnych=
 ip */
+	struct t_ipt_account_table *next;			/* wska=BCnik na nast=EApn=B1 tabel=
=EA */
+	u_int32_t network;					/* adres sieci ... */
+	u_int32_t netmask;					/* ... i jej maska */
+	int use_count;						/* liczba regu=B3ek korzystaj=B1cych z tej tabeli *=
/
+	spinlock_t ip_list_lock;				/* semafor dla dost=EApu do *ip_list */
+	struct proc_dir_entry *status_proc_64;			/* uchwyty do wpis=F3w w /proc=
/net/ipt_account/ */
+	struct proc_dir_entry *status_proc_32;
+};
+
+/* semafor dla dost=EApu do *tables */
+static spinlock_t ipt_account_tables_lock =3D SPIN_LOCK_UNLOCKED;
+
+/* wska=BCnik na wpis /proc/net/ipt_account/ */
+static struct proc_dir_entry *proc_net_ipt_account =3D NULL;
+
+/* lista tabel */
+static struct t_ipt_account_table *ipt_account_tables =3D NULL;
+
+/* procedury odpowiedzialne za odczyt plik=F3w z /proc/net/ipt_account/ =
*/
+static int ip_list_read_proc_64(char *buffer, char **start, off_t offset=
,
+		int length, int *eof, void *data) {
+=09
+	int len =3D 0, last_len =3D 0;
+	off_t pos =3D 0, begin =3D 0;
+
+	u_int32_t address, index;=09
+
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data=
;
+
+	spin_lock(&table->ip_list_lock);
+	for (address =3D table->network; (u_int32_t)(address & table->netmask) =
=3D=3D (u_int32_t)(table->network); address++) {
+		last_len =3D len;	=09
+		index =3D address - table->network;
+			len +=3D sprintf(buffer + len,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_s=
rc =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu p=
ackets_dest =3D %llu %llu %llu %llu %llu\n",
+				HIPQUAD(address),
+				table->ip_list[index].src.b_all,
+				table->ip_list[index].src.b_tcp,
+				table->ip_list[index].src.b_udp,
+				table->ip_list[index].src.b_icmp,
+				table->ip_list[index].src.b_other,
+			=09
+				table->ip_list[index].src.p_all,
+				table->ip_list[index].src.p_tcp,
+				table->ip_list[index].src.p_udp,
+				table->ip_list[index].src.p_icmp,
+				table->ip_list[index].src.p_other,
+			=09
+				table->ip_list[index].dest.b_all,
+				table->ip_list[index].dest.b_tcp,
+				table->ip_list[index].dest.b_udp,
+				table->ip_list[index].dest.b_icmp,
+				table->ip_list[index].dest.b_other,			=09
+			=09
+				table->ip_list[index].dest.p_all,
+				table->ip_list[index].dest.p_tcp,
+				table->ip_list[index].dest.p_udp,
+				table->ip_list[index].dest.p_icmp,
+				table->ip_list[index].dest.p_other
+				);
+		pos =3D begin + len;
+		if (pos < offset) {
+			len =3D 0;
+			begin =3D pos;
+		}
+		if (pos > offset + length) {
+			len =3D last_len;
+			break;
+		}
+	}
+	spin_unlock(&table->ip_list_lock);
+	*start =3D buffer + (offset - begin);
+	len -=3D (offset - begin);
+	if (len > length)
+		len =3D length;
+	return len;
+}
+
+static int ip_list_read_proc_32(char *buffer, char **start, off_t offset=
,
+		int length, int *eof, void *data) {
+=09
+	int len =3D 0, last_len =3D 0;
+	off_t pos =3D 0, begin =3D 0;
+
+	u_int32_t address, index;
+
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data=
;
+=09
+	spin_lock(&table->ip_list_lock);
+	for (address =3D table->network; (u_int32_t)(address & table->netmask) =
=3D=3D (u_int32_t)(table->network); address++) {
+		last_len =3D len;=09
+		index =3D address - table->network;
+		len +=3D sprintf(buffer + len,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %u %u %u %u %u packets_src =3D %u =
%u %u %u %u bytes_dest =3D %u %u %u %u %u packets_dest =3D %u %u %u %u %u=
\n",
+				HIPQUAD(address),
+				(u_int32_t)table->ip_list[index].src.b_all,
+				(u_int32_t)table->ip_list[index].src.b_tcp,
+				(u_int32_t)table->ip_list[index].src.b_udp,
+				(u_int32_t)table->ip_list[index].src.b_icmp,
+				(u_int32_t)table->ip_list[index].src.b_other,
+			=09
+				(u_int32_t)table->ip_list[index].src.p_all,
+				(u_int32_t)table->ip_list[index].src.p_tcp,
+				(u_int32_t)table->ip_list[index].src.p_udp,
+				(u_int32_t)table->ip_list[index].src.p_icmp,
+				(u_int32_t)table->ip_list[index].src.p_other,
+			=09
+				(u_int32_t)table->ip_list[index].dest.b_all,
+				(u_int32_t)table->ip_list[index].dest.b_tcp,
+				(u_int32_t)table->ip_list[index].dest.b_udp,
+				(u_int32_t)table->ip_list[index].dest.b_icmp,
+				(u_int32_t)table->ip_list[index].dest.b_other,
+			=09
+				(u_int32_t)table->ip_list[index].dest.p_all,
+				(u_int32_t)table->ip_list[index].dest.p_tcp,
+				(u_int32_t)table->ip_list[index].dest.p_udp,
+				(u_int32_t)table->ip_list[index].dest.p_icmp,
+				(u_int32_t)table->ip_list[index].dest.p_other
+	=09
+			);
+		pos =3D begin + len;
+		if (pos < offset) {
+			len =3D 0;
+			begin =3D pos;
+		}
+		if (pos > offset + length) {
+			len =3D last_len;
+			break;
+		}	=09
+	}
+	spin_unlock(&table->ip_list_lock);			=09
+	*start =3D buffer + (offset - begin);
+	len -=3D (offset - begin);
+	if (len > length)
+		len =3D length;
+	return len;
+}
+
+/* procedura odpowiedzialna za zapis do plik=F3w w /proc/net/ipt_account=
/ */
+static int ip_list_write_proc(struct file *file, const char *buffer,=20
+		unsigned long length, void *data) {
+
+	int len =3D (length > 1024) ? length : 1024;
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data=
;
+	char kernel_buffer[1024];
+	u_int32_t hosts_count =3D 0xffffffff - table->netmask + 1;
+=09
+	copy_from_user(kernel_buffer, buffer, len);
+	kernel_buffer[len - 1] =3D 0;
+=09
+	if (!strncmp(kernel_buffer, "reset", len)) {
+		spin_lock(&table->ip_list_lock);
+		/* zerowanie statystyk poszczeg=F3lnych host=F3w */
+		memset(table->ip_list, 0, sizeof(struct t_ipt_account_ip_list) * hosts=
_count);
+		spin_unlock(&table->ip_list_lock);
+	}
+=09
+	return len;
+}
+
+/* procedura aktualizuj=B1ca statystyki */
+static void do_account(struct t_ipt_account_stat *stat, u_int8_t proto, =
u_int16_t pktlen) {
+=09
+	stat->b_all +=3D pktlen;
+	stat->p_all++;
+=09
+	switch (proto) {
+		case IPPROTO_TCP:
+			stat->b_tcp +=3D pktlen;
+			stat->p_tcp++;
+			break;
+		case IPPROTO_UDP:
+			stat->b_udp +=3D pktlen;
+			stat->p_udp++;
+			break;
+		case IPPROTO_ICMP:
+			stat->b_icmp +=3D pktlen;
+			stat->p_icmp++;
+			break;
+		default:
+			stat->b_other +=3D pktlen;
+			stat->p_other++;
+	}
+}
+
+/* procedura aktualizuj=B1ca dane w tabeli (predefiniowana przez iptable=
s) */
+static int match(const struct sk_buff *skb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  const void *matchinfo,
+	  int offset,
+	  const void *hdr,
+	  u_int16_t datalen,
+	  int *hotdrop)
+{
+=09
+	const struct t_ipt_account_info *info =3D (struct t_ipt_account_info*)m=
atchinfo;
+	struct t_ipt_account_table *table;
+	int ret;
+
+	u_int32_t address;
+	u_int16_t pktlen;
+	u_int8_t proto;
+=09
+	if (debug) {
+		printk(KERN_INFO "ipt_account: match() entering.\n");
+		printk(KERN_INFO "ipt_account: match() match name =3D %s.\n", info->na=
me);
+	}
+=09
+	spin_lock(&ipt_account_tables_lock);
+	/* znalezienie odpowiedniej tabelu */=09
+	table =3D ipt_account_tables;
+	while (table && strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) =
&& (table =3D table->next));
+	spin_unlock(&ipt_account_tables_lock);
+
+	if (table =3D=3D NULL) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: match() table %s not found. Leaving.\n=
", info->name);
+		return 0;
+	}
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: match() table found %s\n", table->name)=
;
+
+	/* domy=B6lnie regu=B3a "nie pasuje" */
+	ret =3D 0;
+
+	/* pobranie parametr=F3w pakietu (adres, protok=F3l, rozmiar) */=09
+	pktlen =3D skb->len;
+	proto =3D skb->nh.iph->protocol;
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: match() got packet src =3D %u.%u.%u.%u,=
 dst =3D %u.%u.%u.%u, proto =3D %u.\n",
+				 NIPQUAD(skb->nh.iph->saddr),
+				 NIPQUAD(skb->nh.iph->daddr),
+				 proto
+				 );
+
+	/* sprawdzenie adresu =BCr=F3d=B3owego */
+	address =3D ntohl(skb->nh.iph->saddr);
+=09
+	/* sprawdzenie czy pakiet ma by=E6 logowany w tabeli */=09
+	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t=
)table->network)) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%=
u.%u.%u, proto =3D %u.\n",
+					 HIPQUAD(address),
+					 proto
+					 );
+		/* zablokowanie dost=EApu do listy */
+		spin_lock(&table->ip_list_lock);
+		/* zaktualizowanie statystyk dla hosta */
+		do_account(&table->ip_list[(u_int32_t)(address - table->network)].src,=
 proto, pktlen);
+		/* zaktualizowanie statystyk dla wszystkich host=F3w */
+		if (table->netmask !=3D 0xffffffff)
+			do_account(&table->ip_list[0].src, proto, pktlen);
+		/* odblokowanie dost=EApu do listy */
+		spin_unlock(&table->ip_list_lock);
+		/* trafienie */
+		ret =3D 1;
+	}
+
+	/* sprawdzenie adresu docelowego */
+	address =3D ntohl(skb->nh.iph->daddr);
+
+        /* sprawdzenie czy pakiet ma by=E6 logowany w tabeli */
+        if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_=
int32_t)table->network)) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: match() accounting packet dst =3D %u.%=
u.%u.%u, proto =3D %u.\n",
+					HIPQUAD(address),
+					proto
+					);
+		/* zablokowanie dost=EApu do listy */
+		spin_lock(&table->ip_list_lock);
+		/* zaktualizowanie statystyk dla hosta */
+		do_account(&table->ip_list[(u_int32_t)(address - table->network)].dest=
, proto, pktlen);
+		/* zaktualizowanie statystyk dla wszytskich host=F3w */
+		if (table->netmask !=3D 0xffffffff)
+			do_account(&table->ip_list[0].dest, proto, pktlen);
+		/* odblokowanie dost=EApu do listy */
+		spin_unlock(&table->ip_list_lock);
+		/* trafienie */
+		ret =3D 1;
+=09
+	}
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: match() leaving.\n");=09
+
+	return ret;
+=09
+}
+
+/* procedura odpowiedzialna za stworzenie nowego wpisu w *tables (predef=
iniowana przez iptables) */
+
+static int checkentry(const char *tablename,
+	       const struct ipt_ip *ip,
+	       void *matchinfo,
+	       unsigned int matchinfosize,
+	       unsigned int hook_mask)
+{
+	const struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table;
+
+	char proc_entry_name[IPT_ACCOUNT_NAME_LEN + 3];
+
+	u_int32_t hosts_count;
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: checkentry() entering.\n");
+
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
+		return 0;
+=09
+	if (!info->name || !info->name[0])
+		return 0;
+
+	spin_lock(&ipt_account_tables_lock);
+	table =3D ipt_account_tables;
+	while (table && strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) =
&& (table =3D table->next));
+=09
+	if (table) {
+		if (info->network !=3D table->network || info->netmask !=3D table->net=
mask) {
+			printk(KERN_ERR "ipt_account: checkentry() table %s found. But table =
netmask/network %u.%u.%u.%u/%u.%u.%u.%u differs from rule netmask/network=
 %u.%u.%u.%u/%u.%u.%u.%u. Leaving without creating entry.\n",=20
+					table->name,
+					HIPQUAD(table->network),
+					HIPQUAD(table->netmask),
+					HIPQUAD(info->network),
+					HIPQUAD(info->netmask)
+					);
+			spin_unlock(&ipt_account_tables_lock);
+			return 0;
+		}		=09
+		if (debug)
+			printk(KERN_INFO "ipt_account: checkentry() table %s found. Increment=
ing use count (use_count =3D %i). Leaving.\n", table->name, table->use_co=
unt);
+		table->use_count++;
+		spin_unlock(&ipt_account_tables_lock);
+		return 1;
+	};
+=09
+	if (debug)
+		printk(KERN_INFO "ipt_account: checkentry() table %s not found. Creati=
ng.\n", info->name);
+=09
+	table =3D vmalloc(sizeof(struct t_ipt_account_table));
+	if (table =3D=3D NULL) {
+	    if (debug)
+		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate mem=
ory (t_account_table) for table %s. Leaving.\n", info->name);
+	    spin_unlock(&ipt_account_tables_lock);
+	    return -ENOMEM;
+	}
+=09
+	strncpy(table->name, info->name, IPT_ACCOUNT_NAME_LEN);
+	table->use_count =3D 1;
+
+	/*=20
+	 * informacje o tabeli s=B1 pobierane z tabeli a nie z regu=B3ki. Pozwa=
la
+	 * to na stosowanie tej samej tabeli w kilku regu=B3kach, pod warunkiem=
, =BFe
+	 * b=EAdzi logowane to samo (source/dest) i te same network/netmask
+	 */
+=09
+	table->network =3D info->network;
+	table->netmask =3D info->netmask;
+	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
+=09
+	hosts_count =3D 0xffffffff - table->netmask + 1;
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: checkentry() allocating memory for %u h=
osts.\n", hosts_count);
+
+	if (hosts_count > ip_list_max_hosts) {
+		printk(KERN_ERR "ipt_account: checkentry() unable allocate memory for =
%u hosts. Increase value of ip_list_max_hosts parameter.\n", hosts_count)=
;
+		vfree(table);
+		spin_unlock(&ipt_account_tables_lock);
+		return -ENOMEM;
+	}
+
+		=09
+	table->ip_list =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * hosts=
_count);
+	if (table->ip_list =3D=3D NULL) {
+	    if (debug)
+		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate mem=
ory (t_account_ip_list) for table %s. Leaving.\n", table->name);
+	    vfree(table);
+	    spin_unlock(&ipt_account_tables_lock);
+	    return -ENOMEM;
+	}
+
+	memset(table->ip_list, 0, sizeof(struct t_ipt_account_ip_list) * hosts_=
count);
+
+	/* stworzenie dw=F3ch wpis=F3w w /proc, jeden wy=B6wietlaj=B1cy pe=B3ne=
 64-bitowe liczniki *
+	 * drugi wy=B6wietlaj=B1cy tylko liczby 32-bitowe. Ma to na celu wsparc=
ie program=F3w  *
+	 * do wizualizacji (mrtg, rrdtool) w przypadku gdy obs=B3uga liczb 64-b=
itowych nie *
+	 * by=B3a mo=BFliwa (32-bity czyli maksymlanie maksymalnie 4GB/s powinn=
o wystarczy=E6  *
+	 * wi=EAc na cele statystyk ;)                                         =
            */
+=09
+	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
+	strncat(proc_entry_name, "_64", 4);
+=09
+	table->status_proc_64 =3D create_proc_entry(proc_entry_name, ip_list_pe=
rms, proc_net_ipt_account);
+	if (table->status_proc_64 =3D=3D NULL) {	   =20
+	    if (debug)
+		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate mem=
ory (status_proc_64) for table %s. Leaving.\n", table->name);
+	    vfree(table->ip_list);
+	    vfree(table);
+	    spin_unlock(&ipt_account_tables_lock);
+	    return -ENOMEM;
+	}
+
+	table->status_proc_64->owner =3D THIS_MODULE;
+	table->status_proc_64->read_proc =3D ip_list_read_proc_64;
+	table->status_proc_64->write_proc =3D ip_list_write_proc;
+	table->status_proc_64->data =3D table;=09
+
+	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
+	strncat(proc_entry_name, "_32", 4);
+=09
+	table->status_proc_32 =3D create_proc_entry(proc_entry_name, ip_list_pe=
rms, proc_net_ipt_account);
+	if (table->status_proc_32 =3D=3D NULL) {	   =20
+	    if (debug)
+		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate mem=
ory (status_proc_32) for table %s. Leaving.\n", table->name);
+	    vfree(table->ip_list);
+	    vfree(table);
+	    spin_unlock(&ipt_account_tables_lock);
+	    return -ENOMEM;
+	}
+
+	table->status_proc_32->owner =3D THIS_MODULE;
+	table->status_proc_32->read_proc =3D ip_list_read_proc_32;
+	table->status_proc_32->write_proc =3D ip_list_write_proc;
+	table->status_proc_32->data =3D table;
+=09
+	table->next =3D ipt_account_tables;
+	ipt_account_tables =3D table;
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: checkentry() successfully created table=
 %s (use_count =3D %i).\n", table->name, table->use_count);
+
+	spin_unlock(&ipt_account_tables_lock);
+=09
+	if (debug)
+		printk(KERN_INFO "ipt_account: checkentry() leaving.\n");
+	return 1;
+}
+
+/* procedura odpowiedzialna za usuni=EAcie wpisu z *tables (predefiniowa=
na przez iptables) */
+static void destroy(void *matchinfo,=20
+	     unsigned int matchinfosize)
+{
+	const struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table, *last_table;
+	char proc_entry_name[IPT_ACCOUNT_NAME_LEN + 3];
+=09
+	if (debug)
+		printk(KERN_INFO "ipt_account: destroy() entered.\n");
+=09
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
+		return;
+
+	spin_lock(&ipt_account_tables_lock);
+=09
+	table =3D ipt_account_tables;
+
+	if (table =3D=3D NULL) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: destroy() unable to found any tables (=
asked for %s). Leaving.\n", info->name);
+		spin_unlock(&ipt_account_tables_lock);
+		return;
+	}
+=09
+	last_table =3D NULL;
+	while (strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) && (last_=
table =3D table) && (table =3D table->next));
+
+	if (table =3D=3D NULL) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: destroy() unable to found table %s. Le=
aving.\n", info->name);
+		spin_unlock(&ipt_account_tables_lock);
+		return;
+	}
+
+	table->use_count--;
+	if (table->use_count !=3D 0) {
+		if (debug)
+			printk(KERN_INFO "ipt_account: destroy() table %s is still used (use_=
count =3D %i). Leaving.\n", table->name, table->use_count);
+		spin_unlock(&ipt_account_tables_lock);
+		return;
+	}
+
+	if (debug)
+		printk(KERN_INFO "ipt_account: destroy() removing table %s (use_count =
=3D %i).\n", table->name, table->use_count);
+=09
+	if (last_table)
+		last_table->next =3D table->next;
+	else
+		ipt_account_tables =3D table->next;
+=09
+	/* blokada/odblokowanie w przypadku gdy co=B6 czyta plik powi=B1zany z =
tabel=B1 w /proc/net/ipt_account */
+	spin_lock(&table->ip_list_lock);
+	spin_unlock(&table->ip_list_lock);
+=09
+	/* usuni=EAcie wpis=F3w z proc */
+	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
+	strncat(proc_entry_name, "_64", 4);
+	remove_proc_entry(proc_entry_name, proc_net_ipt_account);
+	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
+	strncat(proc_entry_name, "_32", 4);
+	remove_proc_entry(proc_entry_name, proc_net_ipt_account);
+	vfree(table->ip_list);
+	vfree(table);
+
+	spin_unlock(&ipt_account_tables_lock);
+=09
+	if (debug)
+		printk(KERN_INFO "account: destroy() leaving.\n");
+
+	return;
+}
+
+/* opis modu=B3u dla iptables */
+static struct ipt_match account_match =3D {
+	{ NULL, NULL },
+	"account",
+	&match,
+	&checkentry,
+	&destroy,
+	THIS_MODULE
+};
+
+/* procedura inicjalizuj=B1ca modu=B3 */
+static int __init init(void)=20
+{
+	printk(version);=09
+	if (debug)
+		printk(KERN_INFO "account: __init(): ip_list_perms =3D %i, ip_list_max=
_hosts =3D %i\n", ip_list_perms, ip_list_max_mask);			=09
+	/* sprawdzenie parametr=F3w */
+	if (ip_list_max_mask > 32 || ip_list_max_mask < 0) {
+		printk(KERN_ERR "account: Wrong netmask given by ip_list_max_mask para=
meter (%u). Valid is 32 to 0.\n", ip_list_max_mask);
+		return 0;
+	}
+
+	ip_list_max_hosts =3D 0xffffffff - (0xffffffff << ip_list_max_mask) + 1=
;
+=09
+	/* stworzenie katalogu ipt_account w /proc/net */
+	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
+	if (!proc_net_ipt_account)
+		return -ENOMEM;
+
+	return ipt_register_match(&account_match);
+}
+
+/* procedura usuwaj=B1ca modu=B3 */
+static void __exit fini(void)=20
+{
+	ipt_unregister_match(&account_match);
+	/* usuni=EAcie katalogu ipt_account z /proc/net */
+	remove_proc_entry("ipt_account", proc_net);
+}
+
+module_init(init);
+module_exit(fini);
+

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="account.patch.config.in"

  dep_tristate '  TOS match support' CONFIG_IP_NF_MATCH_TOS $CONFIG_IP_NF_IPTABLES
  dep_tristate '  account match support' CONFIG_IP_NF_MATCH_ACCOUNT $CONFIG_IP_NF_IPTABLES

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="account.patch.help"
Content-Transfer-Encoding: quoted-printable

Author: Piotr 'QuakeR' Gasid=B3o <quaker@barbara.eu.org>
Status: Works for me on serveral routers.
Homepage: www.barbara.eu.org/~quaker/ipt_account/

This match allows you to create traffic statistics for whole network=20
with only one iptables rule.

Usage:
       -m account --aname name --aaddr network/netmask

Where:    =20
    --aaddr network with netmask for which statistics will be made.
            Valid examples: 192.168.0.0/24, 10.0.0.0/255.255.0.0 =20
    --aname name of file in /proc/net/ipt_account/ where statistics
            can be read

Module parameters:
    ip_list_perms	permisions for statistics file in /proc/net/ipt_account
    ip_list_max_hosts	maximal number of hosts in one statistics table (mu=
st
                        be set if you want account for larger network tha=
n one
                        with /15 mask.      =20
Example:      =20

    Collect statistics on router for every computer in 192.168.0.0/24
    network:

    # iptables -A FORWARD -m account --aname remote --aaddr 192.168.0.0/2=
4

    Now you can read statistcis, simple by executing command:

    # cat /proc/net/ipt_account/remote_32

    for getting 32-bit counter values, or

    # cat /proc/net/ipt_account/remote_64

    for getting 64-bit counter values.

    Sample line output and it's description:

    ip =3D 192.168.0.0 bytes_src =3D 1458329990 413948125 1034532028 9745=
197 104640=20
                     packets_src =3D 1064597095 1056923548 7558893 109422=
 5232=20
		     bytes_dest =3D 787494488 4213152594 860589034 8615516 104640=20
		     packets_dest =3D 931350673 924591783 6656299 97359 5232

    columns holds byte/packet counters for all traffic, tcp only, udp onl=
y,=20
    icmp only, others (in that order) for src (packet source was from tra=
cked ip)
    and dst (packet destination was to tracked ip)

    First line holds statistics for whole network (network address). Last=
 line holds
    statistics from broadcast address (when broadcast is last address in =
network of
    course).

    Collect statistics for incomming/outgoing trafic from server for
    selected network:

    # iptables -A INPUT -m account --aname local --aaddr 192.168.0.0/24
    # iptables -A OUTPUY -m account --aname local --aaddr 192.168.0.0/24


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="account.patch.makefile"

obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
obj-$(CONFIG_IP_NF_MATCH_ACCOUNT) += ipt_account.o

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="iptables-1.2.8-ipt_account.patch"
Content-Transfer-Encoding: quoted-printable

diff -uNr iptables-1.2.8-clean/extensions/.account-test iptables-1.2.8/ex=
tensions/.account-test
--- iptables-1.2.8-clean/extensions/.account-test	1970-01-01 01:00:00.000=
000000 +0100
+++ iptables-1.2.8/extensions/.account-test	2003-07-15 22:23:49.000000000=
 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if account match patch is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_account.h ] && echo ac=
count
diff -uNr iptables-1.2.8-clean/extensions/libipt_account.c iptables-1.2.8=
/extensions/libipt_account.c
--- iptables-1.2.8-clean/extensions/libipt_account.c	1970-01-01 01:00:00.=
000000000 +0100
+++ iptables-1.2.8/extensions/libipt_account.c	2003-07-03 09:24:42.000000=
000 +0200
@@ -0,0 +1,274 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <iptables.h>
+#include <string.h>
+#include <getopt.h>
+
+#include <linux/netfilter_ipv4/ipt_account.h>
+
+/* definicja z linux/kernel.h pozwalaj=B1ca =B3atwo przekszta=B3ci=E6
+ * adres hosta (format lokalny, nie sieciowy) do postaci "zrozumia=B3ej"
+ * dla cz=B3owieka ;-) */
+
+#ifndef HIPQUAD
+#define HIPQUAD(addr) \
+	((unsigned char *)&addr)[3], \
+	((unsigned char *)&addr)[2], \
+	((unsigned char *)&addr)[1], \
+	((unsigned char *)&addr)[0]
+#endif
+			=09
+/* procedura wy=B6lwietlaj=B1ca pomoc (predefiniowana przez iptables) */=
=20
+=09
+static void help(void) {
+	printf(
+			"account v%s options:\n"
+			"--aaddr network/netmask\n"
+			"	defines network/netmask for hosts for which make statistics\n"
+			"	network/netmask will be compared to source and destination\n"
+			"       address of packet.\n"
+			"--aname name\n"
+			"	defines name of list where statistics will be kept. If no is\n"
+			"	specified DEFAULT will be used.\n"
+
+	,=20
+	IPTABLES_VERSION);
+};
+
+/* parametry na poptrzeby getopt_long (wi=EAcej szczeg=F3=B3=F3w w getop=
t.h) */
+
+static struct option opts[] =3D {
+	{ "aaddr", 1, NULL, 201 },
+	{ "aname", 1, NULL, 202 },
+	{ 0 }
+};
+
+/* przekszta=B3cenie ip (tekst) do postaci u_int32_t */
+
+int parseip(const char *parameter, u_int32_t *ip) {
+=09
+	char buffer[16], *bufferptr, *dot;
+	unsigned int i, shift, part;
+
+	if (strlen(parameter) > 15)
+		return 0;
+
+	strncpy(buffer, parameter, 15);
+	buffer[15] =3D 0;
+
+	bufferptr =3D buffer;
+
+	for (i =3D 0, shift =3D 24, *ip =3D 0; i < 3; i++, shift -=3D 8) {
+		/* brak kropki */
+		if ((dot =3D strchr(bufferptr, '.')) =3D=3D NULL)
+			return 0;
+		/* nie liczba */
+		if ((part =3D strtol(bufferptr, (char**)NULL, 10)) < 0)=20
+			return 0;=09
+		/* na du=BFa liczba */
+		if (part > 255)
+			return 0;
+		*ip |=3D part << shift;	=09
+		bufferptr =3D dot + 1;
+	}
+	/* nie liczba */
+	if ((part =3D strtol(bufferptr, (char**)NULL, 10)) < 0)=20
+		return 0;
+	/* za du=BFa liczba */
+	if (part > 255)
+		return 0;
+	*ip |=3D part;
+	return 1;
+}
+
+/* konwersja adresu sieci (tekst) to postaci u_int32_t */
+
+static void parsenetwork(const char *parameter, u_int32_t *network) {
+	if (!parseip(parameter, network))
+		exit_error(PARAMETER_PROBLEM, "account: wrong ip in network");
+}
+
+/* konwersja maski sieci (w postaci /ilosc_bit=F3w, tekst) do postaci u_=
int32_t */
+
+static void parsenetmaskasbits(const char *parameter, u_int32_t *netmask=
) {
+=09
+	u_int32_t bits;
+=09
+	if ((bits =3D strtol(parameter, (char **)NULL, 10)) < 0 || bits > 32)
+		exit_error(PARAMETER_PROBLEM, "account: wrong netmask");
+
+	*netmask =3D 0xffffffff << (32 - bits);
+}
+
+/* konwersja maski sieci (w postaci /ip, tekst) do postaci u_int32_t */
+
+static void parsenetmaskasip(const char *parameter, u_int32_t *netmask) =
{
+	if (!parseip(parameter, netmask))
+		exit_error(PARAMETER_PROBLEM, "account: wrong ip in netmask");
+}
+
+/* konwersja maski sieci (tekst) do postaci u_int32_t */
+
+static void parsenetmask(const char *parameter, u_int32_t *netmask)=20
+{
+	if (strchr(parameter, '.') !=3D NULL)
+		parsenetmaskasip(parameter, netmask);
+	else
+		parsenetmaskasbits(parameter, netmask);
+}
+
+/* konwersja sieci/maski (tekst) do postaci u_int32_t */
+
+static void parsenetworkandnetmask(const char *parameter, u_int32_t *net=
work, u_int32_t *netmask)=20
+{
+=09
+	char buffer[32], *slash;
+
+	if (strlen(parameter) > 31)
+		exit_error(PARAMETER_PROBLEM, "account: wrong network/netmask");
+
+	strncpy(buffer, parameter, 31);
+	buffer[31] =3D 0;
+
+	if ((slash =3D strchr(buffer, '/')) !=3D NULL) {
+		parsenetmask(slash + 1, netmask);
+		*slash =3D 0;
+	} else
+		*netmask =3D 0xffffffff;
+	parsenetwork(buffer, network);
+
+	if ((*network & *netmask) !=3D *network)
+		exit_error(PARAMETER_PROBLEM, "account: wrong network/netmask");
+}
+
+
+/* procedura odpowiedzialna za odpowiednie "przekszta=B3cenie" sieci/mas=
ki z parametr=F3w
+ * do postaci "zrozumia=B3ej" dla komputera ;-) */
+
+static void parse_network(const char *parameter, struct t_ipt_account_in=
fo *info) {
+
+	parsenetworkandnetmask(parameter, &info->network, &info->netmask);
+=09
+}
+
+/* procedura wywo=B3ywana przed sprawdzeniem parametr=F3w
+ * (predefiniowana przez iptables) */
+
+static void init(struct ipt_entry_match *match,=20
+		 unsigned int *nfcache) {
+=09
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)(match=
)->data;
+
+	*nfcache |=3D NFC_UNKNOWN;
+
+	strncpy(info->name, "DEFAULT", IPT_ACCOUNT_NAME_LEN);
+=09
+}
+
+/* procedura odpowiedzialna za sprawdzenie parametr=F3w
+ * (predefiniowana przez iptables) */
+
+static int parse(int c, char **argv,=20
+		  int invert,=20
+		  unsigned int *flags,
+                  const struct ipt_entry *entry,
+                  unsigned int *nfcache,
+                  struct ipt_entry_match **match) {
+=09
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)(*matc=
h)->data;
+
+	switch (c) {
+	=09
+		/* --aaddr */
+		case 201:
+			parse_network(optarg, info);		=09
+			*flags =3D 1;
+			break;
+		=09
+		/* --aname */
+		case 202:
+			if (strlen(optarg) < IPT_ACCOUNT_NAME_LEN)
+				strncpy(info->name, optarg, IPT_ACCOUNT_NAME_LEN);
+			else
+				exit_error(PARAMETER_PROBLEM, "account: Too long list name");		=09
+			break;=09
+		default:
+			return 0;		=09
+	}
+	return 1;=09
+}
+
+/* procedura odpowiedzialna za zfinalizowanie procesu sprawdzania parame=
tr=F3w
+ * jej dzia=B3anie polega na sprawdzeniu warto=B6ci parametru flags usta=
wionego
+ * wcze=B6niej przez parse */
+
+static void final_check(unsigned int flags) {
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "account: You need specify '--aaddr' par=
ameter");
+}
+
+/* procedura odpowiedzialna za wypisane regu=B3ki w przypadku wykonania
+ * polecenia iptables -L (predefiniowana przez iptables) */
+
+static void print(const struct ipt_ip *ip,
+                  const struct ipt_entry_match *match,=20
+		  int numeric) {
+=09
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)match-=
>data;
+=09
+	printf("account: ");
+	printf("network/netmask: ");
+	printf("%u.%u.%u.%u/%u.%u.%u.%u ",
+			HIPQUAD(info->network),
+			HIPQUAD(info->netmask)
+	      );
+=09
+	printf("name: %s ", info->name);
+}
+
+/* procedura odpowiedzialna za wypisanie regu=B3ki w postaci umo=BFliwia=
j=B1cej jej
+ * zapisanie przez iptables-save (i p=F3=BFniej odtworzenie przez iptabl=
es-restore)
+ * (predefiniowana przez iptables) */
+
+static void save(const struct ipt_ip *ip,=20
+		 const struct ipt_entry_match *match) {
+
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)match-=
>data;
+=09
+	printf("account: ");
+	printf("--aaddr ");
+	printf("%u.%u.%u.%u/%u.%u.%u.%u ",
+			 HIPQUAD(info->network),
+			 HIPQUAD(info->netmask)
+	       );
+=09
+	printf("--aname %s ", info->name);
+}
+=09
+/* opis modu=B3u (predefiniowany przez iptables)
+ * opisuje on, kt=F3re procedury s=B1 odpowiedzialne za poszczeg=F3lne f=
unkcje
+ * (inicjalizacja, sprawdzanie parametr=F3w, wypisanie regu=B3ki, wypisa=
nie
+ * w postaci umo=BFliwiaj=B1cej jej zapisanie przez iptables-save */
+
+static struct iptables_match account =3D {
+	NULL,			/* struct iptables_match *next; */
+	"account",		/* ipt_chainlabel name; */
+	IPTABLES_VERSION,	/* const char *version; */
+	IPT_ALIGN(sizeof(struct t_ipt_account_info)),		/* Size of match data. *=
/
+	IPT_ALIGN(sizeof(struct t_ipt_account_info)),		/* Size of match data re=
levent for userspace comparison purposes */
+	&help,			/* Function which prints out usage message. */
+	&init,			/* Initialize the match. */
+	&parse,			/* Function which parses command options; returns true if it =
ate an option */
+	&final_check,		/* Final check; exit if not ok. */
+	&print,			/* Prints out the match iff non-NULL: put space at end */
+	&save,			/* Saves the match info in parsable form to stdout. */
+	opts			/* Pointer to list of extra command-line options */
+};
+
+/* procedura odpowiedzialna za rejestracje modu=B3u */
+
+void _init(void)
+{
+	register_match(&account);
+}
+=09

--J2SCkAp4GZ/dPZZf--
