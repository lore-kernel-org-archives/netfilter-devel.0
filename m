From: Thomas Jacob <jacob@internet24.de>
Subject: Re: ip6tables doesn't support --goto option
Date: Sat, 21 Jun 2008 16:43:12 +0200
Message-ID: <20080621144311.GA24248@internet24.de>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de> <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr> <1213988076.2466.2.camel@henriknordstrom.net> <485CBB76.4020206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:60442 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYFUOnO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:43:14 -0400
Content-Disposition: inline
In-Reply-To: <485CBB76.4020206@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--St7VIuEGZ6dlpu13
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 21, 2008 at 10:27:34AM +0200, Patrick McHardy wrote:
> I think it was me, I added the ip6_tables support, for seem to
> have forgotten about userspace.
>
> Does anyone wants to send a patch for this?

Here's what I got by copying the --goto changes from iptables.c,
not sure if it's complete, but it seems to work for me.

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ipv6goto.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 45b14dc..f5d33db 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -301,10 +301,18 @@ one this rule is in), one of the special builtin targ=
ets which decide
 the fate of the packet immediately, or an extension (see
 .B EXTENSIONS
 below).  If this
-option is omitted in a rule, then matching the rule will have no
+option is omitted in a rule (and
+.B -g
+is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
+.BI "-g, --goto " "chain"
+This specifies that the processing should continue in a user
+specified chain. Unlike the --jump option return will not continue
+processing in this chain but instead in the chain that called us via
+--jump.
+.TP
 .BR "-i, --in-interface " "[!] \fIname\fP"
 Name of an interface via which a packet is going to be received (only for
 packets entering the=20
diff --git a/ip6tables.c b/ip6tables.c
index e146114..2b05392 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -132,6 +132,7 @@ static struct option original_opts[] =3D {
 	{.name =3D "line-numbers",  .has_arg =3D 0, .val =3D '0'},
 	{.name =3D "modprobe",      .has_arg =3D 1, .val =3D 'M'},
 	{.name =3D "set-counters",  .has_arg =3D 1, .val =3D 'c'},
+	{.name =3D "goto",          .has_arg =3D 1, .val =3D 'g'},
 	{NULL},
 };
=20
@@ -328,6 +329,10 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --jump	-j target\n"
 "				target for rule (may load target extension)\n"
+#ifdef IP6T_F_GOTO
+"  --goto	-g chain\n"
+"				jump to chain with no return\n"
+#endif
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
@@ -823,6 +828,11 @@ print_firewall(const struct ip6t_entry *fw,
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
=20
+#ifdef IP6T_F_GOTO
+	if(fw->ipv6.flags & IP6T_F_GOTO)
+		printf("[goto] ");
+#endif
+
 	IP6T_MATCH_ITERATE(fw, print_match, &fw->ipv6, format & FMT_NUMERIC);
=20
 	if (target) {
@@ -1259,7 +1269,11 @@ void print_rule(const struct ip6t_entry *e,
 	/* Print target name */
 	target_name =3D ip6tc_get_target(e, h);
 	if (target_name && (*target_name !=3D '\0'))
+#ifdef IP6T_F_GOTO
+		printf("-%c %s ", e->ipv6.flags & IP6T_F_GOTO ? 'g' : 'j', target_name);
+#else
 		printf("-j %s ", target_name);
+#endif
=20
 	/* Print targinfo part */
 	t =3D ip6t_get_target((struct ip6t_entry *)e);
@@ -1447,7 +1461,7 @@ int do_command6(int argc, char *argv[], char **table,=
 ip6tc_handle_t *handle)
 	opterr =3D 0;
=20
 	while ((c =3D getopt_long(argc, argv,
-	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:",
+	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) !=3D -1) {
 		switch (c) {
 			/*
@@ -1638,6 +1652,15 @@ int do_command6(int argc, char *argv[], char **table=
, ip6tc_handle_t *handle)
 			dhostnetworkmask =3D argv[optind-1];
 			break;
=20
+#ifdef IP6T_F_GOTO
+		case 'g':
+			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
+					invert);
+			fw.ipv6.flags |=3D IP6T_F_GOTO;
+			jumpto =3D parse_target(optarg);
+			break;
+#endif
+
 		case 'j':
 			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
 				   invert);
@@ -1995,6 +2018,11 @@ int do_command6(int argc, char *argv[], char **table=
, ip6tc_handle_t *handle)
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
+#ifdef IP6T_F_GOTO
+			if (fw.ipv6.flags & IP6T_F_GOTO)
+				exit_error(PARAMETER_PROBLEM,
+						"goto '%s' is not a chain\n", jumpto);
+#endif
 			find_target(jumpto, LOAD_MUST_SUCCEED);
 		} else {
 			e =3D generate_entry(&fw, matches, target->t);

--cNdxnHkX5QqsyA0e--

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIXRN/gF9cFv867HwRAt6ZAKC2IHIY0JFaLTY08EZdtryou5WNiQCgjKRJ
Mzojo85i+afvadqIgZeV3mE=
=3aZe
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
