From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Eliminate forgotten traces of libnftables exporting
Date: Fri, 19 Jan 2018 13:10:11 +0100
Message-ID: <20180119121011.iyjjpy7k5grwe6yf@salvia>
References: <20180116161857.GA25722@orbyte.nwl.cc>
 <20180116161957.10634-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39622 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbeASMKQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:10:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C1CA1C4368
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:10:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BDF5DA857
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:10:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180116161957.10634-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 16, 2018 at 05:19:57PM +0100, Phil Sutter wrote:
> This removes libnftables pkg-config file along with the few lines of
> code to adjust and install it.

Applied, thanks Phil.
