From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 22:49:13 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703142242110.1199@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0703142207200.2643@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>,
	Amin Azez <azez@ufomechanic.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0703142207200.2643@bizon.gios.gov.pl>
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


On Mar 14 2007 22:41, Krzysztof Oledzki wrote:
>> 
>> - filter and mangle tables are merged
>
> Please don't. As you probably know "-j MARK" is not a terminating target, so
> after a "-j MARK" you often need additional "-j ACCEPT". The same is about TTL,
> SET, etc. But this ACCEPT does not mean that this packed is going to be
> accepted, only that a mangling process is finished.

Since MARK is proposed to anyway be available in the filter table (patch
posted by Sam at
http://lists.netfilter.org/pipermail/netfilter-devel/2007-March/027309.html
and comment
http://lists.netfilter.org/pipermail/netfilter-devel/2007-March/027310.html),
people will already have to deal with it when using MARK during filtering.

Since what I was proposing is a change big enough to break rulesets "hard"
(subjective wording), people sticking with the potentially new scheme
would anyway know what awaited them. 

>> - filtering comes early, even before nat
>> (so that, for example, packets do not needlessy be MARKed, mangled,
>> etc.)
>
> Hm, it is very useful to be able to filter packed based on a real
> destignation, that is only known _after_ dnat.

Somehow yes :-/
I'll post an updated png soon.


Jan
-- 
