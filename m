From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: sparc64 match module - bug id 94
Date: Fri, 7 May 2004 08:30:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405070825520.9465-100000@filer.marasystems.com>
References: <409A521C.5020406@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <409A521C.5020406@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, Pablo Neira wrote:

> I thought about that possibility, it's an interesting hack, but I think 
> that the problem is much more specific, we have only this problem with 
> ipt_limit. Actually, when we have some internal match information which 
> is shared by some processors, we need to know which one is the selected 
> to work with. So, we could add a pointer to the master of internal match 
> data in struct ipt_entry_match. what do you think?

This is what it does and why there is problems. The problem is because the
size of that pointer is different between userspace and kernelspace on
SPARC64 with 32-bit userspace.

There is also an "unsigned long" which may be troublesome. This should be
a "u_int_32_t" I think. The pointer is however a little more troublesome
to convert to a fixed size datatype as it needs to match the size of a
pointer in kernelspace. The size of pointers in userspace is irrelevant as
it is only a placeholder in userspace. This calls for some #ifdefs.

Regards
Henrik
