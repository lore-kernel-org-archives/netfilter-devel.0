From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] generic CONNTRACK target
Date: Mon, 14 Jan 2008 18:00:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801141734060.26458@fbirervta.pbzchgretzou.qr>
References: <478B8B74.3070903@netfilter.org> <478B8DF1.3060503@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39948 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYANRA3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:00:29 -0500
In-Reply-To: <478B8DF1.3060503@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 14 2008 17:29, Pablo Neira Ayuso wrote:
>Pablo Neira Ayuso wrote:
>> Attached an untested RFC patch [...]
>
>I forgot to attach the patch...
>

>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>+MODULE_DESCRIPTION("ip[6]tables CONNTRACK module");

A better description perhaps, along the lines of a recent patch of mine 
( http://marc.info/?l=netfilter-devel&m=119980886105511&w=2 )

>+#define CT_TG_MASK(x) (x->data_0)
>+#define CT_TG_MARK(x) (x->data_1)

			((x)->data_0)

>+static void mark_set(struct sk_buff *skb,
>+		     struct nf_conn *ct,
>+		     const struct xt_conntrack_tg_info *info)
>+{
>+	u_int32_t newmark;
>+
>+	newmark = (ct->mark & ~CT_TG_MASK(info)) | CT_TG_MARK(info);
>+	if (newmark != ct->mark) {
>+		ct->mark = newmark;
>+		nf_conntrack_event_cache(IPCT_MARK, skb);
>+	}
>+}

The CONNMARK v1 pieces should be added in the upcoming future.

>+static void notrack(struct sk_buff *skb,
>+		    struct nf_conn *ct,
>+		    const struct xt_conntrack_tg_info *info)
>+{
>+	/* Previously seen (loopback)? Ignore. */

xfrm probably.

>+	if (skb->nfct != NULL)
>+		return;
>+
>+	/* Attach fake conntrack entry.
>+	 * If there is a real ct entry correspondig to this packet,
>+	 * it'll hang aroun till timing out. We don't deal with it
>+	 * for performance reasons. JK */
>+	skb->nfct = &nf_conntrack_untracked.ct_general;
>+	skb->nfctinfo = IP_CT_NEW;
>+	nf_conntrack_get(skb->nfct);
>+}
>+
>+#define CT_TG_TIMEOUT(x) (x->data_0)

((x)->data_0)

>+typedef void (*ct_tg_array)(struct sk_buff *skb,
>+			    struct nf_conn *ct,
>+			    const struct xt_conntrack_tg_info *info);
>+
>+ct_tg_array conntrack_tg_array[CONNTRACK_TG_MAX] = {

^static const ct_tg_array conntrack_tg_array[] =

>+	[CONNTRACK_TG_MARK_SET]			= mark_set,
>+	[CONNTRACK_TG_MARK_SAVE]		= mark_save,
>+	[CONNTRACK_TG_MARK_RESTORE]		= mark_restore,
>+	[CONNTRACK_TG_SECMARK_SAVE]		= secmark_save,
>+	[CONNTRACK_TG_SECMARK_RESTORE]		= secmark_restore,
>+	[CONNTRACK_TG_NOTRACK]			= notrack,
>+	[CONNTRACK_TG_MANUAL_TIMEOUT]		= manual_timeout,
>+	[CONNTRACK_TG_VOLATILE_EVENTS]		= volatile_events,
>+};
>+
>+static bool
>+conntrack_tg_check(const char *tablename, const void *entry,
>+                   const struct xt_target *target, void *targinfo,
>+                   unsigned int hook_mask)
>+{
>+	const struct xt_conntrack_tg_info *info = targinfo;
>+
>+	switch(info->mode) {
>+	case CONNTRACK_TG_MARK_SET:
>+	case CONNTRACK_TG_MARK_SAVE:
>+	case CONNTRACK_TG_MARK_RESTORE:
>+	case CONNTRACK_TG_SECMARK_SAVE:
>+	case CONNTRACK_TG_SECMARK_RESTORE:
>+	case CONNTRACK_TG_MANUAL_TIMEOUT:
>+	case CONNTRACK_TG_VOLATILE_EVENTS:
>+		if (strcmp(tablename, "mangle") != 0) {
>+			printk(KERN_INFO PFX "use mode %hu in table "
>+					     "`mangle\'\n", info->mode);
>+			return false;

I had to give this a few seconds of thinking. At first interpretation, 
"use mode %hu in table mangle" sounds like "the mangle table can do 
%hu". Well, nice to know that mangle can do that, but that does not 
really say anything about why it failed.
I suggest changing the wording to what other targets/matches have:

"XXX is only valid in the YYY table"

>+		}
>+		break;
>+	case CONNTRACK_TG_NOTRACK:
>+		if (strcmp(tablename, "raw") != 0) {
>+			printk(KERN_INFO PFX "use mode: %hu in table "
>+					     "`raw\'\n", info->mode);
>+			return false;
>+		}

same.

>+		break;
>+	default:
>+		printk(KERN_INFO PFX "unsupported mode: %hu\n", info->mode);
>+		return false;

This one is ok, though.

>+static struct xt_target conntrack_tg_mangle_reg[] __read_mostly = {
>+	{
>+		.name		= "CONNTRACK",
>+		.family		= AF_INET,
>+		.checkentry	= conntrack_tg_check,
>+		.destroy	= conntrack_tg_destroy,
>+		.target		= conntrack_tg,
>+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
>+		.table		= "mangle",
>+};
>+static struct xt_target conntrack_tg_raw_reg[] __read_mostly = {
>+	{
>+		.name		= "CONNTRACK",
>+		.family		= AF_INET,
>+		.checkentry	= conntrack_tg_check,
>+		.destroy	= conntrack_tg_destroy,
>+		.target		= conntrack_tg,
>+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
>+		.table		= "raw",
>+		.me		= THIS_MODULE,
>+	},
>+};

I have tried to reproduce this, and it does not work. The primary key 
tuple seems to be (name, revision, family), but you have two of these 
tuples. My test case was:

        {
                .name   = "STEAL",
                .family = AF_INET,
                .target = steal_tg,
                .me     = THIS_MODULE,
                .table  = "mangle",
        },
        {
                .name   = "STEAL",
                .family = AF_INET,
                .target = steal_tg,
                .me     = THIS_MODULE,
                .table  = "raw",
        },

And the kernel tells me:

[30800.792835] ip_tables: STEAL target: only valid in raw table, not 
mangle.

So much for that.
Drop the .table lines, you are checking the table in connmark_tg_check() 
anyways (like all other modules).

One of conntrack_tg_{mangle,raw}_reg is then redundant.
