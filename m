From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/6] Core changes for better error reporting to
 userspace.
Date: Sun, 21 Jun 2009 15:04:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906211419120.12674@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu> <alpine.LSU.2.00.0906210227510.8096@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38379 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZFUNEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:04:41 -0400
In-Reply-To: <alpine.LSU.2.00.0906210227510.8096@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 21 Jun 2009, Jan Engelhardt wrote:

> On Saturday 2009-06-20 23:56, Jozsef Kadlecsik wrote:
> >@@ -210,6 +219,9 @@ struct xt_match_param {
> >  * @match:	struct xt_match through which this function was invoked
> >  * @matchinfo:	per-match data
> >  * @hook_mask:	via which hooks the new rule is reachable
> >+ * @family:	protocol family
> >+ * @proto:	transport protocol
> >+ * @inverted:	transport protocol check is inverted
> 
> Should preferably be named nfproto and l4proto/thproto to avoid confusion.
> Similarly I would sugegst thinv... something as 'inverted' alone seems
> generic.

I simply "reused" the variable names which were used in the same context 
(except of course 'inverted', which is a silly naming indeed).
 
> >  */
> > struct xt_mtchk_param {
> > 	const char *table;
> 
> You are adding a number of fields here and there, but they are not
> used until later patches. I think that is a bit obscure, and would
> have splitted things differently[1], for I now have to go back and
> forth and figure out just what extensions actually make use of
> the new fields.
> 
> [1] (E.g. "make function unsigned", "add proto/inverted and do proto checks
> inside matches", and so on) Due to the mass of files it touches,
> splitting it between matches/targets or even per-struct instead
> of arp/v4/v6 seems like a good idea.

It is not easy at all to make the patches independently working. Either I 
send one single 226k-sized patch, which can be compiled cleanly, or split 
up into - as far as possible - logically separated parts, but you have to 
apply all of them to get it working. I do not really see a way to separate 
them into "independetly compiling" parts.
 
> >@@ -217,7 +229,10 @@ struct xt_mtchk_param {
> > 	const struct xt_match *match;
> > 	void *matchinfo;
> > 	unsigned int hook_mask;
> >+	u_int16_t proto;
> > 	u_int8_t family;
> >+	bool inverted;
> >+	bool compat_log;
> 
> nfproto is a uint8 too.

The 'proto' field stores the value of the 'proto' field from ipt_ip, 
ip6t_ip, which is defined as u_int16_t.
 
> >-	ret = xt_check_match(par, m->match_size,
> >-	      e->ethproto, e->invflags & EBT_IPROTO);
> >-	if (ret < 0) {
> >+	par->proto     = e->ethproto;
> >+	par->inverted  = e->invflags & EBT_IPROTO;
> >+	ret = xt_check_match(par, m->match_size);
> 
> This is where things can go wrong, in theory. Above, proto was
> said to be the 'transport protocol', but ethproto is actually
> the network protocol. Ick :/
>
> Suggestion to use
> 
> 	/* When nfproto is NFPROTO_BRIDGE, use l3proto, otherwise l4proto. */
> 	union {
> 		uint8_t l3proto;
> 		uint8_t l4proto;
> 	};
> 
> to be a bit futureproof.

I did not pay big attention to the correct naming of 'proto' with respect 
to ebtables, because the field (and inverted too)  never checked in any 
ebtables extension. So to introduce one more level, just for the sake of 
ebtables, when it does not use that field... and ebtables is "alien" 
compared to the "normal" subsytems. We *know* that things are really 
different there...
 
> >+
> >+static int get_replace(struct net *net, void __user *user, int *len)
> >+{
> 	[...]
> >+#ifndef ARPT_ENTRY_MATCH_INTRODUCED
> >+			ret = -EFAULT;
> >+#else
> 
> Where was this macro defined?

Nowhere, forward compatibility: currenty there is no arp match extension.
(I simply wanted to keep the match-specific branch :-)
 
> >index fdefae6..954e90e 100644
> >--- a/net/ipv4/netfilter/ip_tables.c
> >+++ b/net/ipv4/netfilter/ip_tables.c
> >@@ -600,28 +600,30 @@ check_entry(struct ipt_entry *e, const char *name)
> > 
> > static int
> > check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
> >-	    unsigned int *i)
> >+	    unsigned int *i, unsigned int *error_offset)
> > {
> > 	const struct ipt_ip *ip = par->entryinfo;
> > 	int ret;
> > 
> > 	par->match     = m->u.kernel.match;
> > 	par->matchinfo = m->data;
> >+	par->proto     = ip->proto;
> >+	par->inverted  = ip->invflags & IPT_INV_PROTO;
> 
> I like this one, because it makes it possible to possibly ditch
> par->entryinfo from the extensions.

Yes, it is tempting to throw away par->entryinfo, because no checkentry 
uses it.
 
> What I don't like with the approach...
> 
> >+static unsigned int icmp_checkentry(const struct xt_mtchk_param *par)
> > {
> >-	const struct ipt_icmp *icmpinfo = par->matchinfo;
> >+	struct ipt_icmp *icmpinfo = par->matchinfo;
> > 
> >+	if (par->proto != IPPROTO_ICMP || par->inverted) {
> >+		xt_compat_log(par, "icmp match: only valid for protocol ICMP");
> >+		return IPT_ICMP_ERR_PROTO;
> >+	}
> 
> We had that before, and replace it on
> 5d04bff096180f032de8b9b12153a8a1b4009b8d by centralized error checking.
> Adding the replicated logic into extensions again looks like a step
> backwards to me. At least for single-protocol extensions.
> My word here: keep the centralized proto, hooks and table
> checking and return a generic code if it does not match up.

No, that'd be a bad choice. First, the centralized proto, hooks and table 
checking cannot cover all possible cases. Just one example: CONNMARK in 
restore mode can only be used from the mangle table, but otherwise it can 
be called from the other tables too. There are cases, when we have to 
check the proto, hooks and tables in the checkentry function anyway. 
Second, the centralized checking cannot send back error codes to the
userspace, so we'd have two error reporting channels: one via printk (for 
proto, hooks, table) and one via xt_error_entry (extensions). (Unless 
there'd be reserved error codes for the centralized checking, but that's 
unmanageable.)
 
> >--- a/net/netfilter/x_tables.c
> >+++ b/net/netfilter/x_tables.c
> >@@ -329,34 +329,7 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
> > }
> > EXPORT_SYMBOL_GPL(xt_find_revision);
> > 
> >-static char *textify_hooks(char *buf, size_t size, unsigned int mask)
> >-{
> >-	static const char *const names[] = {
> >-		"PREROUTING", "INPUT", "FORWARD",
> >-		"OUTPUT", "POSTROUTING", "BROUTING",
> >-	};
> >-	unsigned int i;
> >-	char *p = buf;
> >-	bool np = false;
> >-	int res;
> 
> You cannot remove textif_hooks, because I do not believe that userspace
> knows which hooks an extension is usable from to report meaningful
> error.

Userspace exactly knows the allowed hooks via the received 
extension-specific error codes. Check out for example how the NAT targets 
check the hooks, report the error and how that is decoded by the 
userspace.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
