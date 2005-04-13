From: Martijn Lievaart <m@rtij.nl>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 13:17:52 +0200
Message-ID: <425CFFE0.1000803@rtij.nl>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050413182822.0317.LARK@linux.net.cn>
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

Hi Jian (or is Wang your first name?)

Wang Jian wrote:

>>IMO a better course of action is to only allow deletion of the last match(es) in a "previous-chain", which could be the complete chain. So given the example above:
>>
>>
>>iptables -A SOMECHAIN -m this -m that -j ACTION1
>>iptables -A SOMECHAIN --previous -j ACTION2
>>iptables -A SOMECHAIN --previous -j RETURN
>>
>>This would only allow to delete the third, the third and the second or all three rules before a commit occurs. These semantics would also allow nicely for ! --previous.
>>
>>    
>>
>
>Good point. But insertion before the first?
>  
>

Yes, that cannot be (easily) automated. And that's a good point, it 
really screws up the whole idea of looking at this as if there are 
multiple actions on a single rule that can easily be manipulated. But if 
we lose that last requirement. Netfilter is not easy, we should not make 
it seemingly easy while actually making it more difficult. Rules using 
--previous cannot be seen apart form the rule they reference. In 
principle, they should be manipulated together. Being able to manipulate 
(delete, insert) rules inside such a "previous-chain" should be looked 
upon as a bonus.

I realise this makes the first rule special. It defines the match for 
the whole "previous-chain", but also gives the first action. If this 
really bothers you, you can always do:

iptables -A SOMECHAIN -m this -m that
iptables -A SOMECHAIN --previous -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN --previous -j RETURN

But how is that different from:

iptables -A SOMECHAIN -m this -m that -j TMPCHAIN
iptables -N TMPCHAIN
iptables -A TMPCHAIN -j ACTION1
iptables -A TMPCHAIN -j ACTION2

The only real advantage I can think of is that using --previous makes it easier to generate rules automatically. I know I could use it in my rule generator (not yet ready for distribution, but in production here). It also has the slight advantage of being slightly easier to read. However, I guess it is slightly less efficient than using temporary chains, especially if the condition does not match in general.

Also, rethinking deletion, the only requirement is that  one cannot 
commit deletion of a rule if  another rule points to it using 
--previous. What this implies depends on what you mean by points to, see 
below.

>And how about
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN --previous -j ACTION2
>iptables -A SOMECHAIN !--previous -j ACTION3
>iptables -A SOMECHAIN --previous -j RETURN
>
>The ! --previous semantics is confusing in this case.
>
>  
>

This is something that has to be decided upon. Does --previous match the 
previous rule, or the previous non-previous rule (iow the start of the 
--previous chain). Intuitively I would say the latter.

In that case your rules would be equivalent to:

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN --previous -j RETURN
iptables -A SOMECHAIN -j ACTION3

If --previous matches the previous rule, not the start of that "previous chain) the RETURN is executed if ACTION3 is executed (iow if the first rule did not match). This can be translated to the latter semantics as:

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN !--previous -j ACTION3
iptables -A SOMECHAIN !--previous -j RETURN


Which I find clearer.

Also, if --previous "points to" the first rule of the "previous-chain" we can allow deletion of any but that first rule (or the complete chain). Otherwise you're stuck with "only delete at the end" semantics (such as I described previously).



>>The more I think about it, the more I like it. This in effect gives
>>multiple targets. Now someone is bound to come up with the idea that it
>>should also be possible to write
>>
>>    
>>
>>iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 -j RETURN
>>
>>
>>as syntactic sugar. This makes a lot of sense, but is not needed. Let some front-end tool compile the rules to the --previous form, don't burden netfilter with this, unless it can be implemented very easily, which I don't think it can. The semantics are to murky.
>>
>>    
>>
>
>Yes, this sound good.
>
>  
>

Especially thinking about !--previous makes this burdensome, but guess 
what, it can be done!

iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 ! -j ACTION3 

Hmmmmm, I'm not convinced we should take this route. It looks nice at first, but how should this be printed? Manipulated?

M4
