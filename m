From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] tests: xlate: print tests passed and error for
 testfile argument
Date: Tue, 17 Oct 2017 13:27:57 +0200
Message-ID: <20171017112757.GA8578@salvia>
References: <20171017092458.18672-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755232AbdJQL2C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:28:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2654220B4
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:28:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC471DA87C
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:28:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171017092458.18672-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 02:54:58PM +0530, Harsha Sharma wrote:
> Print tests passed with errors and warnings when run with only specified
> test file.

I would expect this works like this, for consistency with other test
infrastructure we have:

# python xlate-test.py extensions/libxt_ecn.txlate 
Error: test file does not exist

I can see here this works like this:

# python xlate-test.py libxt_ecn.txlate 

But as said, it is counterintuitive. Would you revisit this patch?

Thanks.
