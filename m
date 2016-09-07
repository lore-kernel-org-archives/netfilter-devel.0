From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 libnftnl] expr: numgen: Rename until attribute by
 modulus
Date: Wed, 7 Sep 2016 11:04:55 +0200
Message-ID: <20160907090455.GA9667@salvia>
References: <20160902130704.GA5550@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbcIGJFE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 05:05:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F20D12A689
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:05:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED250FB45F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:05:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D48A51150D7
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:05:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902130704.GA5550@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:07:06PM +0200, Laura Garcia Liebana wrote:
> The _modulus_ attribute will be reused as _until_, as it's similar to
> other expressions with value limits (ex. hash).
> 
> Renaming is possible according to the kernel module ntf_numgen that has
> not been released yet.

This doesn't apply cleanly to libnftnl.

Please, git pull --rebase there, resolve conflicts and resubmit.
Thanks.
