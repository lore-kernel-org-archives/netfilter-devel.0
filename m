From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH] netfilter: xt_TEE: Fix potential deadlock when TEE target
 is inserted
Date: Mon, 4 Sep 2017 00:51:24 +0900
Message-ID: <CAMArcTWHxMwhKMKMdZZuAx9-3rBn3oxjy_L0hh=s3uwnku6cJQ@mail.gmail.com>
References: <20170903143034.25844-1-ap420073@gmail.com> <nycvar.YFH.7.76.1709031730130.10520@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37968 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbdICPvZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 11:51:25 -0400
Received: by mail-yw0-f194.google.com with SMTP id e9so2477770ywh.5
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Sep 2017 08:51:25 -0700 (PDT)
In-Reply-To: <nycvar.YFH.7.76.1709031730130.10520@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-09-04 0:32 GMT+09:00 Jan Engelhardt <jengelh@inai.de>:
>
> On Sunday 2017-09-03 16:30, Taehee Yoo wrote:
>
>>When xt_TEE target is inserted, lockdep warns about possible
>>DEADLOCK situation. to avoid deadlock situation
>>the register_netdevice_notifier() should be called by only init routine.
>>
>>+#include <linux/if.h>
>>
>> struct xt_tee_tginfo {
>>       union nf_inet_addr gw;
>>-      char oif[16];
>>+      char oif[IFNAMSIZ];
>
> This should not be done, as xt_tee_tginfo is exported to userspace.
> (It also has nothing to do with fixing the deadlock, really.)
>
>>+              case NETDEV_UNREGISTER:
>>+                      if ((dev->ifindex == priv->oif) &&
>
> redundant new parenthesis group

Thank you for your review!

I will send v2 patch.

Thanks
