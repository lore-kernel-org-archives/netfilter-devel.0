From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 3/3] net: Close race between {un,
 }register_netdevice_notifier() and setup_net()/cleanup_net()
Date: Thu, 29 Mar 2018 17:03:45 +0300
Message-ID: <152233222535.1654.14385232567049072419.stgit@localhost.localdomain>
References: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
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
In-Reply-To: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

{un,}register_netdevice_notifier() iterate over all net namespaces
hashed to net_namespace_list. But pernet_operations register and
unregister netdevices in unhashed net namespace, and they are not
seen for netdevice notifiers. This results in asymmetry:

1)Race with register_netdevice_notifier()
  pernet_operations::init(net)	...
   register_netdevice()		...
    call_netdevice_notifiers()  ...
      ... nb is not called ...
  ...				register_netdevice_notifier(nb) -> net skipped
  ...				...
  list_add_tail(&net->list, ..) ...

  Then, userspace stops using net, and it's destructed:

  pernet_operations::exit(net)
   unregister_netdevice()
    call_netdevice_notifiers()
      ... nb is called ...

This always happens with net::loopback_dev, but it may be not the only device.

2)Race with unregister_netdevice_notifier()
  pernet_operations::init(net)
   register_netdevice()
    call_netdevice_notifiers()
      ... nb is called ...

  Then, userspace stops using net, and it's destructed:

  list_del_rcu(&net->list)	...
  pernet_operations::exit(net)  unregister_netdevice_notifier(nb) -> net skipped
   dev_change_net_namespace()	...
    call_netdevice_notifiers()
      ... nb is not called ...
   unregister_netdevice()
    call_netdevice_notifiers()
      ... nb is not called ...

This race is more danger, since dev_change_net_namespace() moves real
network devices, which use not trivial netdevice notifiers, and if this
will happen, the system will be left in unpredictable state.

The patch closes the race. During the testing I found two places,
where register_netdevice_notifier() is called from pernet init/exit
methods (which led to deadlock) and fixed them (see previous patches).

The review moved me to one more unusual registration place:
raw_init() (can driver). It may be a reason of problems,
if someone creates in-kernel CAN_RAW sockets, since they
will be destroyed in exit method and raw_release()
will call unregister_netdevice_notifier(). But grep over
kernel tree does not show, someone creates such sockets
from kernel space.

Theoretically, there can be more places like this, and which are
hidden from review, but we found them on the first bumping there
(since there is no a race, it will be 100% reproducible).

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 net/core/dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index e13807b5c84d..43abc5785a85 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1623,6 +1623,8 @@ int register_netdevice_notifier(struct notifier_block *nb)
 	struct net *net;
 	int err;
 
+	/* Close race with setup_net() and cleanup_net() */
+	down_write(&pernet_ops_rwsem);
 	rtnl_lock();
 	err = raw_notifier_chain_register(&netdev_chain, nb);
 	if (err)
@@ -1645,6 +1647,7 @@ int register_netdevice_notifier(struct notifier_block *nb)
 
 unlock:
 	rtnl_unlock();
+	up_write(&pernet_ops_rwsem);
 	return err;
 
 rollback:
@@ -1689,6 +1692,8 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 	struct net *net;
 	int err;
 
+	/* Close race with setup_net() and cleanup_net() */
+	down_write(&pernet_ops_rwsem);
 	rtnl_lock();
 	err = raw_notifier_chain_unregister(&netdev_chain, nb);
 	if (err)
@@ -1706,6 +1711,7 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 	}
 unlock:
 	rtnl_unlock();
+	up_write(&pernet_ops_rwsem);
 	return err;
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier);
