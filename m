From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] tests: xlate: print total no. of testfiles, tests and
 tests passed
Date: Fri, 20 Oct 2017 14:33:56 +0200
Message-ID: <20171020123356.GA5925@salvia>
References: <20171019124002.11066-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53530 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbdJTMeB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:34:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01E8B6926C
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:34:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA9FFDA874
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:33:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019124002.11066-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 06:10:02PM +0530, Harsha Sharma wrote:
> Print errors and total no of tests and tests passed for testfile argument.
> Print total no. of testfiles, total no. of tests and total no. of tests
> passed for "all" argument.
> For e.g. :
> sudo ./xlate-test.py --all (adds this line in end with whole output)

Why we need --all?

Don't we print a line for each test that we run to report that it is
OK? I mean:

# python nft-test.py
any/fwd.t: OK
any/rt.t: OK
...

What I would like to see is that xlate-test.py behaves just like
nft-tests.py in what it prints.

Let me know, thanks!

> 64 test file, 246 tests, 242 tests passed
> 
> sudo ./xlate-test.py libxt_ipcomp.txlate
> 1 test file, 2 tests, 2 tests passed
