From: Philip Craig <philipc@snapgear.com>
Subject: Re: pptp patch breaks nat-reservation patch (on ppc-machines)
Date: Fri, 09 Jul 2004 19:09:45 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40EE60D9.1090608@snapgear.com>
References: <BDEHJGPIKNLKJJBCCFPLOEIOCOAA.listuser@sally.epygi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <BDEHJGPIKNLKJJBCCFPLOEIOCOAA.listuser@sally.epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Markus,

Markus wrote:
> HiHo!
> 
> Playing with pptp and nat-reservation patches I
> stumbled upon the following phenomena:
> (viewed on PPC, not entirely sure if same goes
> for Intel machines)
> 
> A)
> The pptp-patch changes the union ip_conntrack_manip_proto
> in ip_conntrack_tuple.h (including but not limited to):
>   u_int16_t all -> u_int32_t all
> 	(see end of mail for complete struct)
> 
> I understand the reason for this, but isn't it dangerous?

It is dangerous only if there is broken code that doesn't expect this,
so the solution is to fix the broken code.  There is no other solution
that I can see; we need to add a 32 bit field to as part of u.all, so
u.all has to grow.

>   1. Anyone who is using this struct as a memory map
>      (say somewhere fill it with .udp.port but access it
>      with .all) will get an alignment problem (at least
>      on PPC-architecture). Well actually this is
>      what breaks the nat-reservation-patch.

Where exactly in the nat reservation patch is the problem?  I
couldn't see anything that would cause an alignment problem, although
there were a few debug statements that were passing u.all to ntohs().
I think those debug statements should use DUMP_TUPLE() instead.

The other thing I noticed is that some places treat manip.u.all and
tuple.dst.u.all as the same size, which is wrong.  tuple.dst.u.all is
actually 64 bits with the pptp patch.  clashing_ct_cmp()  incorrectly
compares them, and _ip_nat_reserved_new_hash() creates a tuple based
on a manip.

I think invert_tuplepr() can be used to fix both of these, although
I haven't looked too closely.  Basically, you need to call the
invert_tuple() function from ip_conntrack_protocol, since it is the
only thing that knows how to invert correctly.

> 	Is this the only patch that uses .all?

No, although most other places that use it will be setting it to 0.

>   2. Filling the union with one of the structs 
>      should lead to uninitilized parts. say:
> 	  ip_conntrack_manip_proto x;
> 	  x.tcp.port = 0;
>         x.all == 0 -> need not be true!
>      Or am I missing something?

If you need u.all to be zero, then you need to set it to zero.
Assuming that u.tcp.port = 0 will also set u.all is wrong.

> Same problem with struct ip_conntrack_tuple.
>  
> B) 
> Now i was wondering why this conflict doesn't occur more often:
> A quick grep for .u.all showed that there are only
> three kinds of usage (at least for the patches i use):
>     1) used by the pptp patch
>     2) used by the nat-reservation patch
>     3) used by means of hashing
>           ( alignment is not a problem here. Put in something wrong
>             and you will find the exact wrong structure again, it is
> 		still unique. Initialization should be a problem though ;)

There are other places that your grep did not pick up, such as
the following in ip_conntrack_ftp.c:

exp->tuple = ((struct ip_conntrack_tuple)
                 { { ct->tuplehash[!dir].tuple.src.ip,
                     { 0 } },
                   { htonl((array[0] << 24) | (array[1] << 16)
                           | (array[2] << 8) | array[3]),
                     { .tcp = { htons(array[4] << 8 | array[5]) } },
                     IPPROTO_TCP }});

> I may be overlooking something, but i would assume that the
> pptp-patch as it is right now, potentially disturbs other patches, at least
> those that use a mixture of access (.all and .tcp/.udp..).
> Right now it seems that only nat-reservation is concerned.

There were a few problems when the pptp patch was first developed,
but those have mostly been fixed up.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
