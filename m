From: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Subject: Re: ip_tables.h does not compile when using g++
Date: 16 Sep 2002 14:12:56 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032185577.458.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

>
> why does it have to be (char *) ? There are no characters involved,
> hence it (in the spirit of this gcc extension) should be (void *).
>
> The typecast to struct ipt_entry_target is correct, however.
>
> Does it compile with 
>
> return ((struct ipt_entry_target *)((void *)e + e->target_offset));
>
> If yes, I will submit this modified version of  your patch.

No, it does not compile with (void *) at all. Here is the error message
from gcc-3.2 when compiling using g++ :

ip_tables.h: In
   function `ipt_entry_target* ipt_get_target(ipt_entry*)':
ip_tables.h:295: pointer
   of type `void *' used in arithmetic


I agree that the (char *) looks a little confusing but I dont know
what else to use.

Also, just below the function 'ipt_get_target' there is 2 macros
defined that use the same (void *) cast. These casts should also
be patched.

Regards,

Scott.
