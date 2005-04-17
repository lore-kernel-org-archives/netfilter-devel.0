From: Patrick McHardy <kaber@trash.net>
Subject: Re: Modifications to netmap target
Date: Mon, 18 Apr 2005 00:09:49 +0200
Message-ID: <4262DEAD.3000101@trash.net>
References: <27594E8BA9D5CA458F5EF87D88B6B48F1D4F@pxtvjoexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Gary W. Smith" <gary@primeexalia.com>
In-Reply-To: <27594E8BA9D5CA458F5EF87D88B6B48F1D4F@pxtvjoexd01.pxt.primeexalia.com>
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

Gary W. Smith wrote:
> After talking to Jason over on the netfilter users list about netmap target I found that it doesn't support the output chain of nat. 
>  
> I was looking through the code and found that it only registers itself with the pre and post route chains.  I was wondering if adding support for the output chain was as simple as adding the hook for the local_out and then ensuring that the correct modifications are made.  The following looks logically correct from looking into some of the source code for other modules.  Would more be required to make the ouput nat work with netmap?
>  
> Example.
>         if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING))) {
>                 DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
>                 return 0;
>         }
> to:
>         if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) | (1 << NF_IP_LOCAL_OUT) )) {
>                 DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
>                 return 0;
>         }
>  
> and 
>    if (hooknum == NF_IP_PRE_ROUTING)
>                 new_ip = (*pskb)->nh.iph->daddr & ~netmask;
>         else
> to:
>    if (hooknum == NF_IP_PRE_ROUTING || hooknum == NF_IP_LOCAL_OUT)
>                 new_ip = (*pskb)->nh.iph->daddr & ~netmask;
>         else
>  
> I put the above changes in and compiled and I was able load the table but I'm not sure what the other imacts might be.  Comments would be greatly appreciated.

Should work fine. Can you submit a patch? But please break
the hook_mask & ... line at 80 characters.

Regards
Patrick
