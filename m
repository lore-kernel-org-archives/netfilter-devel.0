From: Patrick McHardy <kaber@trash.net>
Subject: Re: [CHECKER] 33 missing null checks
Date: Sun, 28 Mar 2004 11:47:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40669F41.3060100@trash.net>
References: <5.2.1.1.2.20040327225419.01930cc8@kash.pobox.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,  mc@cs.stanford.edu,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ken Ashcraft <kash@stanford.edu>
In-Reply-To: <5.2.1.1.2.20040327225419.01930cc8@kash.pobox.stanford.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ken Ashcraft wrote:
> I'm from the Stanford Metacompilation research group where we use static 
> analysis to find bugs.  I'm trying a new technique, so I would 
> appreciate feedback on these error reports.
> 
> I found these errors by comparing implementations of the same 
> interface.  If functions are assigned to the same function pointer (same 
> field of some struct), I assume that the functions are called from the 
> same context.  Therefore, they should treat their incoming parameters 
> similarly.  In this case, before dereferencing pointers, the functions 
> should either check the pointers for null or not check the pointers for 
> null.  Any contradiction is an error.

This one is invalid. The iptables targets and matches check if they are
called from a valid hook. MASQUERADE for example can only be used in
the POST_ROUTING hook, and out should always be != NULL there.

Regards
Patrick

> There are 33 reports below.  Each report contains first a reference to 
> an EXAMPLE or a place where the parameter is checked.  That reference is 
> followed by a COUNTER(example) or a place where the parameter is not 
> checked.  After that is a code snippet from the counter example.  The 
> type of the function pointer (struct foo.bar) can be found in the 
> COUNTER field: [COUNTER=struct foo.bar-param_num].
> 
> Unfortunately, many of these errors had only one EXAMPLE and one 
> COUNTER.  It may be that some of the null checks are spurious.  You can 
> see the number of EXAMPLEs for a report in the [ex=i] field of the 
> COUNTER line.
> 
> Thanks for any feedback,
> Ken Ashcraft
> 
> ---------------------------------------------------------
> [BUG]
> /home/kash/interface/linux-2.6.3/net/ipv4/netfilter/ipt_MASQUERADE.c:128:masquerade_target: 
> ERROR:DEREF: Not checking arg out [COUNTER=struct ipt_target.target-2] 
> [fit=3] [fit_fn=1] [fn_ex=0] [fn_counter=1] [ex=2] [counter=1] [z = 
> -2.25170500701057] [fn-z = -4.35889894354067]
>     newsrc = rt->rt_src;
>     DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
>     ip_rt_put(rt);
> 
>     WRITE_LOCK(&masq_lock);
> 
> Error --->
>     ct->nat.masq_index = out->ifindex;
>     WRITE_UNLOCK(&masq_lock);
> 
>     /* Transfer from original range. */
> ---------------------------------------------------------
