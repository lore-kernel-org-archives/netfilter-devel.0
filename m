From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] libnftables: Make output_fp default to /dev/null
Date: Mon, 20 Nov 2017 13:32:04 +0100
Message-ID: <20171120123204.GA17403@salvia>
References: <20171116143224.GA17329@salvia>
 <20171116191415.19404-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57306 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbdKTMcJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:32:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0AEF154D5F7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:32:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC931B7FE4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:32:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171116191415.19404-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Thu, Nov 16, 2017 at 08:14:15PM +0100, Phil Sutter wrote:
> Ensure output_fp is never NULL which allows to drop all respective
> checks.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Hi Pablo,
> 
> This is how I understood your suggestion to use /dev/null. While
> implementing it though, I had an idea for a much simpler solution,
> namely just rejecting NULL in nft_set_output() and therefore forcing the
> application to deal with opening /dev/null if no output is desired. What
> do you think about that?

I like your idea of rejecting NULL.
