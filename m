From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: to solve the performance problem of netfilter
Date: Thu, 18 Dec 2003 13:02:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0312181253130.23897-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0312171753560.18408-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	Roberto Nibali <ratz@tac.ch>, <tady@gmx.net>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312171753560.18408-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Dec 2003, Henrik Nordstrom wrote:

> But still having benchmarks showing how much of a penalty NAT really is
> would inedeed be interesting. To give interesting results wrt where the
> bottlenecks of NAT are the following set of benchmarks would be good I
> thinkg:
>
>   - No netfilter
>   - Just iptable_filter loaded (no rules)
>   - Just ip_conntrack loaded
>   - Just ip_conntrack + iptable_nat loaded
>   - Some simple NAT rules added
>
> Using each of the following profiles
>
>   * Lots of small TCP sessions such as a syn flood to a closed port always
> responding with RST (and no RST rate filtering on the targeted host)
>
>   * A few sessions (TCP or UDP) pushing large packets
>
>   * A few sessions (TCP or UDP) pushing small packets
>
>   * Lots of concurrent sessions forcing the NAT to resolve addressing
> overlaps, for example testing with a fixed source port from a wide range
> of source IP address and using SNAT to a single fixed address.

Next year January we'll repeat our testings with the same targets as you
listed. But I'd like to add architectural testings as well: sparc64
besides i386 at least.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
