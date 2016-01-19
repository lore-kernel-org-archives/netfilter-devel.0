From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft compat layer
Date: Tue, 19 Jan 2016 20:04:56 +0100
Message-ID: <20160119190456.GA24910@salvia>
References: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
 <569CA968.9010702@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40765 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbcASTFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 14:05:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DAB542791A7
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 20:04:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C82F1DA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 20:04:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F3DAFDA811
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 20:04:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <569CA968.9010702@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Andreas,

On Mon, Jan 18, 2016 at 09:59:20AM +0100, Andreas Schultz wrote:
> Hi Arturo,
> 
> On 01/15/2016 09:06 PM, Arturo Borrero Gonzalez wrote:
> >Hi,
> >
> >I'm giving a spin to the nft compat layer, since it can be of certain
> >importance for distributions.
> >
> >I just want to be clear on what I recommends to end users about
> >migrating from iptables (and friends) to nftables.
> >
> >Could you please remind me in which state was the discussion about
> >that patch to show x_tables extensions in nftables rulesets [0]?
> >I remember Patrick mentioned several concerns back then about this approach.
> 
> I have an updated version of this patch and also fixed some of
> the problems I encountered along the way (see attached patches).
> The nft patch is based on nftables-0.5 and the kernel change
> should apply cleanly to linux-4.4.

Thanks for posting your patches.

> With the update patch I can load a fairly complex iptables
> firewall with iptables-compat, dump it with nft and reload
> the dump with nft.

BTW, looking at the kernel patches, my first question is why you
disable the chain/table validation code? Do you remember what problem
you found in it?

> diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
> index 87907d4..2f8f76c 100644
> --- a/net/ipv4/netfilter/ipt_REJECT.c
> +++ b/net/ipv4/netfilter/ipt_REJECT.c
> @@ -76,6 +76,8 @@ static int reject_tg_check(const struct xt_tgchk_param *par)
>  	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
>  		pr_info("ECHOREPLY no longer supported.\n");
>  		return -EINVAL;
> +	} else if (par->nft_compat) {
> +		return 0;

The ipt_entry is emulated from the compat layer, do you remember what
command needs this?

Same thing in SYNPROXY and the one for the x_tables code.

If you can provide a way to reproduce the problem, I would like to
resolve the issues in master, if any.

Thanks.
