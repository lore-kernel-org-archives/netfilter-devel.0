From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 06 May 2004 16:09:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083852576.1822.18.camel@nienna.balabit>
References: <Pine.LNX.4.44.0405061211230.29759-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: dan radom <netfilter@radom.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405061211230.29759-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-05-06, cs keltezéssel 12:12-kor Henrik Nordstrom ezt írta:
> > This bug has been open for quite some time, and bugzilla doesn't really
> > shows much beyond the initial bug report.  Is this something that will
> > ever work?  I would love to use this feature on sparc64.
> 
> It requires some clever guy with a sparc64 to come up with a scheme how to 
> make user and kernel data types compatible in a 32/64 split user/kernel 
> environment.

  I think the main problem is that there is no easy way to store
per-match internal data, so it is stored in the matchinfo structure
describing the match itself. If the data describing the match itself
(which is copied from userspace) and data used for in-kernel status
could be separated, problems like these didn't exist at all...

  A possible hack: let's define two separate structures, one for
in-kernel use, and one for the userspace. The current ipt_rateinfo
structure looks like this:

struct ipt_rateinfo {
	u_int32_t avg;    /* Average secs between packets * scale */
	u_int32_t burst;  /* Period multiplier for upper limit. */

	/* Used internally by the kernel */
	unsigned long prev;
	u_int32_t credit;
	u_int32_t credit_cap, cost;

	/* Ugly, ugly fucker. */
	struct ipt_rateinfo *master;
};

  The problem point is *master, which, however, is for in-kernel use
only. What if we don't export that to userspace, ie. we define
ipt_rateinfo to not include that field, and use the current structure
internally only? In this case, the structure size check in checkentry()
would check if matchsize equals the size of the structure used by
userspace, but would cast matchinfo to the internal one.

  I know, I know, it's an ugly hack. However, I still think that
in-kernel data should not be stored in the structure describing the
match itself.

-- 
 Regards,
   Krisztian KOVACS
