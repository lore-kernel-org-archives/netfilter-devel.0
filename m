From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH]: ipset kernel memory allocations
Date: Fri, 18 Nov 2005 08:49:26 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0511180847060.11854@blackhole.kfki.hu>
References: <200511180053.jAI0rd1S031000@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kadlec@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jones Desougi <jones@ingate.com>
In-Reply-To: <200511180053.jAI0rd1S031000@usagi.ingate.se>
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

On Fri, 18 Nov 2005, Jones Desougi wrote:

> The kernel ipset code in patch-o-matic-ng has code
> like this in three places:
>
> tmp = kmalloc(...);
> if (!map) { ... }
>
> i.e. checking the wrong variable. Map cannot be false
> here, it is used in the size calculation for kmalloc.
> Probably all of these originate from a single source.
> The patch below fixes them.

Nice example of a copy-paste bug handed down from one module to the next
one :-(. Thank you the good catch and the patch!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
