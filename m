From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 6 May 2004 17:33:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405061729170.1102-100000@blackhole.kfki.hu>
References: <1083852576.1822.18.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
	dan radom <netfilter@radom.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1083852576.1822.18.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, KOVACS Krisztian wrote:

> struct ipt_rateinfo {
> 	u_int32_t avg;    /* Average secs between packets * scale */
> 	u_int32_t burst;  /* Period multiplier for upper limit. */
>
> 	/* Used internally by the kernel */
> 	unsigned long prev;
> 	u_int32_t credit;
> 	u_int32_t credit_cap, cost;
>
> 	/* Ugly, ugly fucker. */
> 	struct ipt_rateinfo *master;
> };
>
>   The problem point is *master, which, however, is for in-kernel use
> only.

Just a thought: in 'pool' there was a similar problem and it was solved in
'set' by keeping the kernel info structures in an array. Then instead of
the pointer like above, the user part stored the index of the
corresponding structure in the array.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
