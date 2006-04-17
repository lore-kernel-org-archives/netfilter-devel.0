From: "David S. Miller" <davem@davemloft.net>
Subject: Re: compat_xt_counters is not compatible
Date: Sun, 16 Apr 2006 22:24:35 -0700 (PDT)
Message-ID: <20060416.222435.02924300.davem@davemloft.net>
References: <444132C1.1020604@trash.net>
	<20060416.002436.108421304.davem@davemloft.net>
	<44425DAE.3040007@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, schwab@suse.de, netfilter-devel@lists.netfilter.org,
	dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <44425DAE.3040007@trash.net>
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
Date: Sun, 16 Apr 2006 17:07:26 +0200

> David S. Miller wrote:
> > A struct containing a u64 has to be 64-bit aligned on at least sparc64
> > and ppc64, both of which use the compat layer for 32-bit programs, so
> > I think it's quite clear this will have to be implemented differently.
> 
> Do these alignment requirements also hold for 32bit compiled programms?

Yes, it does.

> This is what we need to match with compat_xt_counters.

This issue is exactly why the compat layer requirements are so wildly
different between "x86_64/ia64 --> ia32" and all other compat
situations.

ia32 doesn't have the 64-bit alignment requirement for structures
containing u64 objects, whereas every other 32-bit platform does.
