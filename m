From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] libnftables: Unexport enum nftables_exit_codes
Date: Mon, 13 Nov 2017 13:31:00 +0100
Message-ID: <20171113123100.GA6899@salvia>
References: <20171109192712.GX32305@orbyte.nwl.cc>
 <20171110112715.23289-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdKMMbF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:31:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2834B392E08
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:31:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19F68615A4
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:31:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171110112715.23289-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 10, 2017 at 12:27:15PM +0100, Phil Sutter wrote:
> diff --git a/src/main.c b/src/main.c
> index 529bedffc2e3b..8d03f8989b1fc 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -183,11 +183,11 @@ int main(int argc, char * const *argv)
>  		switch (val) {
>  		case OPT_HELP:
>  			show_help(argv[0]);
> -			exit(NFT_EXIT_SUCCESS);
> +			exit(0);

Better use the standard EXIT_FAILURE and EXIT_SUCCESS here? Instead of
hardcoded 0 and 1 values.

Thanks!
