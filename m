From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Fri, 14 Jan 2005 03:45:44 +0100
Message-ID: <41E73258.7030002@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050110212807.GZ18568@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Mon, Jan 10, 2005 at 09:31:45PM +0100, Patrick McHardy wrote:
>  
>
>>>The infrastructure is there in the patch to support IPv4/IPv6 conntrack
>>>separatedly in spite of the common code and not to waste so many bytes at
>>>every IPv4 connections for the sake of supporting IPv6.
>>>      
>>>
>>You mean the get_features stuff and seperate caches ? I'm don't like this
>>part very much, I thing Rusty's "structure extension stuff" (ct_extend)
>>is a nicer way to do this, although its probably not useable for the tuples.
>>    
>>
>
>Unfortunately I have to disagree.  I think I pointed it out in an
>earlier email, but I'm not sure whether it was on IRC or whether you've
>been on the list of recipients.
>
Hmm, I can't recall talking about this earlier.

>the nf_conntrack approach of having multiple slab caches of differently
>sized conntrack structures is better from a performance point of view.
>
>If you look at the typical applications, people will usually
>
>a) either use NAT on most/all of their connections
>b) or not use NAT on any of their connections
>
>Now why don't they (the 'b' users) recompile their kernel? Because they
>use vendor-kernels, and they compile with everything enabled.
>
>So what we end up if we use rusty's scheme for nat private data, is that
>we have at least one additional allocation, and two disjunct seperate
>pieces of memory (which will probably also introduce yet another cache
>miss).   This is acceptable for rare exceptional cases, not for 99.9% of
>your connections.
>
>So even if Rusty's architecture and API is cleaner, I'm very much in
>favour of the nf_conntrack design and Yasuyuki's current
>implementation.
>  
>
But unlike ct_extend, the get_features stuff is very unflexible. The
way it is currently implemented it only works for a single dynamically
allocated part without leaving holes, and it even it if could handle more,
they all need to be determined at allocation time, so a worst-case 
assumption
has to be made for anything depending on the ruleset. This is especially
a concern with modules and distribution-kernels, NAT could be loaded at any
time, so the memory needs to be allocated in advance.

>Now you can argue about conntrack/nat helper private data.  Here my
>argument is weaker, since normally you have something like < 1% of your
>connections with a helper.  For this I would be willing to accept the
>additional allocation and whatever.
>
>But, then think of a firewall in front of an FTP (IRC/...) Server, and
>your traffic pattern immediately looks like 50% of your connections (not
>talking about traffic) have helper private data... and my argument
>becomes stronger again.
>  
>
Sure, but helpers are slow anyway. The additional allocation is a one-time
effort, the two disjunct pieces of memory shouldn't hurt too much since
nf_conntrack is very large and covers multiple cache-lines already. Rusty
mentioned he got struct ip_conntrack down to ~150b, this makes it possible
to have a lot more active connections without exceeding the cache.

>>I think we should put ip_conntrack in maintenance mode, than we can
>>resync nf_conntrack and make changes like this before we submit it.
>>    
>>
>
>At last, we again agree :)
>  
>
One more thing I was thinking about. If we put ip_conntrack in maintenance
mode and probably deprecate it at some time, I see little reason to remove
ipchains compat just now. Why not just let it fade out together with
ip_conntrack once nf_conntrack is in ? I haven't checked if it was because
of incompatibilities or required changes with Rusty's latest work, if so
that would be a good reason.

Regards
Patrick
