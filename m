From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH] iptables-batch
Date: Mon, 6 Sep 2004 18:24:53 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040906162453.GA27149@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Shell scripts that need to generate a lot of filter rules spend
quite some time forking iptables. The following patch implements
"iptables-batch" and "ip6tables-batch" commands which read the rules
to setup from a file. That's basically the same as iptables-restore
since the hard work is done by do_command() anyways but the file
format is exactly the same as when calling iptables from the shell,
without special additional key words. Therefore all you have to do
to make an existing shell script use iptables-batch is replacing
"iptables" with "echo iptables", redirect the output to a file and
run iptables-batch on it (for more complicated scripts use a shell
function that adds quotes around arguments to protect spaces).

cu
Ludwig


Index: iptables-1.2.9/iptables-batch.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-1.2.9/iptables-batch.c
@@ -0,0 +1,280 @@
+/*
+ * Author: Ludwig Nussel <ludwig.nussel@suse.de>
+ *
+ * Based on the ipchains code by Paul Russell and Michael Neuling
+ *
+ * (C) 2000-2002 by the netfilter coreteam <coreteam@netfilter.org>:
+ * 		    Paul 'Rusty' Russell <rusty@rustcorp.com.au>
+ * 		    Marc Boucher <marc+nf@mbsi.ca>
+ * 		    James Morris <jmorris@intercode.com.au>
+ * 		    Harald Welte <laforge@gnumonks.org>
+ * 		    Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ *	iptables -- IP firewall administration for kernels with
+ *	firewall table (aimed for the 2.3 kernels)
+ *
+ *	See the accompanying manual page iptables(8) for information
+ *	about proper usage of this program.
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <ctype.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+
+#ifdef IP6T_LIB_DIR
+#include <ip6tables.h>
+#else
+#include <iptables.h>
+#endif
+
+static char* errstr =3D NULL;
+
+static char*
+skipspace(char* ptr)
+{
+	while(*ptr && isspace(*ptr))
+		++ptr;
+	return ptr;
+}
+
+static char*
+getliteral(char** ptr)
+{
+	char* start =3D *ptr;
+	char* p =3D start;
+
+	while(*p && !isspace(*p))
+		++p;
+
+	if(*p)
+	{
+		*p =3D '\0';
+		++p;
+	}
+
+	*ptr =3D p;
+	return start;
+}
+
+static char*
+getstring(char** ptr)
+{
+	char* start =3D *ptr+1; // skip leading "
+	char* p =3D start;
+	char* o =3D start;
+	int backslash =3D 0;
+	int done =3D 0;
+
+	while(*p && !done)
+	{
+		if(backslash)
+		{
+			backslash =3D 0;
+			// no escapes supported, just eat the backslash
+			*o++ =3D *p++;
+		}
+		else if(*p =3D=3D '\\')
+		{
+			backslash =3D 1;
+			p++;
+		}
+		else if(*p =3D=3D '"')
+		{
+			done =3D 1;
+		}
+		else
+		{
+			*o++ =3D *p++;
+		}
+	}
+
+	if(done)
+	{
+		*o =3D '\0';
+		*p =3D '\0';
+		++p;
+		*ptr =3D p;
+	}
+	else
+	{
+		errstr =3D "missing \" at end of string";
+		start =3D NULL;
+	}
+	return start;
+}
+
+static char*
+getword(char** ptr)
+{
+	*ptr =3D skipspace(*ptr);
+	if(**ptr =3D=3D '"')
+		return getstring(ptr);
+	return getliteral(ptr);
+}
+
+// destructive
+static int
+tokenize(int* argc, char* argv[], size_t nargvsize, char* line)
+{
+	char* ptr =3D skipspace(line);
+	int ret =3D 0;
+	char* word;
+
+	while(ptr && *ptr)
+	{
+		if(*ptr =3D=3D '#')
+			break;
+		if(*argc >=3D nargvsize)
+		{
+			errstr =3D "too many arguments";
+			ret =3D -1;
+			break;
+		}
+		word =3D getword(&ptr);
+		if(!word)
+		{
+			ret =3D -1;
+			break;
+		}
+		argv[(*argc)++] =3D word;
+		++ret;
+	}
+	return ret;
+}
+
+static void
+dumpargv(int argc, char* argv[])
+{
+	int i;
+	for(i=3D0; i < argc; ++i)
+	{
+		printf("%s\"%s\"",i?" ":"", argv[i]);
+	}
+	puts("");
+}
+
+static int
+do_iptables(unsigned lineno, int argc, char* argv[])
+{
+	char *table =3D "filter";
+	int ret =3D 0;
+
+#ifdef IP6T_LIB_DIR
+	if(!strcmp(argv[0], "ip6tables"))
+	{
+		ip6tc_handle_t handle =3D NULL;
+		ret =3D do_command6(argc, argv, &table, &handle);
+		if (ret)
+			ret =3D ip6tc_commit(&handle);
+
+		if (!ret)
+			fprintf(stderr, "line %d: %s\n", lineno, ip6tc_strerror(errno));
+	}
+#else
+	if(!strcmp(argv[0], "iptables"))
+	{
+		iptc_handle_t handle =3D NULL;
+
+		ret =3D do_command(argc, argv, &table, &handle);
+		if (ret)
+			ret =3D iptc_commit(&handle);
+
+		if (!ret)
+			fprintf(stderr, "line %d: %s\n", lineno, iptc_strerror(errno));
+	}
+#endif
+	else
+	{
+		fprintf(stderr, "line %d: invalid command '%s'\n", lineno, argv[0]);
+	}
+
+	return ret;
+}
+
+int
+main(int argc, char *argv[])
+{
+	int ret =3D 1;
+	size_t llen =3D 0;
+	char* line =3D NULL;
+	ssize_t r =3D -1;
+	int nargc =3D 0;
+	char* nargv[256];
+	unsigned lineno =3D 0;
+	FILE* fp =3D stdin;
+
+#ifdef IP6T_LIB_DIR
+	program_name =3D "ip6tables-batch";
+#else
+	program_name =3D "iptables-batch";
+#endif
+	program_version =3D IPTABLES_VERSION;
+
+#ifdef NO_SHARED_LIBS
+	init_extensions();
+#endif
+	if(argc > 1)
+	{
+		fp =3D fopen(argv[1], "r");
+		if(!fp)
+		{
+			perror("fopen");
+			exit(1);
+		}
+	}
+
+	while((r =3D getline(&line, &llen, fp)) !=3D -1)
+	{
+		if(llen < 1)
+			continue;
+		if(line[strlen(line)-1] =3D=3D '\n')
+			line[strlen(line) -1 ] =3D '\0';
+
+		++lineno;
+		nargc =3D 0;
+		errstr =3D NULL;
+		ret =3D tokenize(&nargc, nargv, (sizeof(nargv)/sizeof(nargv[0])), line);
+		if(ret =3D=3D -1)
+		{
+		}
+		else if (ret =3D=3D 0)
+		{
+			continue;
+		}
+		else if(nargc < 2)
+		{
+			errstr =3D "not enough arguments";
+		}
+
+		if(errstr)
+		{
+			fprintf(stderr, "parse error in line %d: %s\n", lineno, errstr);
+			ret =3D 0;
+			break;
+		}
+
+		ret =3D do_iptables(lineno, nargc, nargv);
+		if(!ret) break;
+		//dumpargv(nargc, nargv);
+
+	}
+
+	exit(!ret);
+}
Index: iptables-1.2.9/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-1.2.9.orig/Makefile
+++ iptables-1.2.9/Makefile
@@ -102,6 +102,12 @@
 iptables: iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=3D\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(L=
DLIBS)
=20
+iptables-batch: iptables-batch.c iptables.o $(STATIC_LIBS) libiptc/libiptc=
=2Ea
+	$(CC) $(CFLAGS) -DIPT_LIB_DIR=3D\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(L=
DLIBS)
+
+ip6tables-batch: iptables-batch.c ip6tables.o $(STATIC6_LIBS) libiptc/libi=
ptc.a
+	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=3D\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(=
LDLIBS)
+
 $(DESTDIR)$(BINDIR)/iptables: iptables
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@

--=20
 (o_   Ludwig Nussel
 //\   SUSE LINUX AG, Development
 V_/_  http://www.suse.de/

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBPI9VI5RDGv+BNc4RAgjnAJ49wc9ftLyNnqYBAiRS7BqEVbpltgCfbu4d
qS46etLFkO2hCDWuL5eV39Y=
=f+fa
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
