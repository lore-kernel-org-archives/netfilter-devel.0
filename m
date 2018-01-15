From: Phil Sutter <phil@nwl.cc>
Subject: Re: A bug in commit: Use flock() for --concurrent option
Date: Mon, 15 Jan 2018 16:26:41 +0100
Message-ID: <20180115152641.GN14358@orbyte.nwl.cc>
References: <22E823DBB7698E489DC113638F747072013BD03C@dggeml511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
        "Zhangyanfei (YF)" <yanfei.zhang@huawei.com>,
        guijianfeng <guijianfeng@huawei.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Tangchen (UVP)" <tang.chen@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44198 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934542AbeAOP0q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 10:26:46 -0500
Content-Disposition: inline
In-Reply-To: <22E823DBB7698E489DC113638F747072013BD03C@dggeml511-mbx.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Chen Tang,

On Fri, Jan 12, 2018 at 08:12:01AM +0000, Tangchen (UVP) wrote:
> I found a problem with this commit, 
> 
> Use flock() for --concurrent option
> The previous locking mechanism was not atomic, hence it was possible
> that a killed ebtables process would leave the lock file in place which
> in turn made future ebtables processes wait indefinitely for the lock to
> become free.
> 
> Fix this by using flock(). This also simplifies code quite a bit because
> there is no need for a custom signal handler or an __exit routine
> anymore.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> if /var/lib/ebtables/ does not exist, ebtables cannot create the lock file.
> 
> # ls /var/lib/ebtables
> ls: cannot access /var/lib/ebtables: No such file or directory
> # ebtables --concurrent -L
> Unable to create lock file /var/lib/ebtables/lock.

Thanks for reporting this! I missed that the old code calls mkdir() in
one of the error paths. Will send a follow-up patch in a moment.

Cheers, Phil
