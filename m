From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Mon, 29 Aug 2005 23:01:38 +0200
Message-ID: <431377B2.9080102@trash.net>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>	<20050828122130.GH4244@rama.de.gnumonks.org>	<4312EE29.9040102@trash.net>
	<200508291539.j7TFdujr019558@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200508291539.j7TFdujr019558@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi, Patrick, Harald,
> 
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 29 Aug 2005 13:14:49 +0200
> 
> 
>>I feel reluctant to add complexity just so users can switch between
>>them at runtime. It may be useful for debugging, but it doesn't look
>>like a realistic usage scenario. So I would also prefer having a
>>compile-time choice.
> 
> I re-read old mails, and I seemed to mis-understand your intention.
> I was trying to make possible to compile both of ip_conntrack and
> nf_conntrack as module, and let user choose "Which is linked with match/target
> modules ?". But your opinion was that user choose ip_conntrack or
> nf_conntrack to compile, right ?

Yes, sorry for not beeing clearer on this before. I was always
more in favour of a compile-time solution, but would also be
fine with a simple and cleanly working run-time solution. But
I believe any extra-complexity for a run-time solution comes
with little gain for the user.

> Then, let user choose ip_conntrack/nf_conntrack to compile.
> 
> From: Harald Welte <laforge@netfilter.org>
> Date: Sun, 28 Aug 2005 14:21:30 +0200
> 
> 
>>1) ip_conntrack and nf_conntrack can never be used both together in one
>>   system.  However, you can compile both of them as modules, and then
>>   decide to load one or the other.
> 
> The drawback of compile-time choice is that user cannot use ip_conntrack
> for IPv4 NAT and use nf_conntrack for only IPv6 stateful tracking. This is the
> reason why I tried above thing, but I changed my mind. This will not be
> problem because IPv4 NAT with nf_conntrack would be implemented in future,
> I think.

I agree, even if it is a problem, it will only be short-term.
