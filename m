From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 18:41:41 +0200
Message-ID: <20051010164141.GG5627@rama>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is my proposed patch for the problem you've described.  Please test
and submit.  If it works, I'll also prepare a patch for {arp,ip6}_tables.


[NETFILTER] ip_tables: fix per cpu handling=20

As David Miller points out, the "smp_processor_id()'s" are not always
contiguous.  Esp. some boxes like Sun Ultra60 have CPU 0 and 2 installed in
one system, but no "1".   Therefore the current logic of how iptables
manages the per cpu copies of the ruleset is broken.  This patch is
supposed to fix it.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit e759eaa9e9e92330c5fcfd760d767d4f39375a03
tree 63b96f7df57f51dc7e284969c3a08b9264cc2c5f
parent 1ab8dccdbf16c09f8da124fc4c82024de24dfae2
author Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24 +0200
committer Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24 +0=
200

 net/ipv4/netfilter/ip_tables.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -27,6 +27,7 @@
 #include <asm/semaphore.h>
 #include <linux/proc_fs.h>
 #include <linux/err.h>
+#include <linux/cpumask.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
@@ -124,6 +125,19 @@ static LIST_HEAD(ipt_tables);
 #define up(x) do { printk("UP:%u:" #x "\n", __LINE__); up(x); } while(0)
 #endif
=20
+/* Find the highest possible smp_processor_id() */
+static unsigned int highest_processor_id(void)
+{
+	unsigned int cpu, highest =3D 0;
+
+	for_each_cpu_mask(cpu, cpu_possible_map) {
+		if (cpu > highest)
+			highest =3D cpu;
+	}
+
+	return highest;
+}
+
 /* Returns whether matches rule or not. */
 static inline int
 ip_packet_match(const struct iphdr *ip,
@@ -921,8 +935,8 @@ translate_table(const char *name,
 	}
=20
 	/* And one copy for every other CPU */
-	for (i =3D 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
+	for_each_cpu_mask(i, cpu_possible_map) {
+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*(1+i),
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
 	}
@@ -943,7 +957,7 @@ replace_table(struct ipt_table *table,
 		struct ipt_entry *table_base;
 		unsigned int i;
=20
-		for (i =3D 0; i < num_possible_cpus(); i++) {
+		for_each_cpu_mask(i, cpu_possible_map) {
 			table_base =3D
 				(void *)newinfo->entries
 				+ TABLE_OFFSET(newinfo, i);
@@ -990,7 +1004,7 @@ get_counters(const struct ipt_table_info
 	unsigned int cpu;
 	unsigned int i;
=20
-	for (cpu =3D 0; cpu < num_possible_cpus(); cpu++) {
+	for_each_cpu_mask(cpu, cpu_possible_map) {
 		i =3D 0;
 		IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				  t->size,
@@ -1128,7 +1142,7 @@ do_replace(void __user *user, unsigned i
 		return -ENOMEM;
=20
 	newinfo =3D vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
+			  + SMP_ALIGN(tmp.size) * (highest_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
=20
@@ -1458,7 +1472,7 @@ int ipt_register_table(struct ipt_table=20
 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
 	newinfo =3D vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
+			  + SMP_ALIGN(repl->size) * (highest_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSpnFXaXGVTD0i/8RAuIYAJ9tzZWD9StR7Vvd7qiQEI8AfeAi1QCgtDR5
/uLpHNpGWiLC7fCsaJ8KjG0=
=Au2s
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
