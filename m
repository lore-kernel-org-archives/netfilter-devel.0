From: maowenan <maowenan@huawei.com>
Subject: libmnl compile failure.
Date: Fri, 16 Dec 2016 08:54:59 +0800
Message-ID: <1758bff0-40b1-a404-e225-eff504c6a1d7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:3368 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbcLPA6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2016 19:58:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

There is something wrong when I make libmnl, could you please help check?

localhost:~/maowenan/libmnl # pwd
/root/maowenan/libmnl
localhost:~/maowenan/libmnl #
localhost:~/maowenan/libmnl # make
make  all-recursive
make[1]: Entering directory `/root/maowenan/libmnl'
Making all in src
make[2]: Entering directory `/root/maowenan/libmnl/src'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/root/maowenan/libmnl/src'
Making all in include
make[2]: Entering directory `/root/maowenan/libmnl/include'
Making all in libmnl
make[3]: Entering directory `/root/maowenan/libmnl/include/libmnl'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/root/maowenan/libmnl/include/libmnl'
Making all in linux
make[3]: Entering directory `/root/maowenan/libmnl/include/linux'
Making all in netfilter
make[4]: Entering directory `/root/maowenan/libmnl/include/linux/netfilter'
make[4]: Nothing to be done for `all'.
make[4]: Leaving directory `/root/maowenan/libmnl/include/linux/netfilter'
make[4]: Entering directory `/root/maowenan/libmnl/include/linux'
make[4]: Nothing to be done for `all-am'.
make[4]: Leaving directory `/root/maowenan/libmnl/include/linux'
make[3]: Leaving directory `/root/maowenan/libmnl/include/linux'
make[3]: Entering directory `/root/maowenan/libmnl/include'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/root/maowenan/libmnl/include'
make[2]: Leaving directory `/root/maowenan/libmnl/include'
Making all in examples
make[2]: Entering directory `/root/maowenan/libmnl/examples'
Making all in genl
make[3]: Entering directory `/root/maowenan/libmnl/examples/genl'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/root/maowenan/libmnl/examples/genl'
Making all in kobject
make[3]: Entering directory `/root/maowenan/libmnl/examples/kobject'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/root/maowenan/libmnl/examples/kobject'
Making all in netfilter
make[3]: Entering directory `/root/maowenan/libmnl/examples/netfilter'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/root/maowenan/libmnl/examples/netfilter'
Making all in rtnl
make[3]: Entering directory `/root/maowenan/libmnl/examples/rtnl'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/root/maowenan/libmnl/examples/rtnl'
make[3]: Entering directory `/root/maowenan/libmnl/examples'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/root/maowenan/libmnl/examples'
make[2]: Leaving directory `/root/maowenan/libmnl/examples'
make[2]: Entering directory `/root/maowenan/libmnl'
make[2]: Leaving directory `/root/maowenan/libmnl'
make[1]: Leaving directory `/root/maowenan/libmnl'

