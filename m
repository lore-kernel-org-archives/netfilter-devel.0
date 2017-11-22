From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Ensure output_fp is never NULL
Date: Wed, 22 Nov 2017 13:17:56 +0100
Message-ID: <20171122121756.GA24246@salvia>
References: <20171120124716.GA17684@salvia>
 <20171120155404.10894-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752420AbdKVMSB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 07:18:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDD1A1B8416
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:17:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBDCBDA87A
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:17:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171120155404.10894-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 20, 2017 at 04:54:04PM +0100, Phil Sutter wrote:
> Initialize output_fp to 'stdout' upon context creation and check output
> stream validity in nft_ctx_set_output(). This allows to drop checks in
> nft_{gmp_,}print() and do_command_export(). While doing so for the
> latter, simplify it a bit by using nft_print() which takes care of
> flushing the output stream.
> 
> If applications desire to drop all output, they are supposed to open
> /dev/null and assign that.

Applied, thanks Phil.
