From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] tests: xlate: print total no. of testfiles, tests and
 tests passed
Date: Fri, 20 Oct 2017 14:36:43 +0200
Message-ID: <20171020123643.GA6675@salvia>
References: <20171019124002.11066-1-harshasharmaiitr@gmail.com>
 <20171020123356.GA5925@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdJTMgs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:36:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E93266926E
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:36:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D77B9DA848
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:36:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171020123356.GA5925@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 02:33:56PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 19, 2017 at 06:10:02PM +0530, Harsha Sharma wrote:
> > Print errors and total no of tests and tests passed for testfile argument.
> > Print total no. of testfiles, total no. of tests and total no. of tests
> > passed for "all" argument.
> > For e.g. :
> > sudo ./xlate-test.py --all (adds this line in end with whole output)
> 
> Why we need --all?

Oh, I forgot. This is like this, right?

http://patchwork.ozlabs.org/patch/825100/

Hm, but --all here should probably be --test-file-path or such.

I may be missing anything, but I think we don't need a --all for
xlate-test.py.

Thanks!
