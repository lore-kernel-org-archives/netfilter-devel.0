From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 00/16] tests: files: Remove test files.
Date: Mon, 6 Nov 2017 16:04:34 +0100
Message-ID: <20171106150434.GA20966@salvia>
References: <cover.1509305217.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753283AbdKFPEr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:04:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C08D1B8401
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:04:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C61CDA381
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:04:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1509305217.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Varsha,

On Mon, Oct 30, 2017 at 02:09:24AM +0530, Varsha Rao wrote:
> This patch removes tests from tests/files and add tests to 
> tests/shell which are not present in it.
> 
> Varsha Rao (16):
>   tests: files: Remove tests for ipv4
>   tests: files: Remove tests for ipv6
>   tests: shell: Add test for log statement.

I think we have a test for this under tests/py.

>   tests: files: Remove log statement tests.
>   tests: shell: Add test for log flags.
>   tests: shell: Add tests for payload expression.

Same thing for these to..

>   tests: files: Remove payload expression tests.
>   tests: files: Remove test for syntactical errors.
>   tests: shell: Add test for ct expression.

Same thing.

>   tests: files: Remove test for ct expression.
>   tests: files: Remove prefix file.
>   tests: files: Test for meta expressions.

Same thing.

>   tests: files: Remove test for meta expression.
>   tests: shell: Add tests for concat expression.

Same thing... so it looks like you can send a patch to remove them all
in one go.

Thanks a lot for reviewing what we had under tests/files/

>   tests: files: Remove tests for concat expression.
>   tests: shell: Add test case for map expression.

BTW, I have applied 16/16.
