From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Again, HOPLIMIT inconsistency
Date: Fri, 5 Mar 2004 12:24:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403051223420.6328-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0403051150320.7448-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403051150320.7448-200000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Mar 2004, Henrik Nordstrom wrote:

> 1. Part of the linux.patch for CONNMARK has been moved to a .ladd file,
> and needs to be removed from linux.patch. Patch patch atteched.

OK, fixed.

> 2. ipv6 TRACE 2.4 .ladd files looks misplaced. From what I can tell these
> belong in net/ipv6/netfilter/, not net/ipv6/

In cvs the files are in the right directory. Something left over in your
tree?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
