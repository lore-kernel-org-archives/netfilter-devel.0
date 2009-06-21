From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] Core changes for better error reporting to
 userspace.
Date: Sun, 21 Jun 2009 02:50:07 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906210227510.8096@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48254 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZFUAuF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:50:05 -0400
In-Reply-To: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-06-20 23:56, Jozsef Kadlecsik wrote:
>@@ -210,6 +219,9 @@ struct xt_match_param {
>  * @match:	struct xt_match through which this function was invoked
>  * @matchinfo:	per-match data
>  * @hook_mask:	via which hooks the new rule is reachable
>+ * @family:	protocol family
>+ * @proto:	transport protocol
>+ * @inverted:	transport protocol check is inverted

Should preferably be named nfproto and l4proto/thproto to avoid confusion.
Similarly I would sugegst thinv... something as 'inverted' alone seems
generic.

>  */
> struct xt_mtchk_param {
> 	const char *table;

You are adding a number of fields here and there, but they are not
used until later patches. I think that is a bit obscure, and would
have splitted things differently[1], for I now have to go back and
forth and figure out just what extensions actually make use of
the new fields.

[1] (E.g. "make function unsigned", "add proto/inverted and do proto checks
inside matches", and so on) Due to the mass of files it touches,
splitting it between matches/targets or even per-struct instead
of arp/v4/v6 seems like a good idea.

>@@ -217,7 +229,10 @@ struct xt_mtchk_param {
> 	const struct xt_match *match;
> 	void *matchinfo;
> 	unsigned int hook_mask;
>+	u_int16_t proto;
> 	u_int8_t family;
>+	bool inverted;
>+	bool compat_log;

nfproto is a uint8 too.

> };
> 
> /* Match destructor parameters */
>@@ -259,7 +274,10 @@ struct xt_tgchk_param {
> 	const struct xt_target *target;
> 	void *targinfo;
> 	unsigned int hook_mask;
>+	u_int16_t proto;
> 	u_int8_t family;
>+	bool inverted;
>+	bool compat_log;

Same here

>@@ -284,8 +302,9 @@ struct xt_match
> 	bool (*match)(const struct sk_buff *skb,
> 		      const struct xt_match_param *);
> 
>-	/* Called when user tries to insert an entry of this type. */
>-	bool (*checkentry)(const struct xt_mtchk_param *);
>+	/* Called when user tries to insert an entry of this type.
>+	 * Returns zero or a positive errno. */
>+	unsigned int (*checkentry)(const struct xt_mtchk_param *);
> 
> 	/* Called when entry of this type deleted. */
> 	void (*destroy)(const struct xt_mtdtor_param *);

This change will flag up tons of compiler warnings (because only
later patches fix it up), but see note above[1].

>-	ret = xt_check_match(par, m->match_size,
>-	      e->ethproto, e->invflags & EBT_IPROTO);
>-	if (ret < 0) {
>+	par->proto     = e->ethproto;
>+	par->inverted  = e->invflags & EBT_IPROTO;
>+	ret = xt_check_match(par, m->match_size);

This is where things can go wrong, in theory. Above, proto was
said to be the 'transport protocol', but ethproto is actually
the network protocol. Ick :/
Suggestion to use

	/* When nfproto is NFPROTO_BRIDGE, use l3proto, otherwise l4proto. */
	union {
		uint8_t l3proto;
		uint8_t l4proto;
	};

to be a bit futureproof.

>+
>+static int get_replace(struct net *net, void __user *user, int *len)
>+{
	[...]
>+#ifndef ARPT_ENTRY_MATCH_INTRODUCED
>+			ret = -EFAULT;
>+#else

Where was this macro defined?

>index fdefae6..954e90e 100644
>--- a/net/ipv4/netfilter/ip_tables.c
>+++ b/net/ipv4/netfilter/ip_tables.c
>@@ -600,28 +600,30 @@ check_entry(struct ipt_entry *e, const char *name)
> 
> static int
> check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
>-	    unsigned int *i)
>+	    unsigned int *i, unsigned int *error_offset)
> {
> 	const struct ipt_ip *ip = par->entryinfo;
> 	int ret;
> 
> 	par->match     = m->u.kernel.match;
> 	par->matchinfo = m->data;
>+	par->proto     = ip->proto;
>+	par->inverted  = ip->invflags & IPT_INV_PROTO;

I like this one, because it makes it possible to possibly ditch
par->entryinfo from the extensions.

What I don't like with the approach...

>+static unsigned int icmp_checkentry(const struct xt_mtchk_param *par)
> {
>-	const struct ipt_icmp *icmpinfo = par->matchinfo;
>+	struct ipt_icmp *icmpinfo = par->matchinfo;
> 
>+	if (par->proto != IPPROTO_ICMP || par->inverted) {
>+		xt_compat_log(par, "icmp match: only valid for protocol ICMP");
>+		return IPT_ICMP_ERR_PROTO;
>+	}

We had that before, and replace it on
5d04bff096180f032de8b9b12153a8a1b4009b8d by centralized error checking.
Adding the replicated logic into extensions again looks like a step
backwards to me. At least for single-protocol extensions.
My word here: keep the centralized proto, hooks and table
checking and return a generic code if it does not match up.

>--- a/net/netfilter/x_tables.c
>+++ b/net/netfilter/x_tables.c
>@@ -329,34 +329,7 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
> }
> EXPORT_SYMBOL_GPL(xt_find_revision);
> 
>-static char *textify_hooks(char *buf, size_t size, unsigned int mask)
>-{
>-	static const char *const names[] = {
>-		"PREROUTING", "INPUT", "FORWARD",
>-		"OUTPUT", "POSTROUTING", "BROUTING",
>-	};
>-	unsigned int i;
>-	char *p = buf;
>-	bool np = false;
>-	int res;

You cannot remove textif_hooks, because I do not believe that userspace
knows which hooks an extension is usable from to report meaningful
error.

>-	if (par->match->table != NULL &&
>-	    strcmp(par->match->table, par->table) != 0) {
>-		pr_err("%s_tables: %s match: only valid in %s table, not %s\n",
>-		       xt_prefix[par->family], par->match->name,
>-		       par->match->table, par->table);
>-		return -EINVAL;
>-	}
>-	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
>-		char used[64], allow[64];
>-
>-		pr_err("%s_tables: %s match: used from hooks %s, but only "
>-		       "valid from %s\n",
>-		       xt_prefix[par->family], par->match->name,
>-		       textify_hooks(used, sizeof(used), par->hook_mask),
>-		       textify_hooks(allow, sizeof(allow), par->match->hooks));
>-		return -EINVAL;
>-	}
>-	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
>-		pr_err("%s_tables: %s match: only valid for protocol %u\n",
>-		       xt_prefix[par->family], par->match->name,
>-		       par->match->proto);
>-		return -EINVAL;
>-	}
>-	if (par->match->checkentry != NULL && !par->match->checkentry(par))
>-		return -EINVAL;
>+	if (par->match->checkentry != NULL)
>+		return par->match->checkentry(par);
> 	return 0;
> }
> EXPORT_SYMBOL_GPL(xt_check_match);
