From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3 1/2] datatype: Replace getnameinfo() by internal
 lookup table
Date: Tue, 29 Nov 2016 20:19:11 +0100
Message-ID: <20161129191911.GA2305@salvia>
References: <20161128202009.GA8734@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752106AbcK2TT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 14:19:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 940F7174D1A
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:19:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8619BDA38F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:19:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C9ECDA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:19:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128202009.GA8734@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 06:20:10PM -0200, Elise Lennion wrote:
[...]
> diff --git a/src/services.c b/src/services.c
> new file mode 100644
> index 0000000..8cb1cdf
> --- /dev/null
> +++ b/src/services.c
> @@ -0,0 +1,343 @@
> +#include <nftables.h>
> +#include <datatype.h>
> +
> +const struct symbol_table serv_tbl = {
> +	.symbols =	{
> +		SYMBOL("exec",	2),

Please, use __constant_htons() so these ports become understandable.

Let's keep it simple, so we forget on binary search by now.

Very much looking forward to having this in the nft tree.

Thanks!
