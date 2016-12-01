From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] evaluate: Update cache on flush ruleset
Date: Thu, 1 Dec 2016 12:42:02 +0100
Message-ID: <20161201114202.GA3052@salvia>
References: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
 <8cb247352dd4b9eaf587c1ff89f618061042edff.1480587885.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbcLALmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 06:42:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDFD01DF5BF
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:42:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07157DA243
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:42:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6F9CDA87E
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:42:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <8cb247352dd4b9eaf587c1ff89f618061042edff.1480587885.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 01, 2016 at 11:50:17AM +0100, Anatole Denis wrote:
> After a flush, the cache should be empty, otherwise the cache and the expected
> state are desynced, causing unwarranted errors. See
> tests/shell/testcases/cache/0002_interval_0.
> 
> `flush table` and `flush chain` don't empty sets or destroy chains, so the cache
> does not need an update in those cases, since only chain names and set contents
> are held in cache for commands other than "list"

Also applied, thanks.
