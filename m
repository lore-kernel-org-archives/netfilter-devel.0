From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: scrubbing support in Netfilter
Date: Tue, 27 May 2008 18:33:08 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr>
References: <87hccjdbm4.fsf@chdir.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Bareil <nicolas.bareil@eads.net>
To: Nicolas Bareil <nico@chdir.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44683 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYE0QdK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 12:33:10 -0400
In-Reply-To: <87hccjdbm4.fsf@chdir.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2008-05-27 17:12, Nicolas Bareil wrote:
>
>
>I developped a Netfilter module which performs packet normalization, the
>"scrubbing" feature of OpenBSD[1]. Normalized trafic offers the
>following possibilities :

I seem to remember that Linux's TCP or nf_conntrack already does
some scrubbing.

>The current patch achieves the following transformations :
>
>* IPv4
>  - Random IP ID
>  - Zeroify ToS

Zeroify? Clearing the TOS is probably not a good idea because
it defeats packet scheduling (if it uses TOS).

>  - TTL normalization
>
>* TCP
> - Random TCP Sequence

I wonder if Linux already has this.

> - TCP Options
>   - Random Timestamp

Is this even RFC compatible?

>   - Sanity checks on MSS

>The following patch is "self-contained" : only nf_conntrack_proto_tcp.c is
>modified, the other files are new. The iptables patch is following this
>email. 

I suggest you have a look at "Writing your own Netfilter modules"
(abbreviated NFM in this reply) document from
http://jengelh.medozas.de/ , since I have seen a few outdated
constructs in your code.

>+	ct = nf_ct_get(skb, &ctinfo);
>+	if (!ct) {
>+		DEBUGP("ipt_SCRUB: No conntrack matching this packet.\n");
>+		return XT_CONTINUE;
>+	}
>+	nfscrub = nfct_scrub(ct);
>+	if (!nfscrub)
>+		nf_scrub_setup(skb, ct, ctinfo, info);
>+
>+	return XT_CONTINUE; /* XXX final decision: NF_ACCEPT ou XT_CONTINUE ? */
>+}

XT_CONTINUE is correct here, since you are in the mangle table,
so it is not an XXX case anymore :-)

>+static bool ipt_scrub_checkentry(const char *tablename,
>+				 const void *e,
>+				 const struct xt_target *target,
>+				 void *targinfo,
>+				 unsigned int hook_mask)
>+{
>+	return 1; /* There should be no invalid configuration possible */
>+}

Remove this function.

>+/*
>+ * nf_scrub_ip_tos_adjust()
>+ *
>+ * Overwrite the IP ToS with 0. Things like SSH, telnet use
>+ * this field (in vain on Internet ?).
>+ *
>+ */
>+void nf_scrub_ip_tos_adjust(struct iphdr *iph
>+			    , struct nf_conn *ct)
>+{
>+	NF_CT_ASSERT(iph);
>+	csum_replace2(&iph->check, ntohs(iph->tos), 0);
>+	iph->tos = 0;
>+}

Yes they do, don't just nuke it!

>+bool nf_scrub_ipv4_adjust(struct sk_buff *skb
>+			  , struct nf_conn *ct
>+			  , enum ip_conntrack_info ctinfo)
>+{
>+	struct iphdr *iph = ip_hdr(skb);
>+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
>+	struct tcphdr *th;
>+	NF_CT_ASSERT(iph && ct);
>+
>+	if (ct->scrub & SCRUB_TCP_OPTIONS) {
>+		th = (struct tcphdr *) (((caddr_t)iph)+iph->ihl*4);
>+		if (!nf_scrub_tcp_parse_options(th, ct, ctinfo))
>+			return NF_DROP;
>+	}

Use tcp_hdr(). caddr_t? No, this is not BSD. [Also elsewhere.]
Try the book :)

>+obj-$(CONFIG_NF_SCRUB) += ip6t_SCRUB.o

Write a single module, as described in NFM.

>+	if (nexthdr == IPPROTO_TCP) {
>+		tcp = (struct tcphdr *)(skb_network_header(skb)+tcpoff);
>+		nf_scrub_tcp_setup(skb, tcp, ct, ctinfo);
>+	}
>+	return true;
>+}
>+EXPORT_SYMBOL(nf_scrub_ipv6_setup);

tcp_hdr?

>+++ b/net/netfilter/nf_conntrack_proto_tcp.c
>@@ -26,6 +26,10 @@
>...
>+	if (test_bit(SCRUB_TCP_SEQ_ADJUST_BIT, &ct->scrub)
>+	    && dir == IP_CT_DIR_ORIGINAL) {
>+		if (!nf_scrub_tcp_seq_adjust((struct tcphdr *)th, ct, ctinfo))
>+			return -NF_ACCEPT;
>+	}
>+#endif
>...
>+#ifdef CONFIG_NF_SCRUB_NEEDED
>+	if (test_bit(SCRUB_TCP_SEQ_ADJUST_BIT, &ct->scrub)
>+	    && dir == IP_CT_DIR_REPLY) {
>+		if (!nf_scrub_tcp_ack_adjust((struct tcphdr *)th, ct, ctinfo))
>+			return -NF_ACCEPT;
>+
>+		if (!nf_scrub_tcp_sack_adjust((struct tcphdr *)th, ct, ctinfo))
>+			return -NF_ACCEPT;
>+	}
>+#endif

Instead of adding casts to th, just remove the const from th, no?


>Here is the iptables patch.
>
>+static void help(void) 
>+{
>+	printf(
>+"SCRUB target v%s options\n"
>+"  --rand-ipid value		Set a random IP ID\n"
>+, XTABLES_VERSION);
>+}

XTABLES_VERSION does not really reflect the SCRUB version.
Just write "SCRUB target options:\n"

>+static int parse(int c, char **argv, int invert, unsigned int *flags,
>+		const void *entry,
>+		struct xt_entry_target **target)
>+{
>+	struct ipt_scrub_info *info = (struct ipt_scrub_info *) (*target)->data;
>+
>+        *flags=1;
>+
>+	switch (c) {
>+	case '!':
>+		/* do not overwrite "--no-something" */
>+		info->flags= (SCRUB_ALL & ~info->flags) ;
>+

Possibly unwanted fallthrough?

>+	case '2':
>+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.scrubbing_default)) == -1)

Stack corruption. Don't just mindlessy use casts...

>+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
>+		break;
>+
>+	case '3':
>+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.modifying_threshold)) == -1)
>+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
>+		break;
>+
>+	case '4':
>+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.dropping_threshold)) == -1)
>+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
>+		break;

Same..

>+static void save(const void *ip, const struct xt_entry_target *target)
>+{
>+}
>+

Something *is* *missing*. :)

>+static struct option opts[] = {
>+	{ "scrub-everything", 0, 0, '!'},
>+	{ "ip-zero-tos", 0, 0, '0'},
>+	{ "ip-rand-id", 0, 0, '1' },
>+
>+	{ "ip-ttl-scrub", 0, 0, '9'},
>+	{ "ip-ttl-default", 1, 0, '2'},
>+	{ "ip-ttl-low-threshold", 1, 0, '3'},
>+	{ "ip-ttl-dropping-threshold", 1, 0, '4'},
>+	{ "ip-ttl-sealed", 0, 0, '5'},
>+
>+	{ "tcp-rand-seq", 0, 0, '6'},
>+	{ "tcp-opt-rand-timestamp", 0, 0, '7'},
>+	{ "tcp-opt-check-mss", 0, 0, '8'},
>+
>+	/* inverse parameter, is there another way */

Well you could make use of `iptables -j SCRUB ! --tcp-rand-seq`.
(See NFM book on how to scan for '!'.)

>+static struct xtables_target SCRUB = {
>+	.next		= NULL, 

Unspecified fields are always initialized to NULL, so..

>+	.name		= "SCRUB",
>+	.version	= XTABLES_VERSION,
>+	.size		= XT_ALIGN(sizeof(struct ipt_scrub_info)),
>+	.userspacesize	= XT_ALIGN(sizeof(struct ipt_scrub_info)),
>+	.help		= help,
>+	.init		= init,
>+	.parse		= parse,
>+	.final_check	= final_check,
>+	.print		= print,
>+	.save		= save,
>+	.extra_opts	= opts 
>+};
>+


>index 0000000..7d21083
>--- /dev/null
>+++ b/extensions/libipt_SCRUB.c

And _everything_ again. Suggest to combine all the code.
