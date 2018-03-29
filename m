From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 0/3] Close race between {un,
 }register_netdevice_notifier and pernet_operations
Date: Thu, 29 Mar 2018 17:03:15 +0300
Message-ID: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        daniel@iogearbox.net, jakub.kicinski@netronome.com, ast@kernel.org,
        brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

the problem is {,un}register_netdevice_notifier() do not take
pernet_ops_rwsem, and they don't see network namespaces, being
initialized in setup_net() and cleanup_net(), since at this
time net is not hashed to net_namespace_list.

This may lead to imbalance, when a notifier is called at time of
setup_net()/net is alive, but it's not called at time of cleanup_net(),
for the devices, hashed to the net, and vise versa. See (3/3) for
the scheme of imbalance.

This patchset fixes the problem by acquiring pernet_ops_rwsem
at the time of {,un}register_netdevice_notifier() (3/3).
(1-2/3) are preparations in xfrm and netfilter subsystems.

The problem was introduced a long ago, but backporting won't be easy,
since every previous kernel version may have changes in netdevice
notifiers, and they all need review and testing. Otherwise, there
may be more pernet_operations, which register or unregister
netdevice notifiers, and that leads to deadlock (which is was fixed
in 1-2/3). This patchset is for net-next.

Thanks,
Kirill
---

Kirill Tkhai (3):
      xfrm: Register xfrm_dev_notifier in appropriate place
      netfilter: Rework xt_TEE netdevice notifier
      net: Close race between {un,}register_netdevice_notifier() and setup_net()/cleanup_net()


 include/net/xfrm.h     |    2 +
 net/core/dev.c         |    6 ++++
 net/netfilter/xt_TEE.c |   73 ++++++++++++++++++++++++++++++------------------
 net/xfrm/xfrm_device.c |    2 +
 net/xfrm/xfrm_policy.c |    3 +-
 5 files changed, 55 insertions(+), 31 deletions(-)
