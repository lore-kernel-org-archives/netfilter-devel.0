From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Tue, 14 Feb 2006 01:28:51 +0900 (JST)
Message-ID: <200602131628.k1DGSpA3026414@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org, kaber@trash.net, laforge@gnumonks.org
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

These patches make nf_ct_attach work fine in IPv6 stack.

The locally generated reply packets in IPv6 stack, such as ICMPv6 error
and TCP RST by REJECT target, need to be associated with the connection
of original packet.

Please review and apply.

-- Yasuyuki Kozakai
