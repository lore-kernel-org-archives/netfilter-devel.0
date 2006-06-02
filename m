From: Paul Millar <paul@astro.gla.ac.uk>
Subject: Patch for graphing a rule-set
Date: Fri, 2 Jun 2006 17:37:15 +0100
Message-ID: <200606021737.20890.paul@astro.gla.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart127726071.7YpGffOJbF";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

--nextPart127726071.7YpGffOJbF
Content-Type: multipart/mixed;
  boundary="Boundary-01=_7kGgEgTRNpk6g8i"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_7kGgEgTRNpk6g8i
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

I've attached a patch against iptables v1.3.5 that implements graphing for =
the=20
iptables command.  This patch adds the  "--graph" ( or -r) qualifier to the=
=20
normal list (-L) command.  When specified, the output is in dot format, as=
=20
used by graphviz:
  http://www.graphviz.org/

I wanted a nice way to document some firewall rules and this (rather simple=
)=20
patch allowed that.  With some PHP, I'd imagine one could graph-on-demand t=
he=20
current firewall state of a machine, if that's of any use.

To get a sample output do:
  sudo ./iptables -L -r | fdp -Tsvg -oiptables.svg; inkview iptables.svg
or
  sudo ./iptables -L -r | fdp -Tps -oiptables.ps;  gv iptables.ps
or ...

I've put an example (in svg and ps format) here:
  http://ppewww.ph.gla.ac.uk/~paul/iptables-graph.svg
  http://ppewww.ph.gla.ac.uk/~paul/iptables-graph.ps

The code's rather cosmetic, fairly hacky and somewhat rough-and-ready: do w=
ith=20
it what you will!  I get a message
  iptables: Incompatible with this kernel
which might be a result of the patch.  I've not spent much time tracking th=
is=20
down further.

Cheers,

Paul.

--Boundary-01=_7kGgEgTRNpk6g8i
Content-Type: text/x-diff;
  charset="us-ascii";
  name="graph-patch.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="graph-patch.diff"

=2D-- iptables.c.org	2006-05-14 11:46:29.000000000 +0100
+++ iptables.c	2006-05-22 20:36:16.000000000 +0100
@@ -98,11 +98,20 @@
 #define OPT_VIANAMEIN	0x00080U
 #define OPT_VIANAMEOUT	0x00100U
 #define OPT_FRAGMENT    0x00200U
=2D#define OPT_LINENUMBERS 0x00400U
=2D#define OPT_COUNTERS	0x00800U
=2D#define NUMBER_OF_OPT	12
+#define OPT_GRAPH       0x00400U
+#define OPT_LINENUMBERS 0x00800U
+#define OPT_COUNTERS	0x01000U
+#define NUMBER_OF_OPT	13
 static const char optflags[NUMBER_OF_OPT]
=2D=3D { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c'};
+=3D { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', 'r', '0', 'c'};
+
+static const char *builtin_chains[] =3D {
+  "INPUT",
+  "FORWARD",
+  "OUTPUT",
+  "PREROUTING",
+  "POSTROUTING"
+};
=20
 static struct option original_opts[] =3D {
 	{ "append", 1, 0, 'A' },
@@ -136,6 +145,7 @@
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
 	{ "goto", 1, 0, 'g' },
+	{ "graph", 0,  0, 'r' },
 	{ 0 }
 };
=20
@@ -160,20 +170,20 @@
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =3D
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
=2D	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line */
=2D/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
=2D/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
=2D/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
=2D/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
=2D/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' '},
=2D/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x'},
=2D/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x'},
=2D/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  -r  --line */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ',' '},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x','x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
=20
 static int inverse_for_options[NUMBER_OF_OPT] =3D
@@ -188,6 +198,7 @@
 /* -i */ IPT_INV_VIA_IN,
 /* -o */ IPT_INV_VIA_OUT,
 /* -f */ IPT_INV_FRAG,
+/* -r */ 0,
 /*--line*/ 0
 };
=20
@@ -410,6 +421,7 @@
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
+"  --graph	-r              produce graph instead of text output\n"
 "  --out-interface -o [!] output name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
@@ -1420,7 +1432,7 @@
 		printf("[goto] ");
 #endif
=20
=2D	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, format & FMT_NUMERIC);
+	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, FMT_NUMERIC);
=20
 	if (target) {
 		if (target->print)
@@ -1649,14 +1661,209 @@
 	return iptc_delete_chain(chain, handle);
 }
=20
+
+int
+is_builtin( const char *name)
+{
+  int i;
+ =20
+  for( i =3D 0; i < sizeof( builtin_chains) / sizeof( char *); i++)
+    if( !strcmp( builtin_chains[i], name))
+      return 1;
+
+  return 0;
+}
+
+
+void
+print_label( const struct ipt_entry *entry, iptc_handle_t *handle)
+{
+  const char *targname, *t;
+  char buf[40];
+  struct iptables_target *target =3D NULL;
+  u_int8_t flags;
+  int have_printed=3D0;
+
+  targname =3D iptc_get_target(entry, handle);
+
+  if (!iptc_is_chain(targname, *handle))
+    target =3D find_target(targname, TRY_LOAD);
+  else
+    target =3D find_target(IPT_STANDARD_TARGET, LOAD_MUST_SUCCEED);
+ =20
+  t =3D ipt_get_target((struct ipt_entry *)entry);
+  flags =3D entry->ip.flags;
+
+  char *pname =3D proto_to_name( entry->ip.proto, 0);
+  if (pname) {
+    if( strcmp( pname, "all")) {
+      have_printed=3D1;
+      printf( "%s ", pname);
+    }
+  }
+  else {
+    printf( "%hu ", entry->ip.proto);
+    have_printed=3D1;
+  }
+
+
+  char iface[IFNAMSIZ+2];	=09
+
+  if (entry->ip.invflags & IPT_INV_VIA_IN) {
+    iface[0] =3D '!';
+    iface[1] =3D '\0';
+  }
+  else iface[0] =3D '\0';
+ =20
+  if (entry->ip.iniface[0] !=3D '\0') {
+    strcat(iface, entry->ip.iniface);
+    printf( "in=3D%s ", iface);
+    have_printed=3D1;
+  }
+
+  if (entry->ip.invflags & IPT_INV_VIA_OUT) {
+    iface[0] =3D '!';
+    iface[1] =3D '\0';
+  }
+  else iface[0] =3D '\0';
+ =20
+  if (entry->ip.outiface[0] !=3D '\0') {
+    strcat(iface, entry->ip.outiface);
+    printf( "out=3D%s ", iface);
+    have_printed=3D1;
+  }
+
+
+  fputc(entry->ip.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
+
+  if( entry->ip.smsk.s_addr !=3D 0L) {
+    sprintf(buf, "%s", addr_to_dotted(&(entry->ip.src)));
+    strcat(buf, mask_to_dotted(&(entry->ip.smsk)));
+    printf( "src=3D%s", buf);
+    have_printed=3D1;
+  }
+
+
+  fputc(entry->ip.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
+
+  if( entry->ip.dmsk.s_addr !=3D 0L) {
+    sprintf( buf, "%s", addr_to_dotted(&(entry->ip.dst)));
+    strcat( buf, mask_to_dotted(&(entry->ip.dmsk)));
+    printf( "dst=3D%s ", buf);
+    have_printed=3D1;
+  }
+
+
+  IPT_MATCH_ITERATE(entry, print_match, &entry->ip, FMT_NUMERIC);
+
+
+  if( !iptc_is_chain(targname, *handle)) {
+      printf( "[%s]", targname);
+      have_printed =3D 1;
+  }
+
+  if( !have_printed)
+    printf( "all");
+}
+
+
 static int
=2Dlist_entries(const ipt_chainlabel chain, int verbose, int numeric,
+graph_entries(const ipt_chainlabel chain, iptc_handle_t *handle)
+{
+  const char *this;
+  const char *pol, *target;
+  struct ipt_counters counters;
+  const struct ipt_entry *i;
+  int n;
+
+  /* Print header info */
+  printf( "digraph iptables {\n"
+	  "  graph [\n"
+	  "    rankdir =3D \"LR\"\n"
+	  "    ratio =3D 1.414\n"
+	  "    splines =3D \"true\"\n"
+	  "  ];\n"
+	  "  node [\n"
+	  "    shape =3D \"record\"\n"
+	  "    fillcolor =3D \"#e0d0e0\"\n"
+	  "    style=3Dfilled\n"
+	  "  ]\n"
+	  "  edge [\n"
+	  "    weight =3D 0.1\n"
+          "  ]\n"
+	  );
+
+  /* Print all chains */
+  for (this =3D iptc_first_chain(handle);
+       this;
+       this =3D iptc_next_chain(handle)) {
+
+    pol =3D iptc_get_policy(this, &counters, handle);
+
+    printf( "\n  \"%s\" [\n", this);
+
+    if( is_builtin( this))
+      printf( "    fillcolor =3D \"#d0e0d0\"\n");
+
+
+    printf( "    label =3D \"{<1>\\N");
+    if( pol)
+      printf( " [%s]", pol);
+
+    n=3D2;
+    for( i =3D iptc_first_rule(this, handle);
+	 i;=20
+	 i =3D iptc_next_rule(i, handle)) {
+      printf( " | <%u> ", n++);
+      print_label( i, handle);
+    }
+
+    printf( "}\"\n"); /* End of label */
+
+    printf( "  ]\n");
+  }
+
+
+  /* Print all the links  */
+  for (this =3D iptc_first_chain(handle);
+       this;  =20
+       this =3D iptc_next_chain(handle)) {
+
+    n=3D2;
+    for( i =3D iptc_first_rule(this, handle);
+	 i;=20
+	 i =3D iptc_next_rule(i, handle)) {
+
+      target =3D iptc_get_target( i, handle);
+
+      if( !is_builtin( target) && iptc_is_chain( target, *handle))
+	printf( "\"%s\":%u -> \"%s\":1\n",
+		this,
+		n,
+		target);
+      n++;
+    }
+    if( n > 2)
+      printf( "\n");
+  }
+
+  printf( "}\n");
+
+  return 0;
+}
+
+
+static int
+list_entries(const ipt_chainlabel chain, int graph, int verbose, int numer=
ic,
 	     int expanded, int linenumbers, iptc_handle_t *handle)
 {
 	int found =3D 0;
 	unsigned int format;
 	const char *this;
=20
+	if( graph)
+	  return graph_entries( chain, handle);
+
 	format =3D FMT_OPTIONS;
 	if (!verbose)
 		format |=3D FMT_NOCOUNTS;
@@ -1877,7 +2084,7 @@
 	opterr =3D 0;
=20
 	while ((c =3D getopt_long(argc, argv,
=2D	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:r",
 					   opts, NULL)) !=3D -1) {
 		switch (c) {
 			/*
@@ -2189,6 +2396,11 @@
 		=09
 			break;
=20
+		case 'r': /* Graph output */
+   		        set_option(&options, OPT_GRAPH, &fw.ip.invflags,
+				   invert);
+			break;
+
=20
 		case 1: /* non option */
 			if (optarg[0] =3D=3D '!' && optarg[1] =3D=3D '\0') {
@@ -2449,6 +2661,7 @@
 		break;
 	case CMD_LIST:
 		ret =3D list_entries(chain,
+				   options&OPT_GRAPH,
 				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
@@ -2463,6 +2676,7 @@
 		break;
 	case CMD_LIST|CMD_ZERO:
 		ret =3D list_entries(chain,
+				   options&OPT_GRAPH,
 				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,

--Boundary-01=_7kGgEgTRNpk6g8i--

--nextPart127726071.7YpGffOJbF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEgGlACvCDPV5t1VQRAkviAJ9VzPwEs31A6tQJgABMxIIcF7Us2gCfY+6X
t8zc7U6hVJGmD1yDi42BEQk=
=cN/t
-----END PGP SIGNATURE-----

--nextPart127726071.7YpGffOJbF--
