From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Fri, 14 Jan 2005 19:00:53 +0100
Message-ID: <41E808D5.7070707@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<20050114083154.GG9070@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050114083154.GG9070@sunbeam.de.gnumonks.org>
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

>Nobody should ever load iptable_nat if it isn't actually used.  That's
>what module autoloading is about.  If a distribution does this, it is
>straight forward broken.
>
I was talking about autoloading or loading by other means. If the NAT
module is _present_ but not loaded, the get_features stuff needs to
assume it could be loaded any time and thus reserve memory in the
conntrack tuple. Or reallocate on module load.

>
>Also, I haven't seen this in practise so far, so it's not a valid
>optimization target from my point of view.
>
>
>>Sure, but helpers are slow anyway. The additional allocation is a one-time
>>effort, the two disjunct pieces of memory shouldn't hurt too much since
>>nf_conntrack is very large and covers multiple cache-lines already. Rusty
>>mentioned he got struct ip_conntrack down to ~150b, this makes it possible
>>to have a lot more active connections without exceeding the cache.
>>
>
>Ok, agreed for the helper case.  But my argument for NAT still holds, at
>least as far as I see.  Also, stuff like the accounting counters are a
>similar case.
>
>So maybe in the end we need 'features' for those, and ct_extend for
>helper related data?
>
I think helper data should go in ct_extend anyway. But since get_features
needs to allocate the memory for ip_nat_info anyways, I think we should go
with Rusty's propsal of two hardcoded slabcaches (IPv4/IPv6).

>>One more thing I was thinking about. If we put ip_conntrack in maintenance
>>mode and probably deprecate it at some time, I see little reason to remove
>>ipchains compat just now. Why not just let it fade out together with
>>ip_conntrack once nf_conntrack is in ? I haven't checked if it was because
>>of incompatibilities or required changes with Rusty's latest work, if so
>>that would be a good reason.
>>
>
>I don't have a particular favour for or against any of the proposed
>solutions.
>
Well, it's gone now anyway, lets just leave it this way :)

Regards
Patrick
