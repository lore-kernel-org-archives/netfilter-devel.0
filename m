From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: xlate: print total no. of testfiles, tests and
 tests passed
Date: Thu, 19 Oct 2017 12:33:57 +0200
Message-ID: <20171019103357.GA2716@salvia>
References: <20171018142944.14872-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdJSKeC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 06:34:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47B132492A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:34:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37CC7DA875
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:34:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171018142944.14872-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 18, 2017 at 07:59:44PM +0530, Harsha Sharma wrote:
> Print errors and total no of tests and tests passed for testfile argument.
> Print total no. of testfiles, total no. of tests and total no. of tests
> passed for "all" argument.
> Change testfile argument to take "extensions/test_file" as argument.

Looks good, but general rule is:

        One logical change per patch.

I mean, this patch description says you're doing two things:

1) Print errors and total no of tests and tests passed for testfile
argument.

2) Change testfile argument to take "extensions/test_file" as
argument.

This means you have to send two patches, one for #1, and another one
for #2.

If you do so, git becomes way more useful when doing archeology, since
we know what patch added what single thing.
