From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_dstlimit spinlock fixup
Date: Mon, 23 Aug 2004 22:49:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <412A5852.4050104@trash.net>
References: <20040822153348.GA20301@linuxace.com> <412A3BAA.6000708@trash.net> <20040823201231.GA2046@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040823201231.GA2046@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>On Mon, Aug 23, 2004 at 08:47:06PM +0200, Patrick McHardy wrote:
>  
>
>>Phil Oester wrote:
>>
>>    
>>
>>>Since ipt_dstlimit makes use of MUST_BE_LOCKED macro, compiling
>>>without CONFIG_NETFILTER_DEBUG causes errors.  Fix below.
>>>
>>>      
>>>
>>Jozsefs conntrack_locking patch has the same problem, I wonder if we
>>should introduce a spinlock_debug_t (if that is not taken yet) or
>>better yet, kill lockhelp.h.
>>    
>>
>
>Or option 3: remove the MUST_BE_LOCKED users in both files.  lockhelp
>does seem to be, er, helpful in some cases.
>  
>
With the conntrack patches we need to remove it from ip_conntrack_core.c
and ip_nat_core.c, after that there really would be no readon for keeping
it at all. There isn't any readon even today, spinlock.h already offers
the same features.

Regards
Patrick

>Phil
>
>  
>
