From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: libiptc memory leak - PATCH
Date: 02 May 2003 14:47:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051879671.3823.17.camel@tux.rsn.bth.se>
References: <3EA46FDE.6040806@i.cz>
	 <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz>
	 <20030430154721.GD685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0lACcLPnwcUuVOEou6uU"
Cc: =?ISO-8859-1?Q?Tom=E1=3F?= Lejdar <tomas.lejdar@i.cz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030430154721.GD685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-0lACcLPnwcUuVOEou6uU
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Wed, 2003-04-30 at 17:47, Harald Welte wrote:
> On Mon, Apr 28, 2003 at 09:14:25AM +0200, Tom=E1? Lejdar wrote:
> > Hi,
> > I thing there is no problem, the memory is freed only when the
> > function next_chain returns NULL and run through the chains is on the e=
nd.
> > In the next call of first_chain() is memory alocated again in=20
> > populate_cache().
>=20
> no, it's fine.  It was a misunderstanding. I'll apply your patch now.
> Sorry for the fuzz.

This patch breaks {ip,ip6}tables-{save,restore} and it runs free() on
the wrong memoryaddress (I think free() does the right thing anyway but
the patch still breaks stuff).

-{save,restore} segfaulted with the patch.

I've attached a patch that reverts this patch and adds
iptc_exit(iptc_handle_t h) that takes care of the freeing.
It also contains some small cleanups.

The patch also fixes iptables, ip6tables and their -{save,restore}
cousins to not leak memory.

I've tested iptables and iptables-{save,restore} and they appear to work
just fine.

Please apply or at least revert the previous patch.

--=20
/Martin

--=-0lACcLPnwcUuVOEou6uU
Content-Disposition: attachment; filename=libiptc-diff
Content-Type: text/x-patch; name=libiptc-diff; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

diff -x '*.d' -urN userspace.orig/include/libiptc/libiptc.h userspace/inclu=
de/libiptc/libiptc.h
--- userspace.orig/include/libiptc/libiptc.h	2001-04-19 18:35:39.000000000 =
+0200
+++ userspace/include/libiptc/libiptc.h	2003-05-02 13:48:01.000000000 +0200
@@ -34,6 +34,9 @@
 /* Take a snapshot of the rules.  Returns NULL on error. */
 iptc_handle_t iptc_init(const char *tablename);
=20
+/* Cleanup after iptc_init(). */
+void iptc_exit(iptc_handle_t h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *iptc_first_chain(iptc_handle_t *handle);
 const char *iptc_next_chain(iptc_handle_t *handle);
diff -x '*.d' -urN userspace.orig/ip6tables-restore.c userspace/ip6tables-r=
estore.c
--- userspace.orig/ip6tables-restore.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/ip6tables-restore.c	2003-05-02 13:58:33.000000000 +0200
@@ -102,7 +102,7 @@
=20
 int main(int argc, char *argv[])
 {
-	ip6tc_handle_t handle;
+	ip6tc_handle_t handle =3D NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
@@ -183,6 +183,9 @@
 			}
 			strncpy(curtable, table, IP6T_TABLE_MAXNAMELEN);
=20
+			if (handle)
+				ip6tc_exit(handle);
+
 			handle =3D create_handle(table, modprobe);
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
diff -x '*.d' -urN userspace.orig/ip6tables-save.c userspace/ip6tables-save=
.c
--- userspace.orig/ip6tables-save.c	2002-08-14 13:40:41.000000000 +0200
+++ userspace/ip6tables-save.c	2003-05-02 13:50:01.000000000 +0200
@@ -305,6 +305,8 @@
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
=20
+	ip6tc_exit(h);
+
 	return 1;
 }
=20
diff -x '*.d' -urN userspace.orig/ip6tables.c userspace/ip6tables.c
--- userspace.orig/ip6tables.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/ip6tables.c	2003-05-02 14:34:23.000000000 +0200
@@ -1670,6 +1670,7 @@
 	const char *modprobe =3D NULL;
 	int proto_used =3D 0;
 	char icmp6p[] =3D "icmpv6";
+	int no_handle =3D 0;
=20
 	memset(&fw, 0, sizeof(fw));
=20
@@ -2147,8 +2148,10 @@
 			   chain, IP6T_FUNCTION_MAXNAMELEN);
=20
 	/* only allocate handle if we weren't called with a handle */
-	if (!*handle)
+	if (!*handle) {
 		*handle =3D ip6tc_init(*table);
+		no_handle =3D 1;
+	}
=20
 	if (!*handle) {
 		/* try to insmod the module if iptc_init failed */
@@ -2293,5 +2296,10 @@
 	if (verbose > 1)
 		dump_entries6(*handle);
=20
+	if (no_handle) {
+		ip6tc_exit(*handle);
+		*handle =3D NULL;
+	}
+
 	return ret;
 }
diff -x '*.d' -urN userspace.orig/iptables-restore.c userspace/iptables-res=
tore.c
--- userspace.orig/iptables-restore.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/iptables-restore.c	2003-05-02 14:13:15.000000000 +0200
@@ -99,7 +99,7 @@
=20
 int main(int argc, char *argv[])
 {
-	iptc_handle_t handle;
+	iptc_handle_t handle =3D NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
@@ -180,6 +180,9 @@
 			}
 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
=20
+			if (handle)
+				iptc_exit(handle);
+
 			handle =3D create_handle(table, modprobe);
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
diff -x '*.d' -urN userspace.orig/iptables-save.c userspace/iptables-save.c
--- userspace.orig/iptables-save.c	2002-08-07 11:07:41.000000000 +0200
+++ userspace/iptables-save.c	2003-05-02 13:49:37.000000000 +0200
@@ -304,6 +304,8 @@
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
=20
+	iptc_exit(h);
+
 	return 1;
 }
=20
diff -x '*.d' -urN userspace.orig/iptables.c userspace/iptables.c
--- userspace.orig/iptables.c	2003-03-31 14:33:55.000000000 +0200
+++ userspace/iptables.c	2003-05-02 14:20:59.000000000 +0200
@@ -1668,6 +1668,7 @@
 	char *protocol =3D NULL;
 	const char *modprobe =3D NULL;
 	int proto_used =3D 0;
+	int no_handle =3D 0;
=20
 	memset(&fw, 0, sizeof(fw));
=20
@@ -2148,8 +2149,10 @@
 			   chain, IPT_FUNCTION_MAXNAMELEN);
=20
 	/* only allocate handle if we weren't called with a handle */
-	if (!*handle)
+	if (!*handle) {
 		*handle =3D iptc_init(*table);
+		no_handle =3D 1;
+	}
=20
 	if (!*handle) {
 		/* try to insmod the module if iptc_init failed */
@@ -2294,5 +2297,10 @@
 	if (verbose > 1)
 		dump_entries(*handle);
=20
+	if (no_handle) {
+		iptc_exit(*handle);
+		*handle =3D NULL;
+	}
+
 	return ret;
 }
diff -x '*.d' -urN userspace.orig/libiptc/libip4tc.c userspace/libiptc/libi=
p4tc.c
--- userspace.orig/libiptc/libip4tc.c	2002-06-12 21:22:29.000000000 +0200
+++ userspace/libiptc/libip4tc.c	2003-05-02 13:48:30.000000000 +0200
@@ -91,6 +91,7 @@
 #define TC_SET_POLICY		iptc_set_policy
 #define TC_GET_RAW_SOCKET	iptc_get_raw_socket
 #define TC_INIT			iptc_init
+#define TC_EXIT			iptc_exit
 #define TC_COMMIT		iptc_commit
 #define TC_STRERROR		iptc_strerror
=20
diff -x '*.d' -urN userspace.orig/libiptc/libip6tc.c userspace/libiptc/libi=
p6tc.c
--- userspace.orig/libiptc/libip6tc.c	2002-02-14 00:13:23.000000000 +0100
+++ userspace/libiptc/libip6tc.c	2003-05-02 13:48:48.000000000 +0200
@@ -86,6 +86,7 @@
 #define TC_SET_POLICY		ip6tc_set_policy
 #define TC_GET_RAW_SOCKET	ip6tc_get_raw_socket
 #define TC_INIT			ip6tc_init
+#define TC_EXIT			ip6tc_exit
 #define TC_COMMIT		ip6tc_commit
 #define TC_STRERROR		ip6tc_strerror
=20
diff -x '*.d' -urN userspace.orig/libiptc/libiptc.c userspace/libiptc/libip=
tc.c
--- userspace.orig/libiptc/libiptc.c	2003-04-30 18:56:19.000000000 +0200
+++ userspace/libiptc/libiptc.c	2003-05-02 14:22:40.000000000 +0200
@@ -237,22 +237,26 @@
 	if (sockfd !=3D -1)
 		close(sockfd);
=20
+	if (strlen(tablename) >=3D TABLE_MAXNAMELEN) {
+		errno =3D EINVAL;
+		return NULL;
+	}
+=09
 	sockfd =3D socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
 	if (sockfd < 0)
 		return NULL;
=20
 	s =3D sizeof(info);
-	if (strlen(tablename) >=3D TABLE_MAXNAMELEN) {
-		errno =3D EINVAL;
-		return NULL;
-	}
+
 	strcpy(info.name, tablename);
 	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info, &s) < 0)
 		return NULL;
=20
 	if ((h =3D alloc_handle(info.name, info.size, info.num_entries))
-	    =3D=3D NULL)
+	    =3D=3D NULL) {
+		close(sockfd);
 		return NULL;
+	}
=20
 /* Too hard --RR */
 #if 0
@@ -284,6 +288,7 @@
=20
 	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_ENTRIES, &h->entries,
 		       &tmp) < 0) {
+		close(sockfd);
 		free(h);
 		return NULL;
 	}
@@ -292,6 +297,13 @@
 	return h;
 }
=20
+void
+TC_EXIT(TC_HANDLE_T h)
+{
+	close(sockfd);
+	free(h);
+}
+
 static inline int
 print_match(const STRUCT_ENTRY_MATCH *m)
 {
@@ -504,10 +516,8 @@
 	(*handle)->cache_chain_iteration++;
=20
 	if ((*handle)->cache_chain_iteration - (*handle)->cache_chain_heads
-	    =3D=3D (*handle)->cache_num_chains) {
-		free((*handle)->cache_chain_heads);
+	    =3D=3D (*handle)->cache_num_chains)
 		return NULL;
-	}
=20
 	return (*handle)->cache_chain_iteration->name;
 }
@@ -1584,11 +1594,13 @@
 	STRUCT_REPLACE *repl;
 	STRUCT_COUNTERS_INFO *newcounters;
 	unsigned int i;
-	size_t counterlen
-		=3D sizeof(STRUCT_COUNTERS_INFO)
-		+ sizeof(STRUCT_COUNTERS) * (*handle)->new_number;
+	size_t counterlen;
=20
 	CHECK(*handle);
+
+	counterlen =3D sizeof(STRUCT_COUNTERS_INFO)
+			+ sizeof(STRUCT_COUNTERS) * (*handle)->new_number;
+
 #if 0
 	TC_DUMP_ENTRIES(*handle);
 #endif

--=-0lACcLPnwcUuVOEou6uU--
