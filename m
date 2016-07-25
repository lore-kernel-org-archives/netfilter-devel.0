From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] xtables-translate: fix issue with quotes
Date: Mon, 25 Jul 2016 17:31:34 +0200
Message-ID: <20160725153134.GA11209@salvia>
References: <20160722154834.1802-1-pablombg@gmail.com>
 <20160722154834.1802-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbcGYPbn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jul 2016 11:31:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0F1541BFA91
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2016 17:31:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F3627FAB5F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2016 17:31:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95E4C6448C
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2016 17:31:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160722154834.1802-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 05:48:34PM +0200, Pablo M. Bermudo Garay wrote:
> Some translations included escaped quotes when they were called from
> nft:
> 
> $ sudo nft list ruleset
> table ip mangle {
>     chain FORWARD {
>         type filter hook forward priority -150; policy accept;
>         ct helper \"ftp\" counter packets 0 bytes 0
>                   ^^   ^^
>     }
> }
> 
> This behavior is only correct when xlate functions are called from a
> xtables-translate command. This patch solves that issue if nft revision
> is using the field added to the xt_xlate struct with "xtables-translate:
> add new field to identify the caller" commit.

Please, rebase this change on top of:

http://git.netfilter.org/iptables/commit/?id=7a0992da44cfb6cab0ccd1beadcf326df8773552

I'd suggest you add a new parameter for this, something like:

        bool escape_quotes;

Or is there use for this nft_compat field you propose out of this.

Thanks.
