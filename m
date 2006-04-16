From: "David S. Miller" <davem@davemloft.net>
Subject: Re: compat_xt_counters is not compatible
Date: Sun, 16 Apr 2006 00:24:36 -0700 (PDT)
Message-ID: <20060416.002436.108421304.davem@davemloft.net>
References: <44412142.9070409@trash.net> <jeacamkanp.fsf@sykes.suse.de>
	<444132C1.1020604@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <444132C1.1020604@trash.net>
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
Date: Sat, 15 Apr 2006 19:52:01 +0200

> Well, then how about providing the necessary information, starting
> with the architecture?

A struct containing a u64 has to be 64-bit aligned on at least sparc64
and ppc64, both of which use the compat layer for 32-bit programs, so
I think it's quite clear this will have to be implemented differently.
