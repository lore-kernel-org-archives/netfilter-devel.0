From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH nf] netfilter: ipt_CLUSTERIP: fix use-after-free of proc entry
Date: Wed, 19 Jul 2017 12:29:58 +1200
Message-ID: <CADvbK_f8Ya17-nmXLatEqEXFU6+bo=nOjFW1yn8oZcRGYG5u8Q@mail.gmail.com>
References: <dcf5953ca3d90bddf3b496d7bb86c9d30f7069f4.1500381553.git.sd@queasysnail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35668 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdGSA37 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 20:29:59 -0400
Received: by mail-qk0-f195.google.com with SMTP id t186so2860775qkf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 17:29:59 -0700 (PDT)
In-Reply-To: <dcf5953ca3d90bddf3b496d7bb86c9d30f7069f4.1500381553.git.sd@queasysnail.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 12:56 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> When we delete a netns with a CLUSTERIP rule, clusterip_net_exit() is
> called first, removing /proc/net/ipt_CLUSTERIP.
> Then clusterip_config_entry_put() is called from clusterip_tg_destroy(),
> and tries to remove its entry under /proc/net/ipt_CLUSTERIP/.
>
> Fix this by checking that the parent directory of the entry to remove
> hasn't already been deleted.
>
> The following triggers a KASAN splat (stealing the reproducer from
> 202f59afd441, thanks to Jianlin Shi and Xin Long):
>
>     ip netns add test
>     ip link add veth0_in type veth peer name veth0_out
>     ip link set veth0_in netns test
>     ip netns exec test ip link set lo up
>     ip netns exec test ip link set veth0_in up
>     ip netns exec test iptables -I INPUT -d 1.2.3.4 -i veth0_in -j     \
>         CLUSTERIP --new --clustermac 89:d4:47:eb:9a:fa --total-nodes 3 \
>         --local-node 1 --hashmode sourceip-sourceport
>     ip netns del test
>
> Fixes: ce4ff76c15a8 ("netfilter: ipt_CLUSTERIP: make proc directory per net namespace")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Reviewed-by: Xin Long <lucien.xin@gmail.com>
