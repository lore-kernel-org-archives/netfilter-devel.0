From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: New match ipt_geoip
Date: Sat, 6 Nov 2004 00:27:06 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0411052334590.21375@blackhole.kfki.hu>
References: <41899D17.7060800@cookinglinux.org>
	<20041105104217.GD5606@sunbeam.de.gnumonks.org>
	<4427.142.169.215.10.1099677041.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <4427.142.169.215.10.1099677041.squirrel@142.169.215.10>
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

On Fri, 5 Nov 2004, Samuel Jean wrote:

> > Thus, I argue, rather than inventing a new patch for the kernel, this
> can > be done in userspace by configuring a pool of address ranges.
>
> Yes, that could make sense if ipt_geoip.c was incompatible (conflicting)
> with other modules. Else, I think we might consider using it.
>
> Arguement #1:
> When someone insert rules like :
>
> -m geoip --src-cc CA
> -m geoip --src-cc US
> -m geoip --src-cc DE
> -m geoip --src-cc JP
> -m geoip --src-cc CH
>
> there's sum of about 20 000 subnets for those countries.
>
> If we use ipt_pool as the subnets matcher, everytime a packet
> hit one of previous rules, ipt_pool must seek through its whole
> pool. (Do I am wrong ?) If that user also use ip_pool for other
> things than geolocation matching, the pool size increase.
> Or maybe ipt_pool handles multiple pool ? (forgive my ignorance)

[Let's speak about ipset which is based on ippool.]

In the case of a bitmap type of set (ipmap/portmap/macipmap), there is no
seeking in the set: just one bit comparison is required to find an entry.
In the case of a hash type of set (iphash and the planned nethash), a
limited number of hashing is required.

Of course you can define multiple pools/sets, like one for CA, US, etc.

> Argument #2:
>
> It is possible to match up to 15 countries per rule.
>
> -m geoip --src-cc ca,us,jp,ch,de,ad,a1,a2,...

No, that's not possible. But it's an interesting idea, to introduce
supersets...

> How shall ipt_pool handle that ?

In ipset you can define "multilevel" matching. Let's say we have subnets
scattered along in bigger networks:

/16			/24
1.1.0.0			1.1.1.0
			1.1.8.0
			....

2.2.0.0			2.2.1.0
			2.2.4.0
			...

....                    ....

Then you can define sets for the naturally grouped heaps: one for the /16
blocks, say toplevel, one for the /24 subnets in 1.1.0.0/16 say set-1.1,
one for the /24 subnets in 2.2.0.0/16 say set-2.2, etc. Then one can
bind the set elements in toplevel to the corresponding subnet sets:

1.1.0.0 -> set-1.1
2.2.0.0 -> set-2.2
...

and then the match

-m set --set toplevel src,src

will match any source IP address, for which the IP masked by /16 can be
found in set toplevel *and* the IP masked by /24 can be found in the set
according to the binding belonging to the element found in set toplevel.

> Is it going to create 15 diff pools or just one with all those subnets.
> And if someone insert another rule with same countries, is ipt_pool going
> to increment a refcount for the pool ?

If the same pool/set used in multiple rules, a refcount is incremented.

> Nicolas and me are working on a caching system in ipt_geoip. I'm sure it's
> going to decrease latency a bit. So, would be nice to keep that module.

I just wanted to comment the capabilities of ipset/ippool.

I fully support the goal to unify related matches/targets in netfilter - I
share the feeling we have too many similar of them. Probably ipt_geoip
could be expressed and replaced by appropriate ippool/ipset definitions.

However, without peeking into the code of ipt_geoip, the idea seems to be
quite special. The feature is compact, which can be grasped by the users
easily, without the need to apply/tune special recipes/rules/settings.
So it'd worth to add it to pom-ng, I believe.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
