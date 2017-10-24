From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH v3] tests: xlate: print output in same
 way as nft-test.py
Date: Tue, 24 Oct 2017 18:12:28 +0200
Message-ID: <20171024161228.GA312@salvia>
References: <20171022124909.597-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdJXQMg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:12:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED684E9783
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:12:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE0DCDA86D
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:12:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171022124909.597-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 22, 2017 at 06:19:09PM +0530, Harsha Sharma wrote:
> Print errors and total no. of tests, tests passed, failed and errors for
> testfile argument
> Remove option "--all"
> Print file names for which all tests are passed with OK
> For e.g -
> sudo ./xlate-test.py
> generic.txlate: OK
> libip6t_DNAT.txlate: OK

Nice!

Applied, thanks a lot Harsha!
