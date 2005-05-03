From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Tue, 03 May 2005 23:48:52 +0000
Message-ID: <42780DE4.9060808@outerspace.dyndns.org>
References: <20050413152307.0312.LARK@linux.net.cn>
	<425CEFE3.2010200@rtij.nl>	<20050413182822.0317.LARK@linux.net.cn>
	<425CFFE0.1000803@rtij.nl>	<20050413112518.GB22865@oknodo.bof.de>	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>	<7174b1e40504140101b5138e0@mail.gmail.com>	<425E3032.2060409@outerspace.dyndns.org>	<Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
	<425E6E4C.2010406@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010506080300090905060904"
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <425E6E4C.2010406@outerspace.dyndns.org>
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

This is a multi-part message in MIME format.
--------------010506080300090905060904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Jonas Berlin on 2005-04-14 13:21 UTC:

>>>All which is technically required for this while keeping full binary
>>>copatibility is to modify non-terminal targets to register themselves as
>>>matches in addition to targets.
> 
> Does iptables have any requirement that matches have to be lowercase?

It seemed not.

>>>The only thing holding this back is a conceptual design question if you
>>>should be allowed to mix non-terminal targets and matches freely, but
>>>this can be addressed in userspace if desired to force all non-terminal
>>>targets last in the match list.
> 
> I think the return values of targets used as matches should verified to
> be IPT_CONTINUE (or whatever it was called) and syslog messages written
> if that wasn't the case. In either case, the return value would not be
> used for anything else..

As a first test, I tested with the LOG target, since that's what people
mostly ask for :)

What I did was I made LOG register itself as both a target and a match.
I kept the name in uppercase which avoided creating new modules.

So this is how it works (I have tested it quickly):

  iptables -A OUTPUT [...] -m LOG --log-prefix "wohoo" -j ACCEPT

instead of:

  iptables -A OUTPUT [...] -j LOG --log-prefix "wohoo"
  iptables -A OUTPUT [...] -j ACCEPT


Alternative implementations:

a) Do you think my idea of updating each potential target with match
code is ok, or

b) should maybe iptables automatically let one use any non-builtin
target as a match directly, or

c) same as b) but instead only let one use targets that have a special
flag set in their ipt_target structure, or

d) same as c) but instead add another struct ipt_match_target interface
(and accompanying register_match_target()) that have modified function
prototypes with only arguments common to both matches and targets..

pros & cons:

a) is trivial to implement and error-prone due to its mechanical nature.
However it doesn't require any changes to the generic netfilter code.

b) unfortunately lets one use targets that are not suitable as matches,
but lets one use any target without updating all targets that could be
used as matches.

c) requires minimal updates to the targets that are suitable (adding one
line), but might be a bit hacky since it would convert match arguments
to target arguments and possibly not all arguments can be given sane
values..

d) requires more modification to the individual targets than c) but less
than a) and does not clutter the source code of the targets like a) does.

To make it clear, the patches attached are implemented according to a).

I would go for a) or d)..

> I will be away until next Monday, but if you still haven't started
> implementing this by then, I will probably give it a shot :) Otoh I

I took my time but here it is :)

Comments, please :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCeA3ixyF48ZTvn+4RAndpAJwJ8eQMOWdtwunqTXhOv/eJ8C1GnQCgrKYz
b3gX3rOJEtpkVzMs92zT3RE=
=oiRA
-----END PGP SIGNATURE-----

--------------010506080300090905060904
Content-Type: text/x-patch;
 name="LOG-match-iptables.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="LOG-match-iptables.diff"

diff -Np -ur orig-iptables-1.3.1/extensions/libipt_LOG.c iptables-1.3.1/extensions/libipt_LOG.c
--- orig-iptables-1.3.1/extensions/libipt_LOG.c	2005-04-02 09:38:39.000000000 +0300
+++ iptables-1.3.1/extensions/libipt_LOG.c	2005-05-04 01:59:01.000000000 +0300
@@ -111,10 +111,8 @@ parse_level(const char *level)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct ipt_log_info *loginfo)
 {
-	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
-
 	switch (c) {
 	case '!':
 		if (*flags & IPT_LOG_OPT_LEVEL)
@@ -195,6 +193,25 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
+static int
+parse_target(int c, char **argv, int invert, unsigned int *flags,
+	     const struct ipt_entry *entry,
+	     struct ipt_entry_target **target)
+{
+	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
+	return parse(c, argv, invert, flags, entry, loginfo);
+}
+
+static int
+parse_match(int c, char **argv, int invert, unsigned int *flags,
+	    const struct ipt_entry *entry,
+	    unsigned int *nfcache,
+	    struct ipt_entry_match **match)
+{
+	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*match)->data;
+	return parse(c, argv, invert, flags, entry, loginfo);
+}
+
 /* Final check; nothing. */
 static void final_check(unsigned int flags)
 {
@@ -203,11 +220,9 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct ipt_log_info *loginfo,
       int numeric)
 {
-	const struct ipt_log_info *loginfo
-		= (const struct ipt_log_info *)target->data;
 	unsigned int i = 0;
 
 	printf("LOG ");
@@ -241,13 +256,31 @@ print(const struct ipt_ip *ip,
 		printf("prefix `%s' ", loginfo->prefix);
 }
 
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+print_target(const struct ipt_ip *ip,
+	     const struct ipt_entry_target *target,
+	     int numeric)
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
+	print(ip, loginfo, numeric);
+}
+
+static void
+print_match(const struct ipt_ip *ip,
+	    const struct ipt_entry_match *match,
+	    int numeric)
+{
+	const struct ipt_log_info *loginfo
+		= (const struct ipt_log_info *)match->data;
+	print(ip, loginfo, numeric);
+}
+
 
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_log_info *loginfo)
+{
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
 
@@ -264,8 +297,24 @@ save(const struct ipt_ip *ip, const stru
 		printf("--log-uid ");
 }
 
+static void
+save_target(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	const struct ipt_log_info *loginfo
+		= (const struct ipt_log_info *)target->data;
+	save(ip, loginfo);
+}
+
+static void
+save_match(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_log_info *loginfo
+		= (const struct ipt_log_info *)match->data;
+	save(ip, loginfo);
+}
+
 static
-struct iptables_target log
+struct iptables_target log_target
 = {
     .name          = "LOG",
     .version       = IPTABLES_VERSION,
@@ -273,14 +322,30 @@ struct iptables_target log
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_log_info)),
     .help          = &help,
     .init          = &init,
-    .parse         = &parse,
+    .parse         = &parse_target,
     .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
+    .print         = &print_target,
+    .save          = &save_target,
     .extra_opts    = opts
 };
 
+static
+struct iptables_match log_match
+= { 
+	.name		= "LOG",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_log_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_log_info)),
+	.help		= &help,
+	.parse		= &parse_match,
+	.final_check	= &final_check,
+	.print		= &print_match,
+	.save		= &save_match,
+	.extra_opts	= opts
+};
+
 void _init(void)
 {
-	register_target(&log);
+	register_target(&log_target);
+	register_match(&log_match);
 }

--------------010506080300090905060904
Content-Type: text/x-patch;
 name="LOG-match-linux-2.6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="LOG-match-linux-2.6.diff"

diff -Np -ur orig-linux-2.6.11/net/ipv4/netfilter/ipt_LOG.c linux-2.6.11/net/ipv4/netfilter/ipt_LOG.c
--- orig-linux-2.6.11/net/ipv4/netfilter/ipt_LOG.c	2005-04-12 18:41:37.000000000 +0300
+++ linux-2.6.11/net/ipv4/netfilter/ipt_LOG.c	2005-05-04 01:40:14.000000000 +0300
@@ -350,8 +350,7 @@ static void dump_packet(const struct ipt
 }
 
 static void
-ipt_log_packet(unsigned int hooknum,
-	       const struct sk_buff *skb,
+ipt_log_packet(const struct sk_buff *skb,
 	       const struct net_device *in,
 	       const struct net_device *out,
 	       const struct ipt_log_info *loginfo,
@@ -408,11 +407,28 @@ ipt_log_target(struct sk_buff **pskb,
 	char level_string[4] = "< >";
 
 	level_string[1] = '0' + (loginfo->level % 8);
-	ipt_log_packet(hooknum, *pskb, in, out, loginfo, level_string, NULL);
+	ipt_log_packet(*pskb, in, out, loginfo, level_string, NULL);
 
 	return IPT_CONTINUE;
 }
 
+static int
+ipt_log_match(const struct sk_buff *skb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      const void *matchinfo,
+	      int offset,
+	      int *hotdrop)
+{
+	const struct ipt_log_info *loginfo = matchinfo;
+	char level_string[4] = "< >";
+
+	level_string[1] = '0' + (loginfo->level % 8);
+	ipt_log_packet(skb, in, out, loginfo, level_string, NULL);
+
+	return 1;
+}
+
 static void
 ipt_logfn(unsigned int hooknum,
 	  const struct sk_buff *skb,
@@ -426,20 +442,19 @@ ipt_logfn(unsigned int hooknum,
 		.prefix = "" 
 	};
 
-	ipt_log_packet(hooknum, skb, in, out, &loginfo, KERN_WARNING, prefix);
+	ipt_log_packet(skb, in, out, &loginfo, KERN_WARNING, prefix);
 }
 
 static int ipt_log_checkentry(const char *tablename,
-			      const struct ipt_entry *e,
-			      void *targinfo,
-			      unsigned int targinfosize,
+			      void *info,
+			      unsigned int infosize,
 			      unsigned int hook_mask)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = info;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_log_info))) {
-		DEBUGP("LOG: targinfosize %u != %u\n",
-		       targinfosize, IPT_ALIGN(sizeof(struct ipt_log_info)));
+	if (infosize != IPT_ALIGN(sizeof(struct ipt_log_info))) {
+		DEBUGP("LOG: infosize %u != %u\n",
+		       infosize, IPT_ALIGN(sizeof(struct ipt_log_info)));
 		return 0;
 	}
 
@@ -457,20 +472,49 @@ static int ipt_log_checkentry(const char
 	return 1;
 }
 
-static struct ipt_target ipt_log_reg = {
+static int ipt_log_target_checkentry(const char *tablename,
+				     const struct ipt_entry *e,
+				     void *targinfo,
+				     unsigned int targinfosize,
+				     unsigned int hook_mask)
+{
+	return ipt_log_checkentry(tablename, targinfo, targinfosize, hook_mask);
+}
+
+static int ipt_log_match_checkentry(const char *tablename,
+				    const struct ipt_ip *ip,
+				    void *matchinfo,
+				    unsigned int matchinfosize,
+				    unsigned int hook_mask)
+{
+	return ipt_log_checkentry(tablename, matchinfo, matchinfosize, hook_mask);
+}
+
+static struct ipt_target ipt_log_target_reg = {
 	.name		= "LOG",
 	.target		= ipt_log_target,
-	.checkentry	= ipt_log_checkentry,
+	.checkentry	= ipt_log_target_checkentry,
+	.me		= THIS_MODULE,
+};
+
+static struct ipt_match ipt_log_match_reg = {
+	.name		= "LOG",
+	.match		= &ipt_log_match,
+	.checkentry	= &ipt_log_match_checkentry,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
-	if (ipt_register_target(&ipt_log_reg))
+	if (ipt_register_target(&ipt_log_target_reg))
+		return -EINVAL;
+	if (ipt_register_match(&ipt_log_match_reg)) {
+		ipt_unregister_target(&ipt_log_target_reg);
 		return -EINVAL;
+	}
 	if (nflog)
 		nf_log_register(PF_INET, &ipt_logfn);
-	
+
 	return 0;
 }
 
@@ -478,7 +522,8 @@ static void __exit fini(void)
 {
 	if (nflog)
 		nf_log_unregister(PF_INET, &ipt_logfn);
-	ipt_unregister_target(&ipt_log_reg);
+	ipt_unregister_match(&ipt_log_match_reg);
+	ipt_unregister_target(&ipt_log_target_reg);
 }
 
 module_init(init);

--------------010506080300090905060904--
