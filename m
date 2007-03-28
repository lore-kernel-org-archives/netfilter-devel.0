From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ipset] Minor non-blocking "sleep" bugs
Date: Wed, 28 Mar 2007 19:09:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0703281855530.13447@blackhole.kfki.hu>
References: <513bde910703270005q2fe38dddp6ed5a4233a2c1c5d@mail.gmail.com>
	<513bde910703270656k3125b5bl1c20d063c622e45a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-973817216-1175101787=:13447"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: =?ISO-8859-1?Q?Isma=EBl_BALLO?= <isma.ballo@gmail.com>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <513bde910703270656k3125b5bl1c20d063c622e45a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-973817216-1175101787=:13447
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 27 Mar 2007, Isma=EBl BALLO wrote:

> I use ipset 2.2.9a on kernel 2.6.19.7 compiled (from kernel.org) with
> these options
> (iptables 1.3.6)
> I have a minor bug (non blocking) when I load ipsets ( it seems it
> happens when I have a large numbers of bindings)
>
> Mar 23 14:45:10 fwa01 kernel: BUG: sleeping function called from
> invalid context at mm/slab.c:3007
> Mar 23 14:45:10 fwa01 kernel: in_atomic():1, irqs_disabled():0
> Mar 23 14:45:10 fwa01 kernel:  [<c0158e6c>] kmem_cache_alloc+0x1b/0x55
> Mar 23 14:45:10 fwa01 kernel:  [<f89a77b8>] ip_set_hash_add+0xe7/0x142=20
> [ip_set]

That's due to a stupid bug of mine in the flag of kmalloc. The fixed=20
kernel source can be downloaded from the svn repository or as the=20
patch-o-matic-ng-20070328.tar.bz2 snapshot from the ipset webpage. Thank=20
you for the bugreport.

> and other : What can we chose best parameters for hashsize, probes, resiz=
e ?

There is no golden path: either you pay by memory for speed (i.e. large=20
hashsize, small probes, large resize percentage) or reversed. The defaults=
=20
of the iphash and nethash types are towards the other end, i.e. spare with=
=20
the memory requirement and loose thus speed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
--110391808-973817216-1175101787=:13447--
