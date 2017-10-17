From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_tcpmss: Detect invalid ranges
Date: Tue, 17 Oct 2017 14:12:24 +0200
Message-ID: <20171017121224.GA18819@salvia>
References: <20171009134739.19046-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761358AbdJQMMc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:12:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43BAC4D656
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:12:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 345FADA861
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:12:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171009134739.19046-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 09, 2017 at 03:47:39PM +0200, Phil Sutter wrote:
> Previously, an MSS range of e.g. 65535:1000 was silently accepted but
> would then never match a packet since the kernel checks whether the MSS
> value is greater than or equal to the first *and* less than or equal to
> the second value.
> 
> Detect this as a parameter problem and update the man page accordingly.

Applied, thanks Phil.
