From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: libiptc memory leak - PATCH
Date: 03 May 2003 22:52:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051995143.3825.60.camel@tux.rsn.bth.se>
References: <3EA46FDE.6040806@i.cz>
	 <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz>
	 <20030430154721.GD685@sunbeam.de.gnumonks.org>
	 <1051879671.3823.17.camel@tux.rsn.bth.se>
	 <1051883276.3811.24.camel@tux.rsn.bth.se>
	 <1051884858.3823.32.camel@tux.rsn.bth.se>
	 <20030502152147.GK26924@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xnywpfvn9cZoBaGrRflN"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030502152147.GK26924@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-xnywpfvn9cZoBaGrRflN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-05-02 at 17:21, Harald Welte wrote:

> > This should fix it correctly (I hope), iptables, iptables-{save,restore}
> > works fine.
> 
> we'll see.  I think iptables-1.2.9 is in a quite distant future, so
> I hope we discover any potentially introduced bugs until then.

I broke it a little...

I've attached a fix...
it fixes iptables.c and ip6tables.c

-- 
/Martin

--=-xnywpfvn9cZoBaGrRflN
Content-Disposition: attachment; filename=iptables.c-fix
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=iptables.c-fix; charset=ISO-8859-15

--- userspace/iptables.c.orig	2003-05-02 17:31:44.000000000 +0200
+++ userspace/iptables.c	2003-05-03 22:43:39.000000000 +0200
@@ -1668,7 +1668,6 @@
 	char *protocol =3D NULL;
 	const char *modprobe =3D NULL;
 	int proto_used =3D 0;
-	int no_handle =3D 0;
=20
 	memset(&fw, 0, sizeof(fw));
=20
@@ -2149,10 +2148,8 @@
 			   chain, IPT_FUNCTION_MAXNAMELEN);
=20
 	/* only allocate handle if we weren't called with a handle */
-	if (!*handle) {
+	if (!*handle)
 		*handle =3D iptc_init(*table);
-		no_handle =3D 1;
-	}
=20
 	if (!*handle) {
 		/* try to insmod the module if iptc_init failed */
@@ -2297,8 +2294,5 @@
 	if (verbose > 1)
 		dump_entries(*handle);
=20
-	if (no_handle)
-		iptc_free(handle);
-
 	return ret;
 }
--- userspace/ip6tables.c.orig	2003-05-02 17:31:44.000000000 +0200
+++ userspace/ip6tables.c	2003-05-03 22:50:51.000000000 +0200
@@ -1670,7 +1670,6 @@
 	const char *modprobe =3D NULL;
 	int proto_used =3D 0;
 	char icmp6p[] =3D "icmpv6";
-	int no_handle =3D 0;
=20
 	memset(&fw, 0, sizeof(fw));
=20
@@ -2148,10 +2147,8 @@
 			   chain, IP6T_FUNCTION_MAXNAMELEN);
=20
 	/* only allocate handle if we weren't called with a handle */
-	if (!*handle) {
+	if (!*handle)
 		*handle =3D ip6tc_init(*table);
-		no_handle =3D 1;
-	}
=20
 	if (!*handle) {
 		/* try to insmod the module if iptc_init failed */
@@ -2296,8 +2293,5 @@
 	if (verbose > 1)
 		dump_entries6(*handle);
=20
-	if (no_handle)
-		ip6tc_free(handle);
-
 	return ret;
 }

--=-xnywpfvn9cZoBaGrRflN--
