From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] comment: Add translation to nft
Date: Tue, 16 Feb 2016 12:18:56 +0100
Message-ID: <20160216111856.GA1904@salvia>
References: <20160215201027.GA13257@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48369 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbcBPLTC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 06:19:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF6E16C0F
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 988F6330DA
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A92C6330CD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:18:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160215201027.GA13257@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 16, 2016 at 01:40:28AM +0530, Shivani Bhardwaj wrote:
> Add translation for match comment to nftables.
> 
> Example:
> 
> $ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
> nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_comment.c | 14 ++++++++++++++
>  iptables/nft-ipv4.c        | 17 +++++++++++++++--
>  iptables/nft-ipv6.c        | 17 +++++++++++++++--
>  3 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
> index 6ed2ff9..0461924 100644
> --- a/extensions/libxt_comment.c
> +++ b/extensions/libxt_comment.c
> @@ -48,6 +48,19 @@ comment_save(const void *ip, const struct xt_entry_match *match)
>  	xtables_save_string(commentinfo->comment);
>  }
>  
> +static int
> +comment_xlate(const struct xt_entry_match *match,
> +	      struct xt_xlate *xl, int numeric)
> +{
> +	struct xt_comment_info *commentinfo = (void *)match->data;
> +
> +	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
> +	xt_xlate_add_comment(xl, commentinfo->comment);
> +	xt_xlate_add(xl, "comment \\\"%s\\\" ", commentinfo->comment);

You don't need this line above.

The idea after xt_xlate_add_comment() is that, from the core, you
print the comment in the right position.

See below.

> +
> +	return 1;
> +}
> +
>  static struct xtables_match comment_match = {
>  	.family		= NFPROTO_UNSPEC,
>  	.name		= "comment",
> @@ -59,6 +72,7 @@ static struct xtables_match comment_match = {
>  	.save 		= comment_save,
>  	.x6_parse	= xtables_option_parse,
>  	.x6_options	= comment_opts,
> +	.xlate		= comment_xlate,
>  };
>  
>  void _init(void)
> diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
> index 5e2857d..f816a8a 100644
> --- a/iptables/nft-ipv4.c
> +++ b/iptables/nft-ipv4.c
> @@ -433,6 +433,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
>  {
>  	const struct iptables_command_state *cs = data;
>  	int ret;
> +	bool comm = false;
>  
>  	if (cs->fw.ip.iniface[0] != '\0') {
>  		xt_xlate_add(xl, "iifname %s%s ",
> @@ -477,12 +478,24 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
>  			   inet_ntoa(cs->fw.ip.dst));
>  	}
>  
> +	/*
> +	 * Add counter for match comment as prefix
> +	 */
> +	if (strcmp(cs->matches->match->name, "comment") == 0) {
> +		comm = true;
> +		xt_xlate_add(xl, "counter ");
> +	}

After my update you don't need to check if the match is comment
anymore, instead you can check if xl->comment is set, if so you print
the counter in first place to make sure it comes before the comment.

Please, send a v2. Thanks.
