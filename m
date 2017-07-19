From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipt_CLUSTERIP: fix use-after-free of proc
 entry
Date: Wed, 19 Jul 2017 11:52:05 +0200
Message-ID: <20170719095205.GA1057@salvia>
References: <dcf5953ca3d90bddf3b496d7bb86c9d30f7069f4.1500381553.git.sd@queasysnail.net>
 <CADvbK_f8Ya17-nmXLatEqEXFU6+bo=nOjFW1yn8oZcRGYG5u8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sabrina Dubroca <sd@queasysnail.net>,
        netfilter-devel@vger.kernel.org
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754375AbdGSJwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 05:52:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C0ED523DD
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 11:52:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C190D1CB3
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 11:52:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C09FDA80E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 11:51:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CADvbK_f8Ya17-nmXLatEqEXFU6+bo=nOjFW1yn8oZcRGYG5u8Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 12:29:58PM +1200, Xin Long wrote:
> On Wed, Jul 19, 2017 at 12:56 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> > When we delete a netns with a CLUSTERIP rule, clusterip_net_exit() is
> > called first, removing /proc/net/ipt_CLUSTERIP.
> > Then clusterip_config_entry_put() is called from clusterip_tg_destroy(),
> > and tries to remove its entry under /proc/net/ipt_CLUSTERIP/.
> >
> > Fix this by checking that the parent directory of the entry to remove
> > hasn't already been deleted.
> >
> > The following triggers a KASAN splat (stealing the reproducer from
> > 202f59afd441, thanks to Jianlin Shi and Xin Long):
> >
> >     ip netns add test
> >     ip link add veth0_in type veth peer name veth0_out
> >     ip link set veth0_in netns test
> >     ip netns exec test ip link set lo up
> >     ip netns exec test ip link set veth0_in up
> >     ip netns exec test iptables -I INPUT -d 1.2.3.4 -i veth0_in -j     \
> >         CLUSTERIP --new --clustermac 89:d4:47:eb:9a:fa --total-nodes 3 \
> >         --local-node 1 --hashmode sourceip-sourceport
> >     ip netns del test
> >
> > Fixes: ce4ff76c15a8 ("netfilter: ipt_CLUSTERIP: make proc directory per net namespace")
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
