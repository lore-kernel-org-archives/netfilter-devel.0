From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ipt_limit module with sun4u architectures
Date: Thu, 19 Feb 2004 21:18:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402191943010.2826-100000@filer.marasystems.com>
References: <20040219175014.GA12545@primewebs.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jose Monteiro <jfmonteiro@netvisao.pt>
In-Reply-To: <20040219175014.GA12545@primewebs.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Feb 2004, Jose Monteiro wrote:

> Since this bug is already very old (2003-05-29), and probably there
> aren't that few sun4u/linux/iptables users as it could be supposed
> (partly because of the line of reasoning above, who knows), i was coming
> for the help of you guys to see if a patch is made available.

The problem is that there has not been found a clear way to detect the
64-bit kernel / 32-bit user situation, probably because there is no 
iptables developers working in such environment.

A simple patch is to when you compile the userspace replace the pointer 
within the ipt_ratelimit structure with a "long long".

So instead of

	/* Ugly, ugly fucker. */
	struct ipt_rateinfo *master;

You have

        /* Ugly, ugly fucker. */
#ifdef __KERNEL__
	struct ipt_rateinfo *master;
#else
        long long ugly_fucker;
#endif

The problem is that this can not be done universially until a clean way to 
defermine what that ugly_fucker should be to match the size and alignment 
of a pointer within the kernel.

Regards
Henrik
