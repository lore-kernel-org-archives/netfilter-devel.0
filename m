From: Brad Fisher <brad@info-link.net>
Subject: Re: Suggestion for RETURN target
Date: Thu, 04 Dec 2003 13:13:32 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCF875C.FDCAB795@info-link.net>
References: <Pine.LNX.4.44.0312032328360.12468-400000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------E3BEA6E22DF00E82EED85B53"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------E3BEA6E22DF00E82EED85B53
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Henrik Nordstrom wrote:

> There is plenty of space for flags left..
>
> Attached you can find a patch which implements the above using a new flag
> in the ip.flags field. What is missing from the patch is that iptables -L
> does not indicate the difference between a jump and a goto. iptables-save
> is done. Have tried to make the patch in such manner that binary and
> source compatibility is kept for the userspace.
>
> Regards
> Henrik

I have tested your patch, and it seems to work well.  Attached you will find a modified
version which patches iptables-save, and iptables -L.  It seems a little funny to me to
add the IPT_F_GOTO flag into the ip flags, but it makes sense to make use of the unused
space.  I would think it would make more logical sense to have it attached to the target
structure, but that would break binary compatibility, which I think is important to
preserve.

In all, I think this new patch does what I require, thanks for the quick response and
the great patch.  I had actually started looking at this but hadn't gotten far before
you posted it.  I apppreciate the time you put into it and hope that it at least gets
included in patch-o-matic :)

-Brad

--------------E3BEA6E22DF00E82EED85B53
Content-Type: text/plain; charset=us-ascii;
 name="goto.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="goto.patch.userspace"

diff -urN iptables-1.2.9/iptables-save.c iptables-1.2.9-goto/iptables-save.c
--- iptables-1.2.9/iptables-save.c	Sat May  3 13:52:13 2003
+++ iptables-1.2.9-goto/iptables-save.c	Thu Dec  4 12:06:25 2003
@@ -188,8 +188,14 @@
 
 	/* Print target name */	
 	target_name = iptc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-		printf("-j %s ", target_name);
+	if (target_name && (*target_name != '\0')) {
+#ifdef IPT_F_GOTO
+		if (e->ip.flags & IPT_F_GOTO)
+			printf("-g %s ", target_name);
+		else
+#endif
+			printf("-j %s ", target_name);
+	}
 
 	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);
diff -urN iptables-1.2.9/iptables.8 iptables-1.2.9-goto/iptables.8
--- iptables-1.2.9/iptables.8	Mon Jun 30 11:16:54 2003
+++ iptables-1.2.9-goto/iptables.8	Wed Dec  3 17:03:04 2003
@@ -274,10 +274,18 @@
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
 packets entering the 
diff -urN iptables-1.2.9/iptables.c iptables-1.2.9-goto/iptables.c
--- iptables-1.2.9/iptables.c	Sat Jun 14 17:39:35 2003
+++ iptables-1.2.9-goto/iptables.c	Thu Dec  4 12:28:02 2003
@@ -138,6 +138,7 @@
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "goto", 1, 0, 'g' },
 	{ 0 }
 };
 
@@ -395,6 +396,10 @@
 "				network interface name ([+] for wildcard)\n"
 "  --jump	-j target\n"
 "				target for rule (may load target extension)\n"
+#ifdef IPT_F_GOTO
+"  --goto	-g chain\n"
+"				jump to chain with no return\n"
+#endif
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
@@ -1269,6 +1274,11 @@
 
 	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, format & FMT_NUMERIC);
 
+#ifdef IPT_F_GOTO
+	if (flags & IPT_F_GOTO)
+		printf("GOTO ");
+#endif
+	
 	if (target) {
 		if (target->print)
 			/* Print the target information. */
@@ -1695,7 +1705,7 @@
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1866,6 +1876,15 @@
 			fw.nfcache |= NFC_IP_DST;
 			break;
 
+#ifdef IPT_F_GOTO
+		case 'g':
+			set_option(&options, OPT_JUMP, &fw.ip.invflags,
+				   invert);
+			fw.ip.flags |= IPT_F_GOTO;
+			jumpto = parse_target(optarg);
+			break;
+#endif
+
 		case 'j':
 			set_option(&options, OPT_JUMP, &fw.ip.invflags,
 				   invert);
@@ -2216,6 +2235,11 @@
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
+#ifdef IPT_F_GOTO
+			if (fw.ip.flags & IPT_F_GOTO)
+				exit_error(PARAMETER_PROBLEM,
+					    "goto '%s' is not a chain\n", jumpto);
+#endif
 			find_target(jumpto, LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&fw, iptables_matches, target->t);

--------------E3BEA6E22DF00E82EED85B53--
