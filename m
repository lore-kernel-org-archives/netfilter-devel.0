From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables PATCH] Fix locking if LOCKDIR does not exist
Date: Wed, 17 Jan 2018 03:33:41 +0100
Message-ID: <20180117023341.2h5ustcswu5fedi7@salvia>
References: <20180115152731.29337-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tangchen <tang.chen@huawei.com>, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbeAQCdr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 21:33:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8EB0DA385
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 03:33:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBC3EDA84C
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 03:33:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180115152731.29337-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 15, 2018 at 04:27:31PM +0100, Phil Sutter wrote:
> The previous conversion to using flock() missed a crucial bit of code
> which tries to create LOCKDIR once in case opening the lock failed -
> This patch reestablishes the old behaviour.

Applied, thanks Phil.
