From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: libiptc memory leak - PATCH
Date: 02 May 2003 16:14:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051884858.3823.32.camel@tux.rsn.bth.se>
References: <3EA46FDE.6040806@i.cz>
	 <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz>
	 <20030430154721.GD685@sunbeam.de.gnumonks.org>
	 <1051879671.3823.17.camel@tux.rsn.bth.se>
	 <1051883276.3811.24.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6zPJOZkNNC4NBU+3k35o"
Cc: =?ISO-8859-1?Q?Tom=E1=3F?= Lejdar <tomas.lejdar@i.cz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <1051883276.3811.24.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-6zPJOZkNNC4NBU+3k35o
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-05-02 at 15:47, Martin Josefsson wrote:
> On Fri, 2003-05-02 at 14:47, Martin Josefsson wrote:
> 
> > This patch breaks {ip,ip6}tables-{save,restore} and it runs free() on
> > the wrong memoryaddress (I think free() does the right thing anyway but
> > the patch still breaks stuff).
> 
> Ok, I was wrong, it did free on a correct memoryaddress, I'll fix up my
> patch and resend, sorry about that.

Here's an updated patch that fixes the memory-leak in the previous one.

I've renamed {ip,ip6}tc_exit(iptc_handle_t h) into
{ip,ip6}tc_free(iptc_handle_t *h)

This should fix it correctly (I hope), iptables, iptables-{save,restore}
works fine.

-- 
/Martin

--=-6zPJOZkNNC4NBU+3k35o
Content-Disposition: attachment; filename=libiptc-diff2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=libiptc-diff2; charset=ISO-8859-15

diff -x '*.d' -urN userspace.orig/include/libiptc/libiptc.h userspace/inclu=
de/libiptc/libiptc.h
--- userspace.orig/include/libiptc/libiptc.h	2001-04-19 18:35:39.000000000 =
+0200
+++ userspace/include/libiptc/libiptc.h	2003-05-02 16:00:06.000000000 +0200
@@ -34,6 +34,9 @@
 /* Take a snapshot of the rules.  Returns NULL on error. */
 iptc_handle_t iptc_init(const char *tablename);
=20
+/* Cleanup after iptc_init(). */
+void iptc_free(iptc_handle_t *h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *iptc_first_chain(iptc_handle_t *handle);
 const char *iptc_next_chain(iptc_handle_t *handle);
diff -x '*.d' -urN userspace.orig/ip6tables-restore.c userspace/ip6tables-r=
estore.c
--- userspace.orig/ip6tables-restore.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/ip6tables-restore.c	2003-05-02 16:01:08.000000000 +0200
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
+				ip6tc_free(&handle);
+
 			handle =3D create_handle(table, modprobe);
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
diff -x '*.d' -urN userspace.orig/ip6tables-save.c userspace/ip6tables-save=
.c
--- userspace.orig/ip6tables-save.c	2002-08-14 13:40:41.000000000 +0200
+++ userspace/ip6tables-save.c	2003-05-02 16:01:17.000000000 +0200
@@ -305,6 +305,8 @@
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
=20
+	ip6tc_free(&h);
+
 	return 1;
 }
=20
diff -x '*.d' -urN userspace.orig/ip6tables.c userspace/ip6tables.c
--- userspace.orig/ip6tables.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/ip6tables.c	2003-05-02 16:00:58.000000000 +0200
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
@@ -2293,5 +2296,8 @@
 	if (verbose > 1)
 		dump_entries6(*handle);
=20
+	if (no_handle)
+		ip6tc_free(handle);
+
 	return ret;
 }
diff -x '*.d' -urN userspace.orig/iptables-restore.c userspace/iptables-res=
tore.c
--- userspace.orig/iptables-restore.c	2003-03-06 13:01:32.000000000 +0100
+++ userspace/iptables-restore.c	2003-05-02 16:00:34.000000000 +0200
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
+				iptc_free(&handle);
+
 			handle =3D create_handle(table, modprobe);
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
diff -x '*.d' -urN userspace.orig/iptables-save.c userspace/iptables-save.c
--- userspace.orig/iptables-save.c	2002-08-07 11:07:41.000000000 +0200
+++ userspace/iptables-save.c	2003-05-02 16:00:23.000000000 +0200
@@ -304,6 +304,8 @@
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
=20
+	iptc_free(&h);
+
 	return 1;
 }
=20
diff -x '*.d' -urN userspace.orig/iptables.c userspace/iptables.c
--- userspace.orig/iptables.c	2003-03-31 14:33:55.000000000 +0200
+++ userspace/iptables.c	2003-05-02 16:00:46.000000000 +0200
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
@@ -2294,5 +2297,8 @@
 	if (verbose > 1)
 		dump_entries(*handle);
=20
+	if (no_handle)
+		iptc_free(handle);
+
 	return ret;
 }
diff -x '*.d' -urN userspace.orig/libiptc/libip4tc.c userspace/libiptc/libi=
p4tc.c
--- userspace.orig/libiptc/libip4tc.c	2002-06-12 21:22:29.000000000 +0200
+++ userspace/libiptc/libip4tc.c	2003-05-02 15:59:39.000000000 +0200
@@ -91,6 +91,7 @@
 #define TC_SET_POLICY		iptc_set_policy
 #define TC_GET_RAW_SOCKET	iptc_get_raw_socket
 #define TC_INIT			iptc_init
+#define TC_FREE			iptc_free
 #define TC_COMMIT		iptc_commit
 #define TC_STRERROR		iptc_strerror
=20
diff -x '*.d' -urN userspace.orig/libiptc/libip6tc.c userspace/libiptc/libi=
p6tc.c
--- userspace.orig/libiptc/libip6tc.c	2002-02-14 00:13:23.000000000 +0100
+++ userspace/libiptc/libip6tc.c	2003-05-02 15:59:49.000000000 +0200
@@ -86,6 +86,7 @@
 #define TC_SET_POLICY		ip6tc_set_policy
 #define TC_GET_RAW_SOCKET	ip6tc_get_raw_socket
 #define TC_INIT			ip6tc_init
+#define TC_FREE			ip6tc_free
 #define TC_COMMIT		ip6tc_commit
 #define TC_STRERROR		ip6tc_strerror
=20
diff -x '*.d' -urN userspace.orig/libiptc/libiptc.c userspace/libiptc/libip=
tc.c
--- userspace.orig/libiptc/libiptc.c	2003-04-30 18:56:19.000000000 +0200
+++ userspace/libiptc/libiptc.c	2003-05-02 16:03:47.000000000 +0200
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
@@ -292,6 +297,16 @@
 	return h;
 }
=20
+void
+TC_FREE(TC_HANDLE_T *h)
+{
+	close(sockfd);
+	if ((*h)->cache_chain_heads)
+		free((*h)->cache_chain_heads);
+	free(*h);
+	*h =3D NULL;
+}
+
 static inline int
 print_match(const STRUCT_ENTRY_MATCH *m)
 {
@@ -504,10 +519,8 @@
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
@@ -1584,11 +1597,13 @@
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
@@ -1715,10 +1730,7 @@
 	free(newcounters);
=20
  finished:
-	if ((*handle)->cache_chain_heads)
-		free((*handle)->cache_chain_heads);
-	free(*handle);
-	*handle =3D NULL;
+	TC_FREE(handle);
 	return 1;
 }
=20

--=-6zPJOZkNNC4NBU+3k35o--
