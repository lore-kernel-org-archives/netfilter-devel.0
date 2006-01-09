From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 09 Jan 2006 17:52:44 +0900 (JST)
Message-ID: <200601090852.k098qjft024977@toshiba.co.jp>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Jan__9_17_52_44_2006_026)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
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

----Next_Part(Mon_Jan__9_17_52_44_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 8 Jan 2006 22:26:20 +0100

> Hi!
> 
> It's been some time since I last released a version of the x_tables
> patch.  This is mainly due to the reason that 2.6.15 has only been
> released recently, and x_tables was clearly 2.6.16 work.
> 
> I've modified nfsim and the nfsim-testsuite to work with an x_tables
> kernel, and all tests now pass without any problem (using an old
> iptables binary that was compiled against a non-xtables kernel). This,
> in addition to my manual tests, give me enough confidence that I didn't
> break something significant.
> 
> I'm planning to submit x_tables eatly next week, so this is assumed to
> be the final review phase.
> 
> So if you have any issues, please comment now before it's too late :)

OK, I'll test it after sending this mail. Before that I have some comments
about minor issues.

The dependency on NETFILTER_XTABLES is missing at config of
CLASSIFY and NOTRACK. And according to your Kconfig style, the menu item
for CLASSIFY should not be shown. Please apply attached patches.

I have one more comment about need_conntrack(). The kernel with x_tables patch
doesn't load nf_connrack_ipv4 when user types "iptables -A INPUT -m state...".
Then no packets might be untracked after that. One solution is to try load
nf_conntrack_{ipv4,ipv6} and to ignore error on load, but I'm not sure that
this is the best way.

-- Yasuyuki Kozakai

----Next_Part(Mon_Jan__9_17_52_44_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-xt-dependency.patch"

[NETFILTER] x_tables: CONNMARK and NOTRACK target needs NETFILTER_XTABLES

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f00b6e9542a3c1d3d4cfe736d275c17826cf5d4a
tree 0f210538533e3f60416261849d2eb2a5b4c36142
parent 4f879b6981ff5d21484c20faaf7ff6730a5d494f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 09 Jan 2006 02:38:20 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 09 Jan 2006 14:37:05 +0900

 net/netfilter/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index b860c23..b99b326 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -124,6 +124,7 @@ config NETFILTER_XT_TARGET_CLASSIFY
 
 config NETFILTER_XT_TARGET_CONNMARK
 	tristate  'CONNMARK target support'
+	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
 	help
@@ -161,6 +162,7 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  'NOTRACK target support'
+	depends on NETFILTER_XTABLES
 	depends on IP_NF_RAW || IP6_NF_RAW
 	depends on IP_NF_CONNTRACK || NF_CONNTRACK
 	help

----Next_Part(Mon_Jan__9_17_52_44_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-xt-classify.patch"

[NETFILTER] x_tables: don't show menu item for IP_NF_TARGET_CLASSIFY

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 4f879b6981ff5d21484c20faaf7ff6730a5d494f
tree aede2a5367518adfbf84c970272cccb7f539a8b6
parent 91b0e552d6e525e61410205864ff79a00a4807f1
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 09 Jan 2006 02:25:05 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 09 Jan 2006 14:37:04 +0900

 net/ipv4/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db0883c..45eeb8b 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -664,7 +664,7 @@ config IP_NF_TARGET_MARK
 	  automatically select new xtables match based on the old value
 
 config IP_NF_TARGET_CLASSIFY
-	tristate "CLASSIFY target support"
+	tristate
 	default n
 	select NETFILTER_XT_TARGET_CLASSIFY
 	help

----Next_Part(Mon_Jan__9_17_52_44_2006_026)----
