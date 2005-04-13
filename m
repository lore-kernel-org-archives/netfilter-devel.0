From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 18:45:47 +0800
Message-ID: <20050413182822.0317.LARK@linux.net.cn>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <425CEFE3.2010200@rtij.nl>
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

Hi Martijn Lievaart,


On Wed, 13 Apr 2005 12:09:39 +0200, Martijn Lievaart <m@rtij.nl> wrote:

> 
> This is so non-intuitive it makes my head hurt. Also:
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION1
> iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
> iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
> 
> If delete the first
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
> iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
> 
> Now reinsert the first:
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION1
> iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- NO DUP MATCH ANYMORE
> iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
> 
> 

Good catch. I am convinced.

> which is bad when any of the matches have side effects.
> 
> IMO a better course of action is to only allow deletion of the last match(es) in a "previous-chain", which could be the complete chain. So given the example above:
> 
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION1
> iptables -A SOMECHAIN --previous -j ACTION2
> iptables -A SOMECHAIN --previous -j RETURN
> 
> This would only allow to delete the third, the third and the second or all three rules before a commit occurs. These semantics would also allow nicely for ! --previous.
> 

Good point. But insertion before the first?

And how about

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN !--previous -j ACTION3
iptables -A SOMECHAIN --previous -j RETURN

The ! --previous semantics is confusing in this case.


> The more I think about it, the more I like it. This in effect gives multiple targets. Now someone is bound to come up with the idea that it should also be possible to write
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 -j RETURN
> 
> as syntactic sugar. This makes a lot of sense, but is not needed. Let some front-end tool compile the rules to the --previous form, don't burden netfilter with this, unless it can be implemented very easily, which I don't think it can. The semantics are to murky.
> 

Yes, this sound good.


-- 
  lark
