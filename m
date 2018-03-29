From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net-next 0/5] Introduce net_rwsem to protect
 net_namespace_list
Date: Thu, 29 Mar 2018 13:48:14 -0400 (EDT)
Message-ID: <20180329.134814.2157489714350229877.davem@davemloft.net>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org,
	linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org,
	ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.kapl-uSbOeAmDUekAvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,
	christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org,
	paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,
	pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
	brouer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jbenc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org,
	nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, vyasevic-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, pombredanne-od1rfyK75/E@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org,
	danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ma
To: ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org
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

From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Date: Thu, 29 Mar 2018 19:20:23 +0300

> The series introduces fine grained rw_semaphore, which will be used
> instead of rtnl_lock() to protect net_namespace_list.
> 
> This improves scalability and allows to do non-exclusive sleepable
> iteration for_each_net(), which is enough for most cases.
> 
> scripts/get_maintainer.pl gives enormous list of people, and I add
> all to CC.
> 
> Note, that this patch is independent of "Close race between
> {un, }register_netdevice_notifier and pernet_operations":
> https://patchwork.ozlabs.org/project/netdev/list/?series=36495
> 
> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Great stuff!

Series applied, thanks!
