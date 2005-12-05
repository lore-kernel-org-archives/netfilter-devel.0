From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 6/9]: Mark ctnetlink as EXPERIMENTAL
Date: Mon, 05 Dec 2005 16:26:54 +0100
Message-ID: <43945C3E.3090809@trash.net>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>	<20051204210123.24032.2569.sendpatchset@localhost.localdomain>
	<43941135.2060300@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000408030206040108030305"
Cc: netfilter-devel@lists.netfilter.org, "David S.Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43941135.2060300@eurodev.net>
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

This is a multi-part message in MIME format.
--------------000408030206040108030305
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
>>[NETFILTER]: Mark ctnetlink as EXPERIMENTAL
>>
> The patch is imcomplete, NF_CONNTRACK_EVENTS must be set as EXPERIMENTAL
> as well (see net/netfilter/Kconfig).

Indeed, thanks. Dave, please use this patch instead.



--------------000408030206040108030305
Content-Type: text/x-patch;
 name="6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="6.diff"

[NETFILTER]: Mark ctnetlink as EXPERIMENTAL

Should have been marked EXPERIMENTAL from the beginning, as the current
bunch of fixes show.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f77890fcb84e5e96aaa65f6b5344c986400915fb
tree 332c6e3f7940bccb6d019c5f76cd9e112009f674
parent e4f5c82a92c2a546a16af1614114eec19120e40a
author Patrick McHardy <kaber@trash.net> Mon, 05 Dec 2005 16:25:24 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 05 Dec 2005 16:25:24 +0100

 net/ipv4/netfilter/Kconfig |    8 ++++----
 net/netfilter/Kconfig      |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 0bc0052..88a6065 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -56,8 +56,8 @@ config IP_NF_CONNTRACK_MARK
 	  instead of the individual packets.
 	
 config IP_NF_CONNTRACK_EVENTS
-	bool "Connection tracking events"
-	depends on IP_NF_CONNTRACK
+	bool "Connection tracking events (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && IP_NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code
@@ -66,8 +66,8 @@ config IP_NF_CONNTRACK_EVENTS
 	  IF unsure, say `N'.
 
 config IP_NF_CONNTRACK_NETLINK
-	tristate 'Connection tracking netlink interface'
-	depends on IP_NF_CONNTRACK && NETFILTER_NETLINK
+	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
+	depends on EXPERIMENTAL && IP_NF_CONNTRACK && NETFILTER_NETLINK
 	depends on IP_NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
 	help
 	  This option enables support for a netlink-based userspace interface
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a84f922..794c41d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -61,8 +61,8 @@ config NF_CONNTRACK_MARK
 	  instead of the individual packets.
 
 config NF_CONNTRACK_EVENTS
-	bool "Connection tracking events"
-	depends on NF_CONNTRACK
+	bool "Connection tracking events (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code

--------------000408030206040108030305--
