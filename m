From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Fri, 31 Aug 2007 18:19:28 +0200
Message-ID: <46D83F90.5060600@trash.net>
References: <46D06522.2090509@hotpop.com>
	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>
	<46D6DEAF.9010009@hotpop.com>
	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>
	<46D824EA.1060406@hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D824EA.1060406@hotpop.com>
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

Peter Riley wrote:
> Jan Engelhardt wrote:
>> On Aug 30 2007 08:13, Peter Riley wrote:
>>> Patrick McHardy wrote:
>>>> I count 132 occurences of nfcache (a few are in headers that must stay
>>>> though). I'll happily apply a patch that kills them all.
>>>>
>>> Patrick, yes I get 134 occurrences on 132 lines in current svn.
>>> The breakdown appears to me to be:
>> [...]
>>
>> Do we still need nfcache anyway?
>>
> 
> It seems to me there are three options....
> 
> [...]
>    Forget about ass-backwards compatibility and purge your cache!


We don't care about binary compatiblity between different userspace
releases. All we care about is not breaking userspace<->kernel
compatiblity.

> Alter the
>    iptables extension API in xtables.h so the function prototypes for ->init()
>    and ->parse() stop causing all the crap to be passed. But leave the really
>    hard ob-struct-ion in your ipt_entry. It may be too painful to reach that
>    deep down into the kernel to remove it.
> 
>    Then, you can flush out all of those toxins in the extensions and cleanse
>    the calls to them in iptables.c.  Those nasty blockages that iptables can't
>    purge because of the (a->nfcache != b->nfcache) comparison can be rooted out
>    too (as in #1).
> 
>    But let's be realistic, the fresh healthy feeling won't last forever.
>    The next time you come down with a bug and really need to make a dump,
>    dump_entry() should still be able to pass the bits of cache out of your
>    ipt_entry.  At least keep this bit:  printf("Cache: %08X ", e->nfcache);


The kernel doesn't use it, its *always* zero.

> Behind curtain #3: Is that a goat? a gnu?  No, a penguin!!
>          (Plus we'll let your friends can keep their enemas.  Penguin gets one too!)
> 
>    Go deeper, purge every last one of the 134 stinky bits of nfcache! The iptables
>    headers change as before, and now kernel headers ip_tables.h and ip6_tables.h
>    can drop nfcache in struct ipt_entry/compat_ipt_entry/ip6t_entry.  Even get rid
>    of the #define NFC_* in ./include/linux/netfilter*.h.  Hold nothing back...

Thats not possible since it breaks userspace <-> kernel compatiblity.

I prefer to get rid of all of them where possible, but if you want
to do only #1, thats also fine.
