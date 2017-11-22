From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests: shell: Prevent lockout in
 nft-f/0008split_tables_0
Date: Wed, 22 Nov 2017 13:17:40 +0100
Message-ID: <20171122121740.GA20391@salvia>
References: <20171121170946.GB24866@breakpoint.cc>
 <20171121221339.32090-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdKVMRr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 07:17:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 964C61B8410
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:17:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82DDDDA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:17:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171121221339.32090-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 21, 2017 at 11:13:39PM +0100, Phil Sutter wrote:
> Since packets traverse both tables, the accept rule in the first one is
> ineffective due to the second table's drop policy. To prevent lockouts
> when running the testsuite via SSH connection, set the second chain's
> policy to accept as well.

Applied.
