From: "Tangchen (UVP)" <tang.chen@huawei.com>
Subject: A bug in commit: Use flock() for --concurrent option
Date: Fri, 12 Jan 2018 08:12:01 +0000
Message-ID: <22E823DBB7698E489DC113638F747072013BD03C@dggeml511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Zhangyanfei (YF)" <yanfei.zhang@huawei.com>,
        guijianfeng <guijianfeng@huawei.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "phil@nwl.cc" <phil@nwl.cc>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:2082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754280AbeALIMM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 03:12:12 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Phil Sutter

I found a problem with this commit, 

Use flock() for --concurrent option
The previous locking mechanism was not atomic, hence it was possible
that a killed ebtables process would leave the lock file in place which
in turn made future ebtables processes wait indefinitely for the lock to
become free.

Fix this by using flock(). This also simplifies code quite a bit because
there is no need for a custom signal handler or an __exit routine
anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

if /var/lib/ebtables/ does not exist, ebtables cannot create the lock file.

# ls /var/lib/ebtables
ls: cannot access /var/lib/ebtables: No such file or directory
# ebtables --concurrent -L
Unable to create lock file /var/lib/ebtables/lock.

Thanks
