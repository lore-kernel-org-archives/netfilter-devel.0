From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables PATCH] Use flock() for --concurrent option
Date: Tue, 24 Oct 2017 17:57:09 +0200
Message-ID: <20171024155709.GA11873@salvia>
References: <20171006104850.20933-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbdJXP5N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:57:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C2CBE9762
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:57:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BF85DA877
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:57:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171006104850.20933-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 06, 2017 at 12:48:50PM +0200, Phil Sutter wrote:
> The previous locking mechanism was not atomic, hence it was possible
> that a killed ebtables process would leave the lock file in place which
> in turn made future ebtables processes wait indefinitely for the lock to
> become free.
> 
> Fix this by using flock(). This also simplifies code quite a bit because
> there is no need for a custom signal handler or an __exit routine
> anymore.

Applied, thanks Phil.
