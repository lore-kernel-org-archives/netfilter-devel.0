From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Suggestion for RETURN target
Date: Wed, 3 Dec 2003 23:49:46 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312032328360.12468-400000@filer.marasystems.com>
References: <3FCE47D1.C07304F8@info-link.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1463848606-1070491092=:12468"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCE47D1.C07304F8@info-link.net>
Content-ID: <Pine.LNX.4.44.0312032345150.12522@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1463848606-1070491092=:12468
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0312032345151.12522@filer.marasystems.com>

On Wed, 3 Dec 2003, Brad Fisher wrote:

> Would there be any chance of a patch for the goto functionality being accepted
> then?

Hope so.

> custom patch for myself.  If anyone else is interested, then I'd be open
> to suggestions on how it should work.  For example:
> 
>   # Normal 'jump' (call)
>   iptables -j custom_chain
> 
>   # Add '-g' (goto) argument to iptables userspace?
>   iptables -g custom_chain

This one (-g/--goto instead of -j/--jump) is what I would prefer.

> And of course there'd have to be a flag somewhere in the rule/target struct itself
> which would indicate the calling chain shouldn't be added to the call stack.

There is plenty of space for flags left..

Attached you can find a patch which implements the above using a new flag
in the ip.flags field. What is missing from the patch is that iptables -L
does not indicate the difference between a jump and a goto. iptables-save
is done. Have tried to make the patch in such manner that binary and 
source compatibility is kept for the userspace.

Regards
Henrik

---1463811839-1463848606-1070491092=:12468
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="goto.patch"
Content-ID: <Pine.LNX.4.44.0312032338120.12468@filer.marasystems.com>
Content-Description: kernel patch
Content-Disposition: ATTACHMENT; FILENAME="goto.patch"

--- linux-2.4.22-uml/include/linux/netfilter_ipv4/ip_tables.h	Wed Dec  3 23:12:11 2003
+++ linux-2.4.22-goto/include/linux/netfilter_ipv4/ip_tables.h	Wed Dec  3 22:12:30 2003
@@ -104,7 +104,8 @@
 
 /* Values for "flag" field in struct ipt_ip (general ip structure). */
 #define IPT_F_FRAG		0x01	/* Set if rule is a fragment rule */
-#define IPT_F_MASK		0x01	/* All possible flag bits mask. */
+#define IPT_F_GOTO		0x02	/* Set if jump is a goto */
+#define IPT_F_MASK		0x03	/* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ipt_ip. */
 #define IPT_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
--- linux-2.4.22-uml/net/ipv4/netfilter/ip_tables.c	Wed Dec  3 23:12:11 2003
+++ linux-2.4.22-goto/net/ipv4/netfilter/ip_tables.c	Wed Dec  3 22:22:19 2003
@@ -342,7 +342,7 @@
 					continue;
 				}
 				if (table_base + v
-				    != (void *)e + e->next_offset) {
+				    != (void *)e + e->next_offset && !(e->ip.flags & IPT_F_GOTO)) {
 					/* Save old back ptr in next entry */
 					struct ipt_entry *next
 						= (void *)e + e->next_offset;
---1463811839-1463848606-1070491092=:12468
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="goto.patch.help"
Content-ID: <Pine.LNX.4.44.0312032338121.12468@filer.marasystems.com>
Content-Description: readme
Content-Disposition: ATTACHMENT; FILENAME="goto.patch.help"

Author: Henrik Nordstrom <hno@marasystems.com>
Status: working

This patch adds kernel support for goto type jumps
---1463811839-1463848606-1070491092=:12468
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="goto.patch.userspace"
Content-ID: <Pine.LNX.4.44.0312032338122.12468@filer.marasystems.com>
Content-Description: userspace patch
Content-Disposition: ATTACHMENT; FILENAME="goto.patch.userspace"

Index: iptables.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/iptables.c,v
retrieving revision 1.59
diff -u -w -p -r1.59 iptables.c
--- userspace/iptables.c	31 May 2003 21:30:33 -0000	1.59
+++ userspace/iptables.c	3 Dec 2003 22:26:44 -0000
@@ -138,6 +138,7 @@ static struct option original_opts[] = {
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "goto", 1, 0, 'g' },
 	{ 0 }
 };
 
@@ -395,6 +396,10 @@ exit_printhelp(void)
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
@@ -1695,7 +1700,7 @@ int do_command(int argc, char *argv[], c
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1866,6 +1871,15 @@ int do_command(int argc, char *argv[], c
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
@@ -2216,6 +2230,11 @@ int do_command(int argc, char *argv[], c
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
Index: iptables.8
===================================================================
RCS file: /cvspublic/netfilter/userspace/iptables.8,v
retrieving revision 1.38
diff -u -w -p -r1.38 iptables.8
--- userspace/iptables.8	29 Jun 2003 18:00:08 -0000	1.38
+++ userspace/iptables.8	3 Dec 2003 22:26:44 -0000
@@ -274,9 +274,17 @@ one this rule is in), one of the special
 the fate of the packet immediately, or an extension (see
 .B EXTENSIONS
 below).  If this
-option is omitted in a rule, then matching the rule will have no
+option is omitted in a rule (and
+.B -g
+is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
+.TP
+.BI "-g, --goto " "chain"
+This specifies that the processing should continue in a user
+specified chain. Unlike the --jump option return will not continue
+processing in this chain but instead in the chain that called us via
+--jump.
 .TP
 .BR "-i, --in-interface " "[!] \fIname\fP"
 Name of an interface via which a packet is going to be received (only for
---1463811839-1463848606-1070491092=:12468--
