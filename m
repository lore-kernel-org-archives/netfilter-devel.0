From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH net-next 3/5] security: Remove rtnl_lock() in
 selinux_xfrm_notify_policyload()
Date: Thu, 29 Mar 2018 19:20:56 +0300
Message-ID: <152234045636.19153.4897050357891895124.stgit__29688.3131064989$1522340433$gmane$org@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
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
In-Reply-To: <152234005959.19153.17907173734141707348.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

rt_genid_bump_all() consists of ipv4 and ipv6 part.
ipv4 part is incrementing of net::ipv4::rt_genid,
and I see many places, where it's read without rtnl_lock().

ipv6 part calls __fib6_clean_all(), and it's also
called without rtnl_lock() in other places.

So, rtnl_lock() here was used to iterate net_namespace_list only,
and we can remove it.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 security/selinux/include/xfrm.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 31d66431be1e..a0b465316292 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -47,12 +47,10 @@ static inline void selinux_xfrm_notify_policyload(void)
 {
 	struct net *net;
 
-	rtnl_lock();
 	down_read(&net_rwsem);
 	for_each_net(net)
 		rt_genid_bump_all(net);
 	up_read(&net_rwsem);
-	rtnl_unlock();
 }
 #else
 static inline int selinux_xfrm_enabled(void)
