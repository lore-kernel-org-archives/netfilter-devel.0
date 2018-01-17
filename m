From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft V5 2/2] tests: shell: Add tests for low level json
 import
Date: Wed, 17 Jan 2018 18:39:28 +0100
Message-ID: <20180117173928.w6pkmeeh6fqexe3r@salvia>
References: <1512482855-29426-1-git-send-email-mayhs11saini@gmail.com>
 <1512482855-29426-2-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753835AbeAQRjd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 12:39:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CEF5744382B
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 18:39:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0BF8DA843
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 18:39:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1512482855-29426-2-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 05, 2017 at 07:37:35PM +0530, Shyam Saini wrote:
> Test upcoming "import json" statement.
> 
> Basically it loads same set of rules by "nft -f" and "nft import vm json"
> and prints differences(if any) in the ruleset listed by "nft list
> ruleset" in each case.
> 
>         For Example:
>         $ ./run-tests.sh testcases/import/vm_json_import_0

Also applied, thanks.
