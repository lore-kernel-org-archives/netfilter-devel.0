From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Tue, 01 Feb 2005 19:16:16 +0100
Message-ID: <41FFC770.2090401@trash.net>
References: <41F2FE92.6020603@cookinglinux.org>
	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>
	<41FF877D.4080309@trash.net>
	<20050201135423.GS6878@sunbeam.de.gnumonks.org>
	<41FF9024.3070101@trash.net>
	<6732.142.169.215.10.1107269629.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <6732.142.169.215.10.1107269629.squirrel@142.169.215.10>
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

Samuel Jean wrote:

>On Tue, February 1, 2005 9:20 am, Patrick McHardy said:
>  
>
>>ipt_hashlimit already uses %ld. Samuel, what problem are you seeing
>>exactly ?
>>Is it negative times or wrapped times ?
>>    
>>
>
>I see wrapped time.
>
>I've tried making it print negative values, but seems I can't get
>unsigned operations to result in a signed value. Is that right ?
>
No. On my system va_arg (used by vsnprintf, used by seq_sprintf)
behaves strangely. From vsnprintf:

                else if (qualifier == 'l') {
                        num = va_arg(args, unsigned long);
                        if (flags & SIGN)
                                num = (signed long) num;

On my system (x86_64, gcc-3.3.5) va_arg returns 2^32-1 for -1, but it
should return 2^64-1. Are you seeing this problem on a 32bit or a 64bit
machine ?

Regards
Patrick
