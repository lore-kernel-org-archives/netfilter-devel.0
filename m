From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Tue, 30 Aug 2005 00:39:55 +0900 (JST)
Message-ID: <200508291539.j7TFduQ6009843@toshiba.co.jp>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>
	<20050828122130.GH4244@rama.de.gnumonks.org>
	<4312EE29.9040102@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4312EE29.9040102@trash.net>
	<20050828122130.GH4244@rama.de.gnumonks.org>
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


Hi, Patrick, Harald,

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 29 Aug 2005 13:14:49 +0200

> I feel reluctant to add complexity just so users can switch between
> them at runtime. It may be useful for debugging, but it doesn't look
> like a realistic usage scenario. So I would also prefer having a
> compile-time choice.

I re-read old mails, and I seemed to mis-understand your intention.
I was trying to make possible to compile both of ip_conntrack and
nf_conntrack as module, and let user choose "Which is linked with match/target
modules ?". But your opinion was that user choose ip_conntrack or
nf_conntrack to compile, right ?

Then, let user choose ip_conntrack/nf_conntrack to compile.

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 28 Aug 2005 14:21:30 +0200

> 1) ip_conntrack and nf_conntrack can never be used both together in one
>    system.  However, you can compile both of them as modules, and then
>    decide to load one or the other.

The drawback of compile-time choice is that user cannot use ip_conntrack
for IPv4 NAT and use nf_conntrack for only IPv6 stateful tracking. This is the
reason why I tried above thing, but I changed my mind. This will not be
problem because IPv4 NAT with nf_conntrack would be implemented in future,
I think.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
