From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 0/8]: Netfilter resync
Date: Fri, 04 Mar 2005 13:18:35 +0100
Message-ID: <4228521B.70104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

These patches resync 2.4 with 2.6.

<sj-netfilter:cookinglinux.org>:
   o [NETFILTER]: Fix another DECLARE_MUTEX in header file

Pablo Neira:
   o [NETFILTER]: Fix DECLARE_MUTEX in header file

Patrick McHardy:
   o [NETFILTER]: Fix IP/TCP option logging
   o [NETFILTER]: Fix refreshing of overlapping expectations
   o [NETFILTER]: Fix ip6tables ESP matching with "-p all"
   o [NETFILTER]: Fix cleanup in ipt_recent
   o [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename 
ip_ct_iterate_cleanup()
   o [NETFILTER]: fix return values of ipt_recent checkentry
