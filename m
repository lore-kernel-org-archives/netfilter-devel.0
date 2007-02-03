From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: ctnetlink: fix compile failure with
	NF_CONNTRACK_MARK=n
Date: Sat,  3 Feb 2007 02:46:24 +0100 (MET)
Message-ID: <20070203014621.892.28222.sendpatchset@localhost.localdomain>
References: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: fix compile failure with NF_CONNTRACK_MARK=n

  CC      net/netfilter/nf_conntrack_netlink.o
net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_conntrack_event':
net/netfilter/nf_conntrack_netlink.c:392: error: 'struct nf_conn' has no member named 'mark'
make[3]: *** [net/netfilter/nf_conntrack_netlink.o] Error 1

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit de4fee1de939b8a5422020822195dea4b25e142b
tree 0d8bdc11e791cec75d5c61ecdbdd9d26f80df9ea
parent 91ddce838eb24a62844bdfc1aaca0a364343ad02
author Max Kellermann <max@duempel.org> Fri, 02 Feb 2007 14:09:40 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Feb 2007 14:09:40 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 ++
 net/netfilter/nf_conntrack_netlink.c      |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 6f31fad..7f70b08 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -374,9 +374,11 @@ static int ctnetlink_conntrack_event(str
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		    	goto nfattr_failure;
 
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
 		if ((events & IPCT_MARK || ct->mark)
 		    && ctnetlink_dump_mark(skb, ct) < 0)
 		    	goto nfattr_failure;
+#endif
 
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 811e3e7..c64f029 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -389,9 +389,11 @@ static int ctnetlink_conntrack_event(str
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		    	goto nfattr_failure;
 
+#ifdef CONFIG_NF_CONNTRACK_MARK
 		if ((events & IPCT_MARK || ct->mark)
 		    && ctnetlink_dump_mark(skb, ct) < 0)
 		    	goto nfattr_failure;
+#endif
 
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
