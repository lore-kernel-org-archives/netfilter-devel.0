From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: New match ipt_geoip
Date: Fri, 5 Nov 2004 12:50:41 -0500 (EST)
Message-ID: <4427.142.169.215.10.1099677041.squirrel@142.169.215.10>
References: <41899D17.7060800@cookinglinux.org>   
	<20041105104217.GD5606@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
In-Reply-To: <20041105104217.GD5606@sunbeam.de.gnumonks.org>
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

On Fri, November 5, 2004 5:42 am, Harald Welte said:
Dear Harald.

> (although I
> generally dislike the concept, since it never works, especially in the
> case of tunnels in multinational corporations/organizations...)

I agree.

> On the other hand, I think there is significant overlap between your
> ipt_geoip.c kernel part and the ippool/ipset match.

What kind of overlap ? Is there incompatibilitie issue ? or is it
functionnality's similarity issue ?

> Thus, I argue, rather than inventing a new patch for the kernel, this
can > be done in userspace by configuring a pool of address ranges.

Yes, that could make sense if ipt_geoip.c was incompatible (conflicting)
with other modules. Else, I think we might consider using it.

Let me show you how I see it.


Arguement #1:
When someone insert rules like :

-m geoip --src-cc CA
-m geoip --src-cc US
-m geoip --src-cc DE
-m geoip --src-cc JP
-m geoip --src-cc CH

there's sum of about 20 000 subnets for those countries.

If we use ipt_pool as the subnets matcher, everytime a packet
hit one of previous rules, ipt_pool must seek through its whole
pool. (Do I am wrong ?) If that user also use ip_pool for other
things than geolocation matching, the pool size increase.
Or maybe ipt_pool handles multiple pool ? (forgive my ignorance)

Let's continue.
If we use ipt_geoip as the subnets matcher, everytime a packet
hit one of the previous rules, ipt_geoip knows exactly where
the subnets' pool is.

Argument #2:

It is possible to match up to 15 countries per rule.

-m geoip --src-cc ca,us,jp,ch,de,ad,a1,a2,...

How shall ipt_pool handle that ?
Is it going to create 15 diff pools or just one with all those subnets.
And if someone insert another rule with same countries, is ipt_pool going
to increment a refcount for the pool ?

In the other way, ipt_geoip is allocating ressources on a per-rule basis.
If ressources already exist for a given country, a refcount is simply
increased. If there's no more rule using that ressource, it is simply
freed.


Argument #3:

Nicolas and me are working on a caching system in ipt_geoip. I'm sure it'=
s
going to decrease latency a bit. So, would be nice to keep that module.


Please, let me know your thought.

Thanks a lot, chief Harald :-)

Samuel
CookingLinux TM
