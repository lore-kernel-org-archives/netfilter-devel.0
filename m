From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Question about iphash and nethash
Date: Sun, 9 Jul 2006 23:12:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0607092255100.12008@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0607091748110.25841@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0607091748110.25841@bizon.gios.gov.pl>
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

On Sun, 9 Jul 2006, Krzysztof Oledzki wrote:

> I noticed that in my firewalls I very often need to use both iphash and
> nethash when I need to match set of addresses, because such lists contains
> both /32 hosts and, for example, /24 networks. This requires additional
> number of rules - 2x or even 4x when I need to match both src and dst.
> What is the reason that it is not possible to use /32 on nethash? I may
> guess that iphash is probably faster than nethash so maybe a possiblity to
> match a lists of setnames (eg: -m set --set set1,set2 src) is better?

To store an IP(v4) address requires 32 bits. A network address, which
consists of an IPv4 address and mask is (usually) stored in 2x32 bits.
What is special in nethash is that it stores a network address in 32 bits
but the method simply excludes the possibility to store pure IPv4
addresses in a nethash kind of set.

Matching in a nethash type of set is approximately so many times slower
than a matching in an iphash set as the number of *different* size of
network addresses stored in the set.

Currently you cannot "chain" the matching of sets as you wrote: a union
type of set is underway in which you'll be able to "store" different kind
of sets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
