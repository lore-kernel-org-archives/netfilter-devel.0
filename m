From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] tests: shell: netns/0003many_0: Fix cleanup
 after error
Date: Wed, 22 Mar 2017 12:51:36 +0100
Message-ID: <20170322115136.GB14374@salvia>
References: <20170321131902.GA30047@salvia>
 <20170322002636.14081-1-phil@nwl.cc>
 <20170322002636.14081-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50698 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932606AbdCVLvv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 07:51:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8789811480F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77DD2DA862
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 351ABDA865
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322002636.14081-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 01:26:35AM +0100, Phil Sutter wrote:
> If rule set applying failed, this would leave a stray netns in place.
> 
> Interestingly, this situation led to other, seemingly unrelated
> testcases to fail with spurious errors, e.g. sets/0015rulesetflush_0:
> 
> | $ ./run-tests.sh testcases/sets/0015rulesetflush_0
> | I: using nft binary ../../src/nft
> |
> | W: [FAILED]	testcases/sets/0015rulesetflush_0: expected 0 but got 1
> | /tmp/tmp.BY7cuUYL8f:5:1-2: Error: Could not process rule: Operation not supported
> | table inet filter {
> | ^^
> | /tmp/tmp.BY7cuUYL8f:9:1-2: Error: Could not process rule: No such file or directory
> | add element inet filter blacklist_v4 {
> | ^^
> | /tmp/tmp.BY7cuUYL8f:5:1-2: Error: Could not process rule: Operation not supported
> | table inet filter {
> | ^^
> | /tmp/tmp.BY7cuUYL8f:9:1-2: Error: Could not process rule: No such file or directory
> | add element inet filter blacklist_v4 {
> | ^^
> |
> | I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
> |
> | $ ip netns list
> | 1_0003many_0
> | $ ip netns del 1_0003many_0
> |
> | $ ./run-tests.sh testcases/sets/0015rulesetflush_0
> | I: using nft binary ../../src/nft
> |
> | I: [OK]		testcases/sets/0015rulesetflush_0
> |
> | I: results: [OK] 1 [FAILED] 0 [TOTAL] 1

Also applied, thanks.
