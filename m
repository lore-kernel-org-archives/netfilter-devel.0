From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 0/8]: conflict symbols and getorigdst issue/bugs
Date: Tue, 22 Mar 2005 22:33:53 +0900 (JST)
Message-ID: <200503221333.j2MDXsJk006741@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi, Patrick,

These are patches for nf_conntrack which
	- unify common enums/flags in ip_conntrack and nf_conntrack,
	  as we talked,
	- fix other conflicts by changing he name of them in nf_conntrack,
	- change SO_ORIGINAL_DST to IPV6_ORIGINAL_DST in netfilter_ipv6.h
	  SO_* are socket level option names, not IP level. This doesn't
	  change netfilter_ipv4.h because of compatibility issue.
	- fix the bug which cannot find the target conntrack.

BTW, getorigdst() for IPv6 connection is really useful ? IPv6 connections
are not NATed, then I think it's meaningless to call it.
If it looks like it's useless, deleting it is fine with me.
If not, please apply patches I send (08, 09).

Moreover, IPV6_ORIGINAL_DST is 80 in the current. Is this value really
appropriate ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
