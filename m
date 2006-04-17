From: "David S. Miller" <davem@davemloft.net>
Subject: Re: compat_xt_counters is not compatible
Date: Mon, 17 Apr 2006 13:13:25 -0700 (PDT)
Message-ID: <20060417.131325.123750237.davem@davemloft.net>
References: <200604152238.37403.dim@sw.ru> <jeu08uij8r.fsf@sykes.suse.de>
	<200604161028.38614.dim@sw.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dim@sw.ru
In-Reply-To: <200604161028.38614.dim@sw.ru>
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

From: Dmitry Mishin <dim@sw.ru>
Date: Sun, 16 Apr 2006 10:28:38 +0400

> >
> > Almost every architecture has alignment = size for basic types.
> >
> > Andreas.
> I mean structures. I don't see a bug still. Can you point out wrong code?

I can't believe such a conversation even gets this far. :(

LOOK!

struct {
	int x;
	unsigned long long y;
};

This structure requires 64-bit alignment on 32-bit Sparc and
32-bit PPC and 32-bit MIPS and 32-bit ....

It is x86, and only x86, that has only a 32-bit alignment requirement
for this structure.
