From: Marcel Pol <mpol@gmx.net>
Subject: unresolved symbols in ipt_iplimit
Date: Tue, 17 Dec 2002 19:24:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021217192421.24ec6913.mpol@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,
I patched my 2.4.19-1mdk kernel with iplimit, string and NETLINK, and I'm
getting depmod errors on ipt_iplimit.

# depmod -ae
depmod: *** Unresolved symbols in
/lib/modules/2.4.19-1mdk-inferno2/kernel/net/ipv4/netfilter/ipt_iplimit.o
depmod:         ip_conntrack_find_get

This happened both with the last release of pom, and with the cvs version of
yesterday.
I compiled it with gcc 3.2 and binutils-2.13.90.0.10-1mdk.
It's on an Alpha AXPpci 166 ev4.
If there is more information needed, I'm willing to give that.

Greetings,
--
Marcel Pol

Linux 2.4.20-0.4mdk.ringworld.1, up 10 days, 23:07
Registered User #163523
