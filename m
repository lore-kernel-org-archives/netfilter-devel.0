From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Flush iface cache after command
 execution
Date: Mon, 13 Nov 2017 13:36:29 +0100
Message-ID: <20171113123629.GA7130@salvia>
References: <20171108234747.GD1788@salvia>
 <20171109122457.25190-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35652 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdKMMgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:36:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD793392E0E
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:36:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 834D8B8001
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:36:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171109122457.25190-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 09, 2017 at 01:24:57PM +0100, Phil Sutter wrote:
> Commit 94a945ffa81b7 ("libnftables: Get rid of explicit cache flushes")
> was a bit too optimistic in that it missed the remaining need to flush
> interface cache after each command in interactive mode - otherwise,
> newly added interfaces won't be recognized.
> 
> Although cli.c only calls nft_run_cmd_from_buffer(), flush caches in
> nft_run_cmd_from_filename() as well for matters of consistency.

Applied, thanks Phil.
