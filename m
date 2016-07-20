From: jalvarez <jalvarez@toulouse.viveris.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: allow to filter out rules
 by table and chain
Date: Wed, 20 Jul 2016 12:04:18 +0200
Message-ID: <578F4CA2.40600@toulouse.viveris.com>
References: <1468923645-11722-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:33435 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbcGTKKO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 06:10:14 -0400
In-Reply-To: <1468923645-11722-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19/07/2016 12:20, Pablo Neira Ayuso wrote:
> If the table and/or chain attributes are set in a rule dump request,
> we filter out the rules based on this selection.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Compiled tested only.
>
>   net/netfilter/nf_tables_api.c | 39 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0211eae..675ba82 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1857,10 +1857,16 @@ err:
>   	return err;
>   }
>   
> +struct nft_rule_dump_ctx {
> +	char table[NFT_TABLE_MAXNAMELEN];
> +	char chain[NFT_CHAIN_MAXNAMELEN];
> +};
> +
>   static int nf_tables_dump_rules(struct sk_buff *skb,
>   				struct netlink_callback *cb)
>   {
>   	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
> +	const struct nft_rule_dump_ctx *ctx = cb->data;
>   	const struct nft_af_info *afi;
>   	const struct nft_table *table;
>   	const struct nft_chain *chain;
> @@ -1877,7 +1883,15 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>   			continue;
>   
>   		list_for_each_entry_rcu(table, &afi->tables, list) {
> +			if (ctx->table[0] &&
> +			    strcmp(ctx->table, table->name) != 0)
> +				continue;
> +
>   			list_for_each_entry_rcu(chain, &table->chains, list) {
> +				if (ctx->chain[0] &&
> +				    strcmp(ctx->chain, chain->name) != 0)
> +					continue;
> +
>   				list_for_each_entry_rcu(rule, &chain->rules, list) {
>   					if (!nft_is_active(net, rule))
>   						goto cont;
> @@ -1907,6 +1921,12 @@ done:
>   	return skb->len;
>   }
>   
> +static int nf_tables_dump_rules_done(struct netlink_callback *cb)
> +{
> +	kfree(cb->data);
> +	return 0;
> +}
> +
>   static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>   			     struct sk_buff *skb, const struct nlmsghdr *nlh,
>   			     const struct nlattr * const nla[])
> @@ -1924,7 +1944,26 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>   	if (nlh->nlmsg_flags & NLM_F_DUMP) {
>   		struct netlink_dump_control c = {
>   			.dump = nf_tables_dump_rules,
> +			.done = nf_tables_dump_rules_done,
>   		};
> +
> +		if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
> +			struct nft_rule_dump_ctx *ctx;
> +
> +			ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +			if (!ctx)
> +				return -ENOMEM;
> +
> +			if (nla[NFTA_RULE_TABLE])
> +				nla_strlcpy(ctx->table, nla[NFTA_RULE_TABLE],
> +					    sizeof(ctx->table));
> +			if (nla[NFTA_RULE_CHAIN])
> +				nla_strlcpy(ctx->chain, nla[NFTA_RULE_CHAIN],
> +					    sizeof(ctx->chain));
> +
> +			c.data = ctx;
> +		}
> +
>   		return netlink_dump_start(nlsk, skb, nlh, &c);
>   	}
>   
Hi,

I did this in the following order :
nft add table ip test_table
nft add chain test_table test_chain
nft list tables

It resulted in a NULL pointer dereference in the kernel.
I tried again with a small ruleset after rebooting, same error.

I'd guess this occurs because the c.data is not affected when there is 
no specified table or chain, yet it is always dereferenced in 
nf_tables_dump_rules.
I will try some changes and test them shortly.

Here are some relevant entries from the kernel log :
   2 Jul 20 11:11:41 dev-VirtualBox kernel: [ 2091.294276] nf_tables: 
(c) 2007-2009 Patrick McHardy <kaber@trash.net>
   3 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414697] BUG: unable 
to handle kernel NULL pointer dereference at (null    )
   4 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414701] IP: 
[<ffffffffc020e2cf>] nf_tables_dump_rules+0xdf/0x270 [nf_tables]
   5 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414708] PGD 38460067 
PUD 3c9ea067 PMD 0
   6 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414711] Oops: 0000 
[#1] SMP
   7 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414713] Modules 
linked in: nf_tables_ipv4 nf_tables nfnetlink nls_utf8 isofs joy dev 
intel_powerclamp snd_intel8x0 crct10dif_pclmul snd_ac97_codec 
crc32_pclmul ac97_bus ghash_clmulni_intel aesni_intel snd_pc    m 
aes_x86_64 snd_seq_midi snd_seq_midi_event lrw snd_rawmidi snd_seq 
snd_seq_device gf128mul input_leds glue_helper serio_raw snd_timer 
ablk_helper cryptd snd soundcore i2c_piix4 mac_hid parport_pc ppdev lp 
parport autofs4 hid_generic usbhid hid psmous e ahci libahci fjes video 
pcnet32 mii pata_acpi
  25 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414756] Call Trace:
  26 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414771] 
[<ffffffff81726ef1>] ? __kmalloc_reserve.isra.33+0x31/0x90
  27 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414773] 
[<ffffffff81727a8b>] ? __alloc_skb+0x5b/0x1e0
  28 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414775] 
[<ffffffff81771f52>] netlink_dump+0x122/0x290
  29 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414776] 
[<ffffffff81772e6f>] __netlink_dump_start+0x15f/0x190
  30 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414779] 
[<ffffffffc020e05f>] nf_tables_getrule+0xdf/0x270 [nf_tables]
  31 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414783] 
[<ffffffff8119c84c>] ? free_one_page+0x18c/0x380
  32 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414785] 
[<ffffffffc020e1f0>] ? nf_tables_getrule+0x270/0x270 [nf_tables]
  33 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414788] 
[<ffffffffc020a130>] ? nf_tables_abort+0x390/0x390 [nf_tables]
  34 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414790] 
[<ffffffffc00eb230>] ? nfnetlink_net_exit_batch+0x70/0x70 [nfnetlink]
  35 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414792] 
[<ffffffffc00eb44a>] nfnetlink_rcv_msg+0x21a/0x230 [nfnetlink]
  36 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414793] 
[<ffffffff81728bee>] ? skb_release_data+0xce/0x100
  37 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414795] 
[<ffffffffc00eb230>] ? nfnetlink_net_exit_batch+0x70/0x70 [nfnetlink]
  38 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414797] 
[<ffffffff81774cd4>] netlink_rcv_skb+0xa4/0xc0
  39 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414798] 
[<ffffffffc00eb855>] nfnetlink_rcv+0x295/0x553 [nfnetlink]
  40 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414800] 
[<ffffffff81772cac>] ? netlink_lookup+0xdc/0x140
  41 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414801] 
[<ffffffff817746b3>] netlink_unicast+0x183/0x230
  42 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414802] 
[<ffffffff81774a5b>] netlink_sendmsg+0x2fb/0x3a0
  43 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414804] 
[<ffffffff8171f7d8>] sock_sendmsg+0x38/0x50
  44 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414806] 
[<ffffffff8171fdc1>] SYSC_sendto+0x101/0x190
  45 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414808] 
[<ffffffff81720e91>] ? __sys_recvmsg+0x51/0x90
  46 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414809] 
[<ffffffff817208ee>] SyS_sendto+0xe/0x10
  47 Jul 20 11:12:02 dev-VirtualBox kernel: [ 2112.414812] 
[<ffffffff8184e176>] entry_SYSCALL_64_fastpath+0x1e/0xa8

