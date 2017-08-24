From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH V2] tests: json: Add test cases for json format
Date: Thu, 24 Aug 2017 17:38:57 +0530
Message-ID: <CAOfkYf5CDMihfi9tkUQcOv5eFMDFi2nfr012QwTy-DJ4fy65Zw@mail.gmail.com>
References: <1503564545-28426-1-git-send-email-mayhs11saini@gmail.com> <CAOkSjBhaLkRbVFo9TENJ=tKWfOw3Hvcmx+Brp9vU0AoryZiwGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35153 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdHXMI7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 08:08:59 -0400
Received: by mail-oi0-f44.google.com with SMTP id x124so3309240oia.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 05:08:59 -0700 (PDT)
In-Reply-To: <CAOkSjBhaLkRbVFo9TENJ=tKWfOw3Hvcmx+Brp9vU0AoryZiwGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
> > These test cases can be used to test upcoming "import json" command.
> >
> > Here is the short description of the files:
> > all_ruleset_list   ->    contains list of all the individual rules
>
> Wait. You are generating the JSON files from this ruleset, right?
>
yes.

>
> Then, why not simplify the tests by:
>
>  * load a ruleset model (your all_ruleset_list file)
>  * export it in JSON format (nft export json)
>  * import it again in JSON format (nft import)
>  * comparte resulting ruleset (nft list ruleset) with the original
> file (all_ruleset_list file)
>
> This way we test in the same run all the JSON code paths.
>
> You will need a simple testcase, like this:
>
> === 8< ===
> #!/bin/bash
> set -e
> TMP=$(mktmp)
> RULESET="table ip { ... } "
> echo $RULESET > $TMP
> $NFT -f $TMP
> $NFT export json > $TMP
> cat $TMP | $NFT import json)
> RESULT=$($NFT list ruleset)
> # compare result and initial ruleset, if fail show diff
> === 8< ===
>
> That was quick and dirty code for you to get the idea.
> Please follow the example of other testcases [0] to compare ruleset,
> create tempfiles and so on.
>

One issue with this approach, incase of set rules
nft will throw this error
"Error: Could not process rule: File exists"
So, i need to flush ruleset before import them with json.
Is it okay?

>
> Please, if possible, try to add a testcase that is [OK]. Not sure what
> is wrong with the dup statement.
>
I tried, but they always throw the same error.
Shouldn't we keep them in testsuite so that we know that these set of
rules needs to be fixed.

>
> [0] http://git.netfilter.org/nftables/tree/tests/shell/testcases/netns/0001nft-f_0

Thanks,
Shyam
