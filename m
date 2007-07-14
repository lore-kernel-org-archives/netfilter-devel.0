From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 08/08]: nf_conntrack: UDPLITE support
Date: Sun, 15 Jul 2007 01:54:05 +0900 (JST)
Message-ID: <200707141654.l6EGs6hO008904@toshiba.co.jp>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
	<20070714151200.9829.67499.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151200.9829.67499.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 14 Jul 2007 17:12:44 +0200 (MEST)

> [NETFILTER]: nf_conntrack: UDPLITE support

Maybe you predict this question :) Why do you think that new module is
needed instead of reusing codes in nf_conntrack_proto_udp.c ?

-- Yasuyuki Kozakai
