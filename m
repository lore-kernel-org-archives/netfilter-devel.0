From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH V2] tests: json: Add test cases for json format
Date: Thu, 24 Aug 2017 11:56:26 +0200
Message-ID: <CAOkSjBhaLkRbVFo9TENJ=tKWfOw3Hvcmx+Brp9vU0AoryZiwGA@mail.gmail.com>
References: <1503564545-28426-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36358 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdHXJ4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 05:56:48 -0400
Received: by mail-wm0-f53.google.com with SMTP id x128so1127101wmg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 02:56:47 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com. [74.125.82.46])
        by smtp.gmail.com with ESMTPSA id g2sm2128381edk.16.2017.08.24.02.56.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Aug 2017 02:56:46 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id i17so5666696wmb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 02:56:46 -0700 (PDT)
In-Reply-To: <1503564545-28426-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24 August 2017 at 10:49, Shyam Saini <mayhs11saini@gmail.com> wrote:
> These test cases can be used to test upcoming "import json" command.
>
> Here is the short description of the files:
> all_ruleset_list   ->    contains list of all the individual rules

Wait. You are generating the JSON files from this ruleset, right?

Then, why not simplify the tests by:

 * load a ruleset model (your all_ruleset_list file)
 * export it in JSON format (nft export json)
 * import it again in JSON format (nft import)
 * comparte resulting ruleset (nft list ruleset) with the original
file (all_ruleset_list file)

This way we test in the same run all the JSON code paths.

You will need a simple testcase, like this:

=== 8< ===
#!/bin/bash
set -e
TMP=$(mktmp)
RULESET="table ip { ... } "
echo $RULESET > $TMP
$NFT -f $TMP
$NFT export json > $TMP
cat $TMP | $NFT import json)
RESULT=$($NFT list ruleset)
# compare result and initial ruleset, if fail show diff
=== 8< ===

That was quick and dirty code for you to get the idea.
Please follow the example of other testcases [0] to compare ruleset,
create tempfiles and so on.

Please, if possible, try to add a testcase that is [OK]. Not sure what
is wrong with the dup statement.

thanks Shyam!

[0] http://git.netfilter.org/nftables/tree/tests/shell/testcases/netns/0001nft-f_0
