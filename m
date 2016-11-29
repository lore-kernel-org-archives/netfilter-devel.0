From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/7] tests/py/{arp,any}: Unmask negative set lookup
Date: Tue, 29 Nov 2016 22:18:53 +0100
Message-ID: <20161129211853.GB6362@salvia>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
 <ee64d5dc81660dfdffaec2f6d54d648e670f2996.1479994191.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755270AbcK2VS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:18:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8812174D1E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBB21DA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB2E2DA385
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:18:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <ee64d5dc81660dfdffaec2f6d54d648e670f2996.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 24, 2016 at 03:16:21PM +0100, Anatole Denis wrote:
> Many testcases were masked because of bug #888. This series of patches unmasks
> them
>
> Signed-off-by: Anatole Denis <anatole@rezel.net>
> ---
> Patches 2 through 7 update the tests, and are split because of the character
> limit on netfilter-devel. They could be squashed together.

Applied and squashed. Thanks!
