From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next V2] netfilter: cttimeout: use nf_ct_iterate_cleanup_net
 to unlink timeout objs
Date: Mon, 29 May 2017 07:49:55 +0800
Message-ID: <CAML_gOfV40wm6oBmuRYz3r8G=jDseOH1_CDMtUkoUVLNZ0hnDg@mail.gmail.com>
References: <1495982239-17054-1-git-send-email-zlpnobody@163.com> <201705282328.DHsxSWuh%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Liping Zhang <zlpnobody@163.com>, kbuild-all@01.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33449 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdE1Xt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2017 19:49:56 -0400
Received: by mail-vk0-f68.google.com with SMTP id c185so674057vkd.0
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2017 16:49:56 -0700 (PDT)
In-Reply-To: <201705282328.DHsxSWuh%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

2017-05-29 0:07 GMT+08:00 kbuild test robot <lkp@intel.com>:
>    net/netfilter/nfnetlink_cttimeout.c: In function 'ctnl_untimeout':
>>> net/netfilter/nfnetlink_cttimeout.c:303:2: error: implicit declaration of function 'nf_ct_iterate_cleanup_net' [-Werror=implicit-function-declaration]
>      nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
>      ^~~~~~~~~~~~~~~~~~~~~~~~~

This patch is based on Florian's patch set "netfilter: conntrack: rework
nf_ct_iterate, part 1.", which has not been applied in nf-next tree.

So currently, nf_ct_iterate_destroy and nf_ct_iterate_cleanup_net
does not exist in nf-next tree.
