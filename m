From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: fixes for ipv6 supported conntrack and libnetfilter_conntrack
Date: Sun, 25 Dec 2005 16:36:20 +0900 (JST)
Message-ID: <200512250736.jBP7aLRA006703@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
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


Hi, Pablo,

I played with your patches for IPv6 support to conntrack and
libnetfilter_conntrack. Please consider applying following fixes
on top of you patches.

[PATCH 1/2] conntrack: fix incomplete copying IPv6 addresses
[PATCH 2/2] conntrack: check address family mismatch
[PATCH 1/1] libnetfilter_conntrack: fix dumping IPv6 connections

Regards,

-- Yasuyuki Kozakai
