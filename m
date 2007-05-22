From: Darren.Reed@Sun.COM
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 16:55:07 -0700
Message-ID: <465382DB.3080106@Sun.COM>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
	<20070522064613.GA27619@oknodo.bof.de> <4653578C.3070407@Sun.COM>
	<20070522211404.GC24990@ipom.com>
	<1179874698.18674.22.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org, Phil Dibowitz <phil@ipom.com>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <1179874698.18674.22.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:

>tis 2007-05-22 klockan 14:14 -0700 skrev Phil Dibowitz:
>
>  
>
>>Darren, you're correct, this is definitely needed. If IPF and IPtables and
>>everyone else all used a common core kernel-userspace API, with a standard
>>library on top of it, that would be awesome.
>>    
>>
>
>As things is today I am not sure how this would work in a general sense
>for what is proposed. The way you structure rules is quite different in
>the different firewall implementations.
>
>But sure, for things like connection tracking and related events it's
>surely doable. Also, writing a generic firewall ruleset "compiler" which
>can translate to ipf, iptables and a few others is doable, but the
>actual installed ruleset will need to be somewhat different in both
>structure and syntax in the different implementations, not only syntax.
>
>Having an API which says things like "Add a rule to accept this kind of
>traffic" is only possible cross the different firewall implementations
>if there also is a defined firewall ruleset structure requirement
>defining suitable places in the ruleset where this API can make it's
>modifications.
>  
>

Which means that coming up with a design that works won't
necessarily be a slam-dunk.

Darren
