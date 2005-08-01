From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] conntrack netlink updates
Date: Mon, 01 Aug 2005 19:04:37 +0200
Message-ID: <42EE5625.8020703@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
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

Hi,

This is a set of patches that fix several problems introduced due to 
some modifications done before the merge to the 2.6.14 tree:

[CONNTRACK_NETLINK]: Fix expectation leak
[CONNTRACK_NETLINK]: Kill bogus memsets
[CONNTRACK_NETLINK]: Fix warnings when debug mode is on
[CONNTRACK_NETLINK]: Add ctnetlink_change_protoinfo
[CONNTRACK_NETLINK]: Fix a deadlock in new_conntrack
[CONNTRACK_NETLINK]: Fix expectation creation
[CONNTRACK_NETLINK]: Implements change protoinfo via from_nfattr

These patches applies to netfilter-2.6.14.git, but they applies with 
hunks to davem 2.6.14 tree.

--
Pablo
