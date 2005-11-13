From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Link netfilter before ipv4.
Date: Sun, 13 Nov 2005 17:10:43 +0900 (JST)
Message-ID: <200511130810.jAD8Ah9w017757@toshiba.co.jp>
References: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_10_43_2005_793)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl, laforge@netfilter.org
In-Reply-To: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
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

----Next_Part(Sun_Nov_13_17_10_43_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Krzysztof Oledzki <olenf@ans.pl>
Date: Sat, 12 Nov 2005 02:07:24 +0100 (CET)

> Hello,
> 
> Attached (and inlined) patch moves netfilter before ipv4.
> This is required for statically linked nf_conntrack_ipv4:
> 
> (...)
> nf_conntrack_ipv4: can't register ipv4
> TCP bic registered
> TCP westwood registered
> TCP highspeed registered
> TCP hybla registered
> TCP htcp registered
> TCP vegas registered
> TCP scalable registered
> Netfilter messages via NETLINK v0.30.
> nf_conntrack version 0.4.1 (4095 buckets, 32760 max)
> (...)

Good catch! But that patch seems not to able to apply current tree because of
Hunk. Harald, could you apply attached patch instead ?

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-- Yasuyuki Kozakai

----Next_Part(Sun_Nov_13_17_10_43_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-link-nf-before-ipv4.patch"

[NETFILTER] load netfilter before ipv4

Staticaly linked nf_conntrack_ipv4 requires nf_conntrack. but currently
nf_conntrack is linked after it. This changes the order of ipv4 and netfilter
to fix this.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 52282bc26fc11ea1b1ccc669e5a50594a1ec0197
tree e917d054fd1cc9990a40c3e7fb3bd9a695d74aba
parent 3dee1e7deee4fb4fa655d48befe4a8068174aa79
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 03:50:00 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 03:50:00 +0900

 net/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index 4aa2f46..f5141b9 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -15,8 +15,8 @@ obj-$(CONFIG_NET)		+= $(tmp-y)
 # LLC has to be linked before the files in net/802/
 obj-$(CONFIG_LLC)		+= llc/
 obj-$(CONFIG_NET)		+= ethernet/ 802/ sched/ netlink/
-obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_NETFILTER)		+= netfilter/
+obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX)		+= unix/
 ifneq ($(CONFIG_IPV6),)

----Next_Part(Sun_Nov_13_17_10_43_2005_793)----
