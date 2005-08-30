From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: (no subject)
Date: Tue, 30 Aug 2005 22:21:31 +0900 (JST)
Message-ID: <200508301321.j7UDLVGE024637@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org, laforge@netfilter.org
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

If CONFIG_NF_IP_CONNTRACK=y, CONFIG_NETFILTER_NETLINK=m, and
CONFIG_NF_CONNTRACK_NETLINK=m, it's failed to build kernel
of netfilter-2.6.14 git tree. Because __nfa_fill() in nfnetlink
called from ip_conntrack isn't built into kernel image in this case.
It's necessary to fix Kconfig or change source code to make dependencies
more simple.

BTW, the current relation between ip_conntrack, nfnetlink, and nfctnetlink
is complex. The following table is the patterns user can select.

ip_conntrack   | n n n n n n n n n m m m m m m m m m y y y y y y y y y
nfnetlink      | n n n m m m y y y n n n m m m y y y n n n m m m y y y
nfctnetlink    | n m y n m y n m y n m y n m y n m y n m y n m y n m y
-----------------------------------------------------------------------------
               | o x x o x x o x x o x x o o x o o x o x x o * x o o o

o: user can select and no error.
x: user can select.
*: user can select, but error.


Sorry, it's too difficult for me to fix Kconfig without complexity.
I think it's preferable that ip_conntrack doesn't depend on nfctnetlink.

Regars,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
