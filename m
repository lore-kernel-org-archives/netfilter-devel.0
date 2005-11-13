From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 0/4] fixes fragments handling in nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 17:50:32 +0900 (JST)
Message-ID: <200511130850.jAD8oXv1011978@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hi,

3 of these fix evictor of IPv6 fragment queues, other is just cleanup
to sync with net/ipv6/reassembly.c

Yes, it'll be better to unify nf_conntrack_reasm.c and reassembly.c at last.
Their differences are sending ICMPv6 error or not, statistics,
and keeping original fragments or not.

Regards,

-- Yasuyuki Kozakai
