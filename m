From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] libnftables: Unexport enum nftables_exit_codes
Date: Thu, 16 Nov 2017 14:33:32 +0100
Message-ID: <20171116133332.GB2455@salvia>
References: <20171113123837.GZ32305@orbyte.nwl.cc>
 <20171113140816.17830-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbdKPNdg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:33:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37A732E7852
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:33:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28CF0DA848
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:33:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113140816.17830-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 03:08:16PM +0100, Phil Sutter wrote:
> Apart from SUCCESS/FAILURE, these codes were not used by library
> functions simply because NOMEM and NONL conditions lead to calling
> exit() instead of propagating the error condition back up the call
> stack.
> 
> Instead, make nft_run_cmd_from_*() return either 0 or -1 on error.
> Usually errno will then contain more details about what happened and/or
> there are messages in erec.
> 
> Calls to exit()/return in main() are adjusted to stay compatible.

Also applied, thanks.

BTW, I think you mentioned you planned to change all
memory_allocation_error() to pass up the error to the client
application.

Let me know, if you don't have time for this, no worries if too busy.

Thanks!
