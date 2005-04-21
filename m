From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: iptables-batch 2nd try
Date: Thu, 21 Apr 2005 14:20:08 +0200
Message-ID: <20050421122008.GA22032@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Another attempt, this time the commits for the tables are done at
the end like with iptables-restore. The purpose of this exercise is
to speed up an existing shell script (SuSEfirewall2) by writing
iptables calls into a file and run iptables-batch at the end instead of
fork/exec all the time. The script doesn't need to be changed much
for that, one basically just needs to redefine iptables as shell
function. If iptables-batch is not available the script can
transparently fall back to individual iptables calls.

cu
Ludwig

Index: iptables-1.3.1/iptables-batch.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-1.3.1/iptables-batch.c
@@ -0,0 +1,443 @@
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
+static unsigned current_line =3D 0;
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
+#ifdef DEBUG
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
+#endif
+
+struct table_handle
+{
+	char* name;
+#ifdef IP6T_LIB_DIR
+	ip6tc_handle_t handle;
+#else
+	iptc_handle_t handle;
+#endif
+};
+
+static struct table_handle* tables =3D NULL;
+static unsigned num_tables;
+struct table_handle* current_table;
+
+static void
+alloc_tables()
+{
+	tables =3D realloc(tables, sizeof(struct table_handle) * num_tables);
+}
+
+static void
+set_current_table(const char* name)
+{
+	unsigned i;
+
+	if(!strcmp(name, current_table->name)) // same as last time?
+		return;
+
+	for(i =3D 0; i < num_tables; ++i) // find already known table
+	{
+		if(!strcmp(name, tables[i].name))
+		{
+			current_table =3D &tables[i];
+			return;
+		}
+	}
+
+	// table name not known, create new
+	i =3D num_tables++;
+	alloc_tables();
+	current_table =3D &tables[i];
+	current_table->name =3D strdup(name);
+	current_table->handle =3D NULL;
+}
+
+static int
+find_table(int argc, char* argv[])
+{
+	int i;
+	for(i =3D 0; i < argc; ++i)
+	{
+		if(!strcmp(argv[i], "-t") || !strcmp(argv[i], "--table"))
+		{
+			++i;
+			if(i >=3D argc)
+			{
+				fprintf(stderr, "line %d: missing table name after %s\n",
+						current_line, argv[i]);
+				return 0;
+			}
+			set_current_table(argv[i]);
+			return 1;
+		}
+	}
+
+	// no -t specified
+	set_current_table("filter");
+
+	return 1;
+}
+
+static int
+do_iptables(int argc, char* argv[])
+{
+	char *table =3D "filter";
+	int ret =3D 0;
+
+	if(!find_table(argc, argv))
+		return 0;
+
+#ifdef IP6T_LIB_DIR
+	ret =3D do_command6(argc, argv, &table, &current_table->handle);
+
+	if (!ret)
+	{
+		fprintf(stderr, "line %d: %s\n", current_line, ip6tc_strerror(errno));
+	}
+	else
+	{
+		if(!table || strcmp(table, current_table->name))
+		{
+			fprintf(stderr, "line %d: expected table %s, got %s\n",
+					current_line, current_table->name, table);
+			exit(1);
+		}
+	}
+#else
+	ret =3D do_command(argc, argv, &table, &current_table->handle);
+
+	if (!ret)
+	{
+		fprintf(stderr, "line %d: %s\n", current_line, iptc_strerror(errno));
+	}
+	else
+	{
+		if(!table || strcmp(table, current_table->name))
+		{
+			fprintf(stderr, "line %d: expected table %s, got %s\n",
+					current_line, current_table->name, table);
+			exit(1);
+		}
+	}
+#endif
+
+	return ret;
+}
+
+static int
+do_commit()
+{
+	unsigned i;
+	int ret =3D 1;
+
+	for(i =3D 0; i < num_tables; ++i)
+	{
+		if(tables[i].handle)
+		{
+#ifdef IP6T_LIB_DIR
+			ret &=3D ip6tc_commit(&tables[i].handle);
+#else
+			ret &=3D iptc_commit(&tables[i].handle);
+#endif
+		}
+	}
+
+	return ret;
+}
+
+static void
+help()
+{
+	fprintf(stderr, "Usage: %s [FILE]\n\n", program_name);
+	puts("Read iptables commands from FILE, commit them at EOF\n");
+	puts("In addition to normal iptables calls the commands");
+	puts("'commit' and 'exit' are understood.");
+	exit(0);
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
+	FILE* fp =3D stdin;
+
+#ifdef IP6T_LIB_DIR
+	program_name =3D "ip6tables-batch";
+
+	lib_dir =3D getenv("IP6TABLES_LIB_DIR");
+	if (!lib_dir)
+		lib_dir =3D IP6T_LIB_DIR;
+#else
+	program_name =3D "iptables-batch";
+
+	lib_dir =3D getenv("IPTABLES_LIB_DIR");
+	if (!lib_dir)
+		lib_dir =3D IPT_LIB_DIR;
+#endif
+	program_version =3D IPTABLES_VERSION;
+
+#ifdef NO_SHARED_LIBS
+	init_extensions();
+#endif
+	if(argc > 1)
+	{
+		if(!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h"))
+		{
+			help();
+		}
+		else if(strcmp(argv[1], "-"))
+		{
+			fp =3D fopen(argv[1], "r");
+			if(!fp)
+			{
+				perror("fopen");
+				exit(1);
+			}
+		}
+	}
+
+	num_tables =3D 3;
+	alloc_tables();
+	tables[0].name =3D strdup("filter");
+	tables[0].handle =3D NULL;
+	tables[1].name =3D strdup("mangle");
+	tables[1].handle =3D NULL;
+	tables[2].name =3D strdup("nat");
+	tables[2].handle =3D NULL;
+	current_table =3D &tables[0];
+
+	while((r =3D getline(&line, &llen, fp)) !=3D -1)
+	{
+		if(llen < 1 || !*line)
+			continue;
+		if(line[strlen(line)-1] =3D=3D '\n')
+			line[strlen(line) -1 ] =3D '\0';
+
+		++current_line;
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
+		else if(nargc < 1)
+		{
+			errstr =3D "insufficient number of arguments";
+		}
+
+		if(errstr)
+		{
+			fprintf(stderr, "parse error in line %d: %s\n", current_line, errstr);
+			ret =3D 0;
+			break;
+		}
+
+#ifdef DEBUG
+		dumpargv(nargc, nargv);
+#endif
+
+#ifdef IP6T_LIB_DIR
+		if(!strcmp(nargv[0], "ip6tables"))
+#else
+		if(!strcmp(nargv[0], "iptables"))
+#endif
+		{
+			ret =3D do_iptables(nargc, nargv);
+			if(!ret) break;
+		}
+		else if(!strcmp(nargv[0], "exit"))
+		{
+			break;
+		}
+		else if(!strcmp(nargv[0], "commit"))
+		{
+			ret =3D do_commit();
+			if(!ret) break;
+		}
+		else
+		{
+			fprintf(stderr, "line %d: invalid command '%s'\n", current_line, nargv[=
0]);
+		}
+	}
+
+	if(ret)
+		ret =3D do_commit();
+
+	exit(!ret);
+}
Index: iptables-1.3.1/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-1.3.1.orig/Makefile
+++ iptables-1.3.1/Makefile
@@ -130,6 +130,12 @@ iptables: iptables-standalone.c iptables
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=3D\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(L=
DLIBS)
 endif
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
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCZ5p4I5RDGv+BNc4RAt+SAJ4xFKnN2x4G5/NIQZGb1242tx0CYgCgla42
cfmGjBXNd1oV+Xx475G9NT8=
=kGkf
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
