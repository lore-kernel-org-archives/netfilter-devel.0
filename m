From: Patrick McHardy <kaber@trash.net>
Subject: Re: compat_xt_counters is not compatible
Date: Sun, 16 Apr 2006 17:07:26 +0200
Message-ID: <44425DAE.3040007@trash.net>
References: <44412142.9070409@trash.net>	<jeacamkanp.fsf@sykes.suse.de>	<444132C1.1020604@trash.net>
	<20060416.002436.108421304.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, schwab@suse.de, netfilter-devel@lists.netfilter.org,
	dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060416.002436.108421304.davem@davemloft.net>
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
> A struct containing a u64 has to be 64-bit aligned on at least sparc64
> and ppc64, both of which use the compat layer for 32-bit programs, so
> I think it's quite clear this will have to be implemented differently.

Do these alignment requirements also hold for 32bit compiled programms?
This is what we need to match with compat_xt_counters. Or in other
words: we need a type that when compiled for 64bit has the same
alignment requirements as structures with embedded u_int64_t members
compiled for 32bit on all architectures supporting CONFIG_COMPAT.
I don't think such a type exists, so I guess we'll have to use different
types depending on the architecture.

I'll send a patch to do that if there are no better suggestions.
