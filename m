From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nf-next] netfilter: core: __nf_unregister_net_hook()
 can be static
Date: Thu, 21 Dec 2017 00:18:10 +0100
Message-ID: <20171220231810.owqgq2cs4ataskry@salvia>
References: <201712200120.UwkYYVXx%fengguang.wu@intel.com>
 <20171219172540.GA56682@lkp-sb05>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755811AbdLTXSO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 18:18:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 306C2EBACF
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:18:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2177EF7317
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:18:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171219172540.GA56682@lkp-sb05>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 20, 2017 at 01:25:40AM +0800, kbuild test robot wrote:
> 
> Fixes: ac119d8cd089 ("netfilter: core: support for NFPROTO_INET hook registration")
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

I have folded this patch to my patchset, thanks.
