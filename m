From: Martijn Lievaart <m@rtij.nl>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 13:36:41 +0200
Message-ID: <425D0449.4070306@rtij.nl>
References: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>	<20050413071427.GC16534@oknodo.bof.de>	<20050413152307.0312.LARK@linux.net.cn>	<425CEFE3.2010200@rtij.nl>
	<425CFC0F.5010006@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425CFC0F.5010006@outerspace.dyndns.org>
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

Jonas Berlin wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Quoting Martijn Lievaart on 2005-04-13 10:09 UTC:
>  
>
>>The more I think about it, the more I like it. This in effect gives
>>multiple targets. Now someone is bound to come up with the idea that it
>>should also be possible to write
>>
>>iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 -j RETURN
>>
>>as syntactic sugar. This makes a lot of sense, but is not needed. Let
>>some front-end tool compile the rules to the --previous form, don't
>>burden netfilter with this, unless it can be implemented very easily,
>>which I don't think it can. The semantics are to murky.
>>    
>>
>
>Did you see the mail from me on Mon, 11 Apr 2005 09:47:41 +0000 ? It's
>the first email with the subject
>   "Re: About matching (also was: Multiple Targets)
>
>I wrote some thoughts on how multiple targets could be implemented.
>
>Regarding the rule byte & packet counters, I guess they would be updated
>regardless of how the actions turn out.. (I guess that's how it works
>now too)
>  
>

:-) So back full circle :-) I read it, but lost track of it in the chain.

I'm still not convinced we need this, but it /could/ be implemented 
using an (then internal) --previous match.

IF (and I'm still not convinced it's a good idea) this is implemented, 
there are three ways to do it as I see it now:
1) Either implement --previous wholy in the kernel and make the multiple 
targets part of the kernel interface.
2) Or make this syntactic sugar in the iptables binary.
3) Or don't use any form of --previous and implement it differently in 
the kernel.

1) and 3) are really equivalent from a users point of view, also from 
the viewpoint of binary compatibility. It's just an implementation 
detail. OTOH 2) can be implemented sanely in all the binaries (iptables, 
-save and -restore) but will make the kernel API divert semantically 
from the commandline API. I'm not sure we want that. I still would 
advocate to make an explicit --previous match with semantics as outlined 
in my previous mail. It implements the functionality we want (as Patrick 
points out in another mail you would need an -j RETURN --up 2 to 
implement the same, it can also be done with a GOTO).

M4
