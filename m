From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: xlate: print total no. of testfiles, tests and
 tests passed
Date: Thu, 19 Oct 2017 12:35:03 +0200
Message-ID: <20171019103503.GA2752@salvia>
References: <20171018142944.14872-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752468AbdJSKfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 06:35:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0D0D2492B
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:35:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D21D4DA86F
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:35:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171018142944.14872-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 18, 2017 at 07:59:44PM +0530, Harsha Sharma wrote:
> Print errors and total no of tests and tests passed for testfile argument.
> Print total no. of testfiles, total no. of tests and total no. of tests
> passed for "all" argument.

BTW, could you also to the commit description an example on how the
output looks like, for people that don't want to apply and run it, so
we set clear expectations on what this is doing.

Thanks Harsha!
