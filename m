From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Mon, 11 Apr 2005 09:47:41 +0000
Message-ID: <425A47BD.9070508@outerspace.dyndns.org>
References: <20050407113830.02B0.LARK@linux.net.cn>	<20050407054302.GC20287@oknodo.bof.de>	<20050407135853.02BA.LARK@linux.net.cn>	<20050407063547.GD20287@oknodo.bof.de>
	<20050407064323.GE20287@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010902030702030108020804"
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050407064323.GE20287@oknodo.bof.de>
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
--------------010902030702030108020804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Patrick Schaaf on 2005-04-07 06:43 UTC:

| Hmm, regarding --previous... Do we have two bits spare in the
| general rule structure, which could indicate 'match just like
| the previous match did', and 'match exactly if the previous
| match did NOT match'?

Yes. IPT_F_MASK has many spare bits, and IPT_INV_MASK has exactly one
bit left (same for ipv6).

| It we do have such bits spare, a general --previous-matched
| and --previous-failed syntax might be easier than a new match
| with signature change or percpu variables: all decision logic
| stays properly localized in the table scanning main loop.

This is my implementation exactly. I also believe this does not break
binary compatibility; it just extends the use of the bitmasks, and
"older" iptables clients will just never set the bits in question - and
in the other way around when the iptables binary supports --previous but
the kernel doesnt no problems occur unless the user tries to use --previous.

| BTW, it just occurred to be that --previous-failed, a logical
| consequence of the --previous idea :), is a nice thing to
| have by itself: it permits proper if/then/else semantics
| for nonterminating targets!

Naturally, I thought of this too.. :)

| iptables -A xxx --previous-failed -j LOG --log-prefix "NOT-thisandthat: "

actually..

iptables -A xxx ! --previous -j LOG ...

There's one slight peculiarity with the current implementation.. if one
wants to use a target that works only for some specific protocol, say
TARPIT, one needs to:

iptables -A INPUT --previous -p tcp -j TARPIT

.. I haven't yet investigated if it would be possible to inherit the
protocol nicely..

I include only the kernel part of the patch for now so you can study and
complain about it :) I have some pending fixes for ip6tables that I want
to go in first before posting the iptables patch, which is trivial anyway..

I'm sorry for the long delay.. as you see from the patch it was done
more than three weeks ago.. :/ Otoh I tested it properly only last week.

- ----

I have also been thinking a bit about the original suggestion by Ben La
Monica in the thread "Multiple Targets" to allow multiple targets:

Quoting Patrick Schaaf on 2005-02-19 08:28 UTC:

|> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j
|> MARK,RETURN --set-mark 1
|> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j
|> MARK,RETURN --set-mark 2
|
| Problem: target options. How would the commandline parser see that
| --set-mark belongs to MARK, and --log-prefix belongs to LOG? What
| about the hypothetical case of several targets having target options
| with identical names?

How about:

iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 \
~  -j MARK --set-mark 1 -j RETURN

and further:

iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 \
~  -j MARK --set-mark 1 -j LOG --log-prefix "mark!" -j RETURN

This way the options would be clearly grouped and easily parsable. The
amount of targets (in the structs passed from/to userspace and used in
the kernel) could probably be made flexible, just like the matches are.
Even with the current iptables the target can be omitted, so it actually
already has some flexibility :)

This all would possibly, although not necessarily break binary
compatibility with the kernel. I am not familiar with the extendability
of the userspace "api"..

Even if it would break binary compatibility, I see how it could be
useful for users with large rulesets, since this could possibly halve
the amount of rules needed, and I think at that point these users might
be willing to recompile iptables to get that benefit, and of course
others who just like the comfort :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCWke2xyF48ZTvn+4RArC0AJ9pFgdW+kfBSstLRjumo2fTGvuTkwCeLf3M
YCvA+Z/rjQkWAJdlf2HgFRk=
=3twV
-----END PGP SIGNATURE-----

--------------010902030702030108020804
Content-Type: text/x-patch;
 name="linux-2.6.10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.10.patch"

/home/xkr47/bin/Linux_AuthenticAMD/xkrdiff
diff --exclude-from=/tmp/srcdiff.excludes.tcxXkn -Np -x autoconf.h -ur history/140/linux/include/linux/netfilter_ipv4/ip_tables.h linux/include/linux/netfilter_ipv4/ip_tables.h
--- 140/include/linux/netfilter_ipv4/ip_tables.h	2005-03-16 17:09:11.000000000 +0200
+++ linux/include/linux/netfilter_ipv4/ip_tables.h	2005-03-17 02:17:33.000000000 +0200
@@ -110,6 +110,7 @@ struct ipt_counters
 /* Values for "flag" field in struct ipt_ip (general ip structure). */
 #define IPT_F_FRAG		0x01	/* Set if rule is a fragment rule */
-#define IPT_F_MASK		0x01	/* All possible flag bits mask. */
+#define IPT_F_PREVIOUS		0x02	/* Set if dependent on previous rule */
+#define IPT_F_MASK		0x03	/* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ipt_ip. */
 #define IPT_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
@@ -120,7 +121,8 @@ struct ipt_counters
 #define IPT_INV_DSTIP		0x10	/* Invert the sense of DST OP. */
 #define IPT_INV_FRAG		0x20	/* Invert the sense of FRAG. */
 #define IPT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
-#define IPT_INV_MASK		0x7F	/* All possible flag bits mask. */
+#define IPT_INV_PREVIOUS	0x80	/* Invert the sense of PREVIOUS. */
+#define IPT_INV_MASK		0xFF	/* All possible flag bits mask. */
 
 /* This structure defines each of the firewall rules.  Consists of 3
    parts which are 1) general IP header stuff 2) match specific
diff --exclude-from=/tmp/srcdiff.excludes.tcxXkn -Np -x autoconf.h -ur history/140/linux/include/linux/netfilter_ipv6/ip6_tables.h linux/include/linux/netfilter_ipv6/ip6_tables.h
--- 140/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-16 17:09:16.000000000 +0200
+++ linux/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-17 05:13:02.000000000 +0200
@@ -112,6 +112,7 @@ struct ip6t_counters
 					   protocols */
 #define IP6T_F_TOS		0x02	/* Match the TOS. */
-#define IP6T_F_MASK		0x03	/* All possible flag bits mask. */
+#define IP6T_F_PREVIOUS	0x04    /* Set if dependent on previous rule */
+#define IP6T_F_MASK		0x07    /* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ip6t_ip6. */
 #define IP6T_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
@@ -122,7 +123,8 @@ struct ip6t_counters
 #define IP6T_INV_DSTIP		0x10	/* Invert the sense of DST OP. */
 #define IP6T_INV_FRAG		0x20	/* Invert the sense of FRAG. */
 #define IP6T_INV_PROTO		0x40	/* Invert the sense of PROTO. */
-#define IP6T_INV_MASK		0x7F	/* All possible flag bits mask. */
+#define IP6T_INV_PREVIOUS	0x80    /* Invert the sense of PREVIOUS. */
+#define IP6T_INV_MASK		0xFF    /* All possible flag bits mask. */
 
 /* This structure defines each of the firewall rules.  Consists of 3
    parts which are 1) general IP header stuff 2) match specific
diff --exclude-from=/tmp/srcdiff.excludes.tcxXkn -Np -x autoconf.h -ur history/140/linux/net/ipv4/netfilter/ip_tables.c linux/net/ipv4/netfilter/ip_tables.c
--- 140/net/ipv4/netfilter/ip_tables.c	2005-03-16 17:09:11.000000000 +0200
+++ linux/net/ipv4/netfilter/ip_tables.c	2005-03-17 05:07:34.000000000 +0200
@@ -131,7 +131,8 @@ ip_packet_match(const struct iphdr *ip,
 		const char *indev,
 		const char *outdev,
 		const struct ipt_ip *ipinfo,
-		int isfrag)
+		int isfrag,
+		int previous_matched)
 {
 	size_t i;
 	unsigned long ret;
@@ -201,6 +202,14 @@ ip_packet_match(const struct iphdr *ip,
 		return 0;
 	}
 
+	/* If we have a "previous" rule but the previous rule didn't match
+	 * then we return zero */
+	if (FWINV((ipinfo->flags&IPT_F_PREVIOUS) && !previous_matched, IPT_INV_PREVIOUS)) {
+		dprintf("Previous rule but previous didn't match.%s\n",
+			ipinfo->invflags & IPT_INV_PREVIOUS ? " (INV)" : "");
+		return 0;
+	}
+
 	return 1;
 }
 
@@ -274,6 +283,7 @@ ipt_do_table(struct sk_buff **pskb,
 	const char *indev, *outdev;
 	void *table_base;
 	struct ipt_entry *e, *back;
+	int previous_matched = 0; // update when and only when variable "e" changes
 
 	/* Initialization */
 	ip = (*pskb)->nh.iph;
@@ -314,14 +324,14 @@ ipt_do_table(struct sk_buff **pskb,
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |= e->nfcache;
-		if (ip_packet_match(ip, indev, outdev, &e->ip, offset)) {
+		if (ip_packet_match(ip, indev, outdev, &e->ip, offset, previous_matched)) {
 			struct ipt_entry_target *t;
 
 			if (IPT_MATCH_ITERATE(e, do_match,
 					      *pskb, in, out,
 					      offset, &hotdrop) != 0)
 				goto no_match;
-
+			
 			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
 
 			t = ipt_get_target(e);
@@ -340,6 +350,11 @@ ipt_do_table(struct sk_buff **pskb,
 					e = back;
 					back = get_entry(table_base,
 							 back->comefrom);
+
+					 /* return from chain, verdict must
+					    be 1 since we went there in the
+					    first place */
+					previous_matched = 1;
 					continue;
 				}
 				if (table_base + v
@@ -354,6 +369,10 @@ ipt_do_table(struct sk_buff **pskb,
 				}
 
 				e = get_entry(table_base, v);
+
+				/* gosub chain -> previous "undefined" when
+				   entering */
+				previous_matched = 0;
 			} else {
 				/* Targets which reenter must return
                                    abs. verdicts */
@@ -387,11 +406,14 @@ ipt_do_table(struct sk_buff **pskb,
 				else
 					/* Verdict */
 					break;
+
+				previous_matched = 1;
 			}
 		} else {
 
 		no_match:
 			e = (void *)e + e->next_offset;
+			previous_matched = 0;
 		}
 	} while (!hotdrop);
 
diff --exclude-from=/tmp/srcdiff.excludes.tcxXkn -Np -x autoconf.h -ur history/140/linux/net/ipv6/netfilter/ip6_tables.c linux/net/ipv6/netfilter/ip6_tables.c
--- 140/net/ipv6/netfilter/ip6_tables.c	2005-03-16 17:09:16.000000000 +0200
+++ linux/net/ipv6/netfilter/ip6_tables.c	2005-03-17 05:12:05.000000000 +0200
@@ -162,7 +162,8 @@ ip6_packet_match(const struct sk_buff *s
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
 		 unsigned int *protoff,
-		 int *fragoff)
+		 int *fragoff,
+		 int previous_matched)
 {
 	size_t i;
 	unsigned long ret;
@@ -290,6 +291,15 @@ ip6_packet_match(const struct sk_buff *s
 			!(ip6info->invflags & IP6T_INV_PROTO))
 			return 0;
 	}
+
+	/* If we have a "previous" rule but the previous rule didn't match
+	 * then we return zero */
+	if (FWINV((ip6info->flags&IP6T_F_PREVIOUS) && !previous_matched, IP6T_INV_PREVIOUS)) {
+		dprintf("Previous rule but previous didn't match.%s\n",
+			ip6info->invflags & IP6T_INV_PREVIOUS ? " (INV)" : "");
+		return 0;
+	}
+
 	return 1;
 }
 
@@ -365,6 +375,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	const char *indev, *outdev;
 	void *table_base;
 	struct ip6t_entry *e, *back;
+	int previous_matched = 0; // update when and only when variable "e" changes
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -404,7 +415,7 @@ ip6t_do_table(struct sk_buff **pskb,
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |= e->nfcache;
 		if (ip6_packet_match(*pskb, indev, outdev, &e->ipv6,
-			&protoff, &offset)) {
+			&protoff, &offset, previous_matched)) {
 			struct ip6t_entry_target *t;
 
 			if (IP6T_MATCH_ITERATE(e, do_match,
@@ -433,6 +444,11 @@ ip6t_do_table(struct sk_buff **pskb,
 					e = back;
 					back = get_entry(table_base,
 							 back->comefrom);
+
+					/* return from chain, verdict must
+					   be 1 since we went there in the
+					   first place */
+					previous_matched = 1;
 					continue;
 				}
 				if (table_base + v
@@ -447,6 +463,9 @@ ip6t_do_table(struct sk_buff **pskb,
 				}
 
 				e = get_entry(table_base, v);
+				/* gosub chain -> previous "undefined" when
+				   entering */
+				previous_matched = 0;
 			} else {
 				/* Targets which reenter must return
                                    abs. verdicts */
@@ -476,11 +495,14 @@ ip6t_do_table(struct sk_buff **pskb,
 				else
 					/* Verdict */
 					break;
+
+				previous_matched = 1;
 			}
 		} else {
 
 		no_match:
 			e = (void *)e + e->next_offset;
+			previous_matched = 0;
 		}
 	} while (!hotdrop);
 

--------------010902030702030108020804
Content-Type: text/plain;
 name="help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="help"

Add a flag that lets you use the result of the previous rule.

Can be used to optimize away unnecessary duplicate rule matching like:

  iptables -A INPUT -p tcp --dport 137 -j LOG --log-prefix windows
  iptables -A INPUT -p tcp --dport 137 -j DROP

with:

  iptables -A INPUT -p tcp --dport 137 -j LOG --log-prefix windows
  iptables -A INPUT --previous -j DROP

Also, when the matching has side-effects (like counters or rate limiters),
these can be avoided with --previous. Also, the inverse can be used, and
--previous can be used multiple times in a row.

It can also be used to simulate "goto" like this:

  iptables -A INPUT ... -j SOMEWHERE
  iptables -A INPUT --previous -j RETURN

--------------010902030702030108020804--
