From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] ctnetlink updates strike #2
Date: Fri, 05 Aug 2005 02:35:46 +0200
Message-ID: <42F2B462.2010700@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi Harald, Patrick,

The following patches includes some fixes for ctnetlink.

kernel:
[PATCH] Fix bad size of ctnl_exp_cb array
[PATCH] Iterate lists from the tail to the head
[PATCH] Fix wrong order in event notification
[PATCH] Drop expectation refcount after unlinking expectation
[PATCH] Change protocol private information
[PATCH] Remove ip_conntrack <-> nfnetlink dependency

userspace:
[PATCH] updates for libnfnetlink_conntrack

Hope that this time I was a bit more verbose ;)

--
Pablo
