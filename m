From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: libxt_comment: Add translation to nft
Date: Tue, 22 Dec 2015 18:04:01 +0100
Message-ID: <20151222170401.GA20918@salvia>
References: <cover.1450779140.git.shivanib134@gmail.com>
 <bfd658a271224fa7f3cbab52868300f3fbb1caa8.1450779140.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36560 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbbLVREF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 12:04:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D38F023CF69
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:04:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C57DBDA808
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:04:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D9305DA801
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:04:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <bfd658a271224fa7f3cbab52868300f3fbb1caa8.1450779140.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 03:48:34PM +0530, Shivani Bhardwaj wrote:
> Add translation for comment module to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m comment --comment "random comment"
> nft add rule ip filter INPUT counter comment \"random comment\"
> 
> $ sudo iptables-translate -A INPUT -i eth1 -m comment --comment "Local LAN"
> nft add rule ip filter INPUT iifname eth1 counter comment \"Local LAN\"
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_comment.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
> index 6ed2ff9..bbbd6cb 100644
> --- a/extensions/libxt_comment.c
> +++ b/extensions/libxt_comment.c
> @@ -48,6 +48,18 @@ comment_save(const void *ip, const struct xt_entry_match *match)
>  	xtables_save_string(commentinfo->comment);
>  }
>  
> +static int
> +comment_xlate(const struct xt_entry_match *match,
> +	      struct xt_buf *buf, int numeric)
> +{
> +	struct xt_comment_info *commentinfo = (void *)match->data;
> +
> +	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
> +	xt_buf_add(buf, "counter comment \\\"%s\\\" ", commentinfo->comment);
                         ^^^^^^^

We have to find a better way to fix this from the core infrastructure.
