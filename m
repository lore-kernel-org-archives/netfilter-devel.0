From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] tests: shell: Add test for ambguity while setting the
 value
Date: Thu, 15 Jun 2017 11:51:56 +0200
Message-ID: <20170615095156.GA8936@salvia>
References: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750923AbdFOJwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 05:52:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB118E1226
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:51:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE386DA90B
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:51:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C03F6DA90B
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:51:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 09, 2017 at 09:31:00PM +0530, Shyam Saini wrote:
> This test checks bug identified and fixed in the commit mentioned below
> In a statement if there are  multiple src data then it  would be
> totally ambiguous to decide which value to set.
> 
> We don't add this test in python testsuite, because there we only have
> "ok"  and "fail"  as return code. So, we can't detect 134 != 1 there.
> (both 1 and 134 stats failure)

OK I see, so 134 and 1 refers to the exit code we return to the shell
(or whoever runs nft).

Could you have a look at tests/py/nft-test.py

If the problem is just the exit code, then I suggest you add these
tests to the python infrastructure, then make sure that the python
script checks for 1 for 'fail'.

Could you have a look, please?
