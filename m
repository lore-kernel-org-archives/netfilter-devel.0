From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Tue, 30 Aug 2005 00:09:55 +0200
Message-ID: <431387B3.5020006@trash.net>
References: <200506200919.j5K9JIhl022823@toshiba.co.jp>	<20050828122130.GH4244@rama.de.gnumonks.org>	<4312EE29.9040102@trash.net>
	<20050829.145750.105363182.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050829.145750.105363182.davem@davemloft.net>
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

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 29 Aug 2005 13:14:49 +0200
> 
> 
>>I feel reluctant to add complexity just so users can switch between
>>them at runtime. It may be useful for debugging, but it doesn't look
>>like a realistic usage scenario. So I would also prefer having a
>>compile-time choice.
> 
> 
> What do you expect distribution vendors to do?  They keep both
> ipchains and iptables enabled to this day so people can still
> use their old firewalling scripts and setups.
> 
> Unless you provide %100 of the existing functionality in the new stuff
> you have to allow the new stuff to coexist with the older stuff in a
> build else distribution vendors will simply ship the new stuff
> disabled, and stay with the old stuff.
> 
> I really don't see compile time selection as a viable option.
> Do you?

The plan would be to provide all existing functionality as soon as
possible. The targets and matches should be easy with a compile-time
selections, one or two conntrack helpers still need to ported and NAT
needs to be made possible. It all sounds doable in not too long time,
after that I would expect to get significantly more exposure by a
compile-time option because vendors want the IPv6 support. Of course
I'm open for suggestions ..
