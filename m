From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 23:54:13 +0200
Message-ID: <434C3485.2000700@frankengul.org>
References: <20051010164141.GG5627@rama>	<20051010.141518.60492651.davem@davemloft.net>	<20051011104446.GJ4290@rama>
	<20051011175457.GC13415@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011175457.GC13415@rama.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte a =E9crit :

>*sigh*
>
>forgot to attach the patch.
>
>This probably still has the same problem that was reported (oops when
>get_entries() is called).
>
> =20
>
>------------------------------------------------------------------------
>
>diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>--- a/include/linux/cpumask.h
>+++ b/include/linux/cpumask.h
>@@ -392,4 +392,18 @@ extern cpumask_t cpu_present_map;
> #define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_m=
ap)
> #define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_=
map)
>=20
>+/* Find the highest possible smp_processor_id() */
>+static inline unsigned int highest_possible_processor_id(void)
>+{
>+	unsigned int cpu, highest =3D 0;
>+
>+	for_each_cpu_mask(cpu, cpu_possible_map) {
>+		if (cpu > highest)
>+			highest =3D cpu;
>+	}
>+
>+	return highest;
>+}
>+
>+
> #endif /* __LINUX_CPUMASK_H */
>diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebta=
bles.c
>--- a/net/bridge/netfilter/ebtables.c
>+++ b/net/bridge/netfilter/ebtables.c
>@@ -26,6 +26,7 @@
> #include <linux/spinlock.h>
> #include <asm/uaccess.h>
> #include <linux/smp.h>
>+#include <linux/cpumask.h>
> #include <net/sock.h>
> /* needed for logical [in,out]-dev filtering */
> #include "../br_private.h"
>@@ -823,10 +824,11 @@ static int translate_table(struct ebt_re
> 		/* this will get free'd in do_replace()/ebt_register_table()
> 		   if an error occurs */
> 		newinfo->chainstack =3D (struct ebt_chainstack **)
>-		   vmalloc(num_possible_cpus() * sizeof(struct ebt_chainstack));
>+		   vmalloc((highest_possible_processor_id()+1)=20
>+				   		* sizeof(struct ebt_chainstack));
> 		if (!newinfo->chainstack)
> 			return -ENOMEM;
>-		for (i =3D 0; i < num_possible_cpus(); i++) {
>+		for_each_cpu_mask(i, cpu_possible_map) {
> 			newinfo->chainstack[i] =3D
> 			   vmalloc(udc_cnt * sizeof(struct ebt_chainstack));
> 			if (!newinfo->chainstack[i]) {
>@@ -893,11 +895,8 @@ static void get_counters(struct ebt_coun
> 	int i, cpu;
> 	struct ebt_counter *counter_base;
>=20
>-	/* counters of cpu 0 */
>-	memcpy(counters, oldcounters,
>-	   sizeof(struct ebt_counter) * nentries);
> 	/* add other counters to those of cpu 0 */
>-	for (cpu =3D 1; cpu < num_possible_cpus(); cpu++) {
>+	for_each_cpu_mask(cpu, cpu_possible_map) {
> 		counter_base =3D COUNTER_BASE(oldcounters, nentries, cpu);
> 		for (i =3D 0; i < nentries; i++) {
> 			counters[i].pcnt +=3D counter_base[i].pcnt;
>@@ -929,7 +928,8 @@ static int do_replace(void __user *user,
> 		BUGPRINT("Entries_size never zero\n");
> 		return -EINVAL;
> 	}
>-	countersize =3D COUNTER_OFFSET(tmp.nentries) * num_possible_cpus();
>+	countersize =3D COUNTER_OFFSET(tmp.nentries) *=20
>+					(highest_possible_processor_id()+1);
> 	newinfo =3D (struct ebt_table_info *)
> 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
> 	if (!newinfo)
>@@ -1022,7 +1022,7 @@ static int do_replace(void __user *user,
>=20
> 	vfree(table->entries);
> 	if (table->chainstack) {
>-		for (i =3D 0; i < num_possible_cpus(); i++)
>+		for_each_cpu_mask(i, cpu_possible_map)
> 			vfree(table->chainstack[i]);
> 		vfree(table->chainstack);
> 	}
>@@ -1040,7 +1040,7 @@ free_counterstmp:
> 	vfree(counterstmp);
> 	/* can be initialized in translate_table() */
> 	if (newinfo->chainstack) {
>-		for (i =3D 0; i < num_possible_cpus(); i++)
>+		for_each_cpu_mask(i, cpu_possible_map)
> 			vfree(newinfo->chainstack[i]);
> 		vfree(newinfo->chainstack);
> 	}
>@@ -1132,7 +1132,8 @@ int ebt_register_table(struct ebt_table=20
> 		return -EINVAL;
> 	}
>=20
>-	countersize =3D COUNTER_OFFSET(table->table->nentries) * num_possible_=
cpus();
>+	countersize =3D COUNTER_OFFSET(table->table->nentries) *
>+					(highest_possible_processor_id()+1);
> 	newinfo =3D (struct ebt_table_info *)
> 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
> 	ret =3D -ENOMEM;
>@@ -1186,7 +1187,7 @@ free_unlock:
> 	up(&ebt_mutex);
> free_chainstack:
> 	if (newinfo->chainstack) {
>-		for (i =3D 0; i < num_possible_cpus(); i++)
>+		for_each_cpu_mask(i, cpu_possible_map)
> 			vfree(newinfo->chainstack[i]);
> 		vfree(newinfo->chainstack);
> 	}
>@@ -1209,7 +1210,7 @@ void ebt_unregister_table(struct ebt_tab
> 	up(&ebt_mutex);
> 	vfree(table->private->entries);
> 	if (table->private->chainstack) {
>-		for (i =3D 0; i < num_possible_cpus(); i++)
>+		for_each_cpu_mask(i, cpu_possible_map)
> 			vfree(table->private->chainstack[i]);
> 		vfree(table->private->chainstack);
> 	}
>diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_ta=
bles.c
>--- a/net/ipv4/netfilter/arp_tables.c
>+++ b/net/ipv4/netfilter/arp_tables.c
>@@ -716,8 +716,8 @@ static int translate_table(const char *n
> 	}
>=20
> 	/* And one copy for every other CPU */
>-	for (i =3D 1; i < num_possible_cpus(); i++) {
>-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
>+	for_each_cpu_mask(i, cpu_possible_map) {
>+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*(1+i),
> 		       newinfo->entries,
> 		       SMP_ALIGN(newinfo->size));
> 	}
>@@ -767,7 +767,7 @@ static void get_counters(const struct ar
> 	unsigned int cpu;
> 	unsigned int i;
>=20
>-	for (cpu =3D 0; cpu < num_possible_cpus(); cpu++) {
>+	for_each_cpu_mask(cpu, cpu_possible_map) {
> 		i =3D 0;
> 		ARPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
> 				   t->size,
>@@ -885,7 +885,8 @@ static int do_replace(void __user *user,
> 		return -ENOMEM;
>=20
> 	newinfo =3D vmalloc(sizeof(struct arpt_table_info)
>-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
>+			  + SMP_ALIGN(tmp.size) *
>+			  		(highest_possible_processor_id()+1));
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
>@@ -1158,7 +1159,8 @@ int arpt_register_table(struct arpt_tabl
> 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
>=20
> 	newinfo =3D vmalloc(sizeof(struct arpt_table_info)
>-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
>+			  + SMP_ALIGN(repl->size) *
>+			  		(highest_possible_processor_id()+1));
> 	if (!newinfo) {
> 		ret =3D -ENOMEM;
> 		return ret;
>diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tabl=
es.c
>--- a/net/ipv4/netfilter/ip_tables.c
>+++ b/net/ipv4/netfilter/ip_tables.c
>@@ -27,6 +27,7 @@
> #include <asm/semaphore.h>
> #include <linux/proc_fs.h>
> #include <linux/err.h>
>+#include <linux/cpumask.h>
>=20
> #include <linux/netfilter_ipv4/ip_tables.h>
>=20
>@@ -921,8 +922,8 @@ translate_table(const char *name,
> 	}
>=20
> 	/* And one copy for every other CPU */
>-	for (i =3D 1; i < num_possible_cpus(); i++) {
>-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
>+	for_each_cpu_mask(i, cpu_possible_map) {
>+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*(1+i),
> 		       newinfo->entries,
> 		       SMP_ALIGN(newinfo->size));
> 	}
>@@ -943,7 +944,7 @@ replace_table(struct ipt_table *table,
> 		struct ipt_entry *table_base;
> 		unsigned int i;
>=20
>-		for (i =3D 0; i < num_possible_cpus(); i++) {
>+		for_each_cpu_mask(i, cpu_possible_map) {
> 			table_base =3D
> 				(void *)newinfo->entries
> 				+ TABLE_OFFSET(newinfo, i);
>@@ -990,7 +991,7 @@ get_counters(const struct ipt_table_info
> 	unsigned int cpu;
> 	unsigned int i;
>=20
>-	for (cpu =3D 0; cpu < num_possible_cpus(); cpu++) {
>+	for_each_cpu_mask(cpu, cpu_possible_map) {
> 		i =3D 0;
> 		IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
> 				  t->size,
>@@ -1128,7 +1129,8 @@ do_replace(void __user *user, unsigned i
> 		return -ENOMEM;
>=20
> 	newinfo =3D vmalloc(sizeof(struct ipt_table_info)
>-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
>+			  + SMP_ALIGN(tmp.size) *=20
>+			  	(highest_possible_processor_id()+1));
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
>@@ -1458,7 +1460,8 @@ int ipt_register_table(struct ipt_table=20
> 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
>=20
> 	newinfo =3D vmalloc(sizeof(struct ipt_table_info)
>-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
>+			  + SMP_ALIGN(repl->size) *=20
>+			  		(highest_possible_processor_id()+1));
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
>diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_ta=
bles.c
>--- a/net/ipv6/netfilter/ip6_tables.c
>+++ b/net/ipv6/netfilter/ip6_tables.c
>@@ -28,6 +28,7 @@
> #include <asm/uaccess.h>
> #include <asm/semaphore.h>
> #include <linux/proc_fs.h>
>+#include <linux/cpumask.h>
>=20
> #include <linux/netfilter_ipv6/ip6_tables.h>
>=20
>@@ -950,8 +951,8 @@ translate_table(const char *name,
> 	}
>=20
> 	/* And one copy for every other CPU */
>-	for (i =3D 1; i < num_possible_cpus(); i++) {
>-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
>+	for_each_cpu_mask(i, cpu_possible_map) {
>+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*(1+i),
> 		       newinfo->entries,
> 		       SMP_ALIGN(newinfo->size));
> 	}
>@@ -973,6 +974,7 @@ replace_table(struct ip6t_table *table,
> 		unsigned int i;
>=20
> 		for (i =3D 0; i < num_possible_cpus(); i++) {
>+		for_each_cpu_mask(i, cpu_possible_mask) {
> 			table_base =3D
> 				(void *)newinfo->entries
> 				+ TABLE_OFFSET(newinfo, i);
>@@ -1019,7 +1021,7 @@ get_counters(const struct ip6t_table_inf
> 	unsigned int cpu;
> 	unsigned int i;
>=20
>-	for (cpu =3D 0; cpu < num_possible_cpus(); cpu++) {
>+	for_each_cpu_mask(cpu, cpu_possible_map) {
> 		i =3D 0;
> 		IP6T_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
> 				  t->size,
>@@ -1153,7 +1155,8 @@ do_replace(void __user *user, unsigned i
> 		return -ENOMEM;
>=20
> 	newinfo =3D vmalloc(sizeof(struct ip6t_table_info)
>-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
>+			  + SMP_ALIGN(tmp.size) *
>+			  		(highest_possible_processor_id()+1));
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
>@@ -1467,7 +1470,8 @@ int ip6t_register_table(struct ip6t_tabl
> 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
>=20
> 	newinfo =3D vmalloc(sizeof(struct ip6t_table_info)
>-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
>+			  + SMP_ALIGN(repl->size) *
>+			  		(highest_possible_processor_id()+1));
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
> =20
>
On sparc64, cpu_possible_map does not exist.
You have either
    cpu_online_map
or
    phys_cpu_present_map.

    Seb
