From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCHv2] fib: Add support for NFTA_FIB_F_PRESENT flag
Date: Mon, 13 Mar 2017 12:15:02 +0100
Message-ID: <20170313111502.GA5024@salvia>
References: <20170311132716.7762-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdCMLPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 07:15:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89F5A12A692
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78599DA725
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A281DA855
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170311132716.7762-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 11, 2017 at 02:27:16PM +0100, Phil Sutter wrote:
> Reflect existence of flag in debug output so testsuite can check for it.

Applied, thanks Phil.
