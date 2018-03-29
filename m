From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH net-next 0/5] Introduce net_rwsem to protect
 net_namespace_list
Date: Thu, 29 Mar 2018 19:20:23 +0300
Message-ID: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org,
	kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, pshelar-LZ6Gd1LRuIk@public.gmane.org,
	johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,
	eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org,
	leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
	ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org,
	vyasevic-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org,
	jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org,
	ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brouer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org,
	john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
	idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org,
	roman.kapl-uSbOeAmDUekAvxtiuMwx3w@public.gmane.org, lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org,
	jbenc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pombredanne-od1rfyK75/E@public.gmane.org, linux-rdma@vger.k
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

The series introduces fine grained rw_semaphore, which will be used
instead of rtnl_lock() to protect net_namespace_list.

This improves scalability and allows to do non-exclusive sleepable
iteration for_each_net(), which is enough for most cases.

scripts/get_maintainer.pl gives enormous list of people, and I add
all to CC.

Note, that this patch is independent of "Close race between
{un, }register_netdevice_notifier and pernet_operations":
https://patchwork.ozlabs.org/project/netdev/list/?series=36495

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---

Kirill Tkhai (5):
      net: Introduce net_rwsem to protect net_namespace_list
      net: Don't take rtnl_lock() in wireless_nlevent_flush()
      security: Remove rtnl_lock() in selinux_xfrm_notify_policyload()
      ovs: Remove rtnl_lock() from ovs_exit_net()
      net: Remove rtnl_lock() in nf_ct_iterate_destroy()


 drivers/infiniband/core/roce_gid_mgmt.c |    2 ++
 include/linux/rtnetlink.h               |    1 +
 include/net/net_namespace.h             |    1 +
 net/core/dev.c                          |    5 +++++
 net/core/fib_notifier.c                 |    2 ++
 net/core/net_namespace.c                |   18 +++++++++++++-----
 net/core/rtnetlink.c                    |    5 +++++
 net/netfilter/nf_conntrack_core.c       |    4 ++--
 net/openvswitch/datapath.c              |    4 ++--
 net/wireless/wext-core.c                |    6 ++----
 security/selinux/include/xfrm.h         |    4 ++--
 11 files changed, 37 insertions(+), 15 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
