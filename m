From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: num_possible_cpus() usage in iptables
Date: Mon, 10 Oct 2005 08:23:27 +0200
Message-ID: <434A08DF.5090402@cosmosbay.com>
References: <20051009.204734.30319051.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051009.204734.30319051.davem@davemloft.net>
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

David S. Miller a =E9crit :
> Guys, you can't use this interface like that.
>=20
> It's a _COUNT_ of the number of possible processors, not the number of
> the higest PHYSICAL cpu index.
>=20
> So you can have cpu's numbered "0" and "2", but num_possible_cpus()
> will return 2.  This is not just theoretical, Ultra60 sparc64 systems
> have this exact physical cpu numbering.   And as a result, when the
> changes went into iptables to use num_possible_cpus() instead of NR_CPU=
S
> it broke iptables.  It OOPS's when you load the module, in fact.
>=20
> So, on such a system, this loop:
>=20
> 	/* And one copy for every other CPU */
> 	for (i =3D 1; i < num_possible_cpus(); i++) {
> 		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
> 		       newinfo->entries,
> 		       SMP_ALIGN(newinfo->size));
> 	}
>=20
> would initialize the wrong entries.
>=20
> We need to fix this.
>=20
>=20
Hi David

My previous patch ([PATCH 3/3] netfilter : 3 patches to boost ip_tables=20
performance) addressed this problem.


http://marc.theaimsgroup.com/?l=3Dlinux-netdev&m=3D112733887410796&w=3D2

Relevant parts :

-	for (i =3D 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
-		       newinfo->entries,
-		       SMP_ALIGN(newinfo->size));
+	for_each_cpu(i) {
+		if (newinfo->entries[i] && newinfo->entries[i] !=3D entry0)
+			memcpy(newinfo->entries[i], entry0, newinfo->size);


-		for (i =3D 0; i < num_possible_cpus(); i++) {
-			table_base =3D
-				(void *)newinfo->entries
-				+ TABLE_OFFSET(newinfo, i);
-
-			table_base->comefrom =3D 0xdead57ac;
+		for_each_cpu(cpu) {
+			struct ipt_entry *table_base =3D newinfo->entries[cpu];
+			if (table_base)
+				table_base->comefrom =3D 0xdead57ac;

But the whole thing was suspended because nobody wants to put a vmalloc_n=
ode()=20
inside kernel.

Eric
