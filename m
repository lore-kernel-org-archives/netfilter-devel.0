From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/7] cli: Use nft_run_cmd_from_buffer()
Date: Fri, 20 Oct 2017 14:15:34 +0200
Message-ID: <20171020121534.GD4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752889AbdJTMPj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:15:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6EFD69276
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:15:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C763ADA874
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:15:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:44AM +0200, Phil Sutter wrote:
> This simplifies CLI code and allows to reduce libnftables API by not
> exporting nft_run().
> 
> Since nft_run_cmd_from_buffer() takes care of scanner initialization and
> libmnl socket passed to cli_init() is present as nft_ctx field as well,
> signature of cli_init() can be reduced to just take nft_ctx pointer as
> single argument.

libmnl socket is indeed in nft_ctx, but we're planning a mode that
allows to expose the mnl_socket for advanced handling. In that
scenario, nft->nf_sock will be null.

So I would prefer we don't do changes that we have to undo once the
advanced API is in place.
