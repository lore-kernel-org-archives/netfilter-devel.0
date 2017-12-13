From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH] netfilter: meta: nft_meta_get_validate() can be
 static
Date: Wed, 13 Dec 2017 17:42:22 +0100
Message-ID: <20171213164222.GA5618@salvia>
References: <20171201124021.20973-2-fw@strlen.de>
 <20171213071622.GA138460@ivb43.lkp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
        netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753648AbdLMQm3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 11:42:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB3AF16B283
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 17:42:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9B9F20072
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 17:42:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171213071622.GA138460@ivb43.lkp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 13, 2017 at 03:16:22PM +0800, kbuild test robot wrote:
> 
> Fixes: dce1fc524886 ("netfilter: meta: secpath support")
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Florian sent a v2 that fixes this, I'll take that one.

Anyway, thanks for testing netfilter patches kbuild robot.
