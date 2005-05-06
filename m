From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Just starting with libipq
Date: Fri, 06 May 2005 12:50:17 +0000
Message-ID: <427B6809.4060300@outerspace.dyndns.org>
References: <427A29A0.8020502@reading.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
In-Reply-To: <427A29A0.8020502@reading.ac.uk>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Duncan Godfrey on 2005-05-05 14:11 UTC:

> I was wondering if someone would be able to help me, Im just starting
> out with some libipq development and Im trying to compile some example
> source code from a tutorial site (I have compiled the source on the man
> page an it worked fine).
> 
> Everytime I compile it with gcc -o quick quick.c -libpq, I get the
> following errors:

- -lipq not -libipq :)

> quick.c:56: error: dereferencing pointer to incomplete type
> quick.c:58: error: dereferencing pointer to incomplete type

>      struct iphdr *ip = (struct iphdr*) m->payload;
>
>      struct tcphdr *tcp = (struct tcphdr*) (m->payload + (4 * ip->ihl));

The error message means gcc does not know of a struct/union that you are
using. So it has to be either the "m" variable or then "ip" and "tcp"
variables. In this case, it's the latter, you are missing these includes:

#include <linux/ip.h>
#include <linux/tcp.h>

Add them and it should work. Good luck :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCe2gHxyF48ZTvn+4RAjDdAJ0b2SMjV0xh/l84RBDdU4t+ClkjewCdFPhL
9lrHlGEIm1MBp68PkOQYizI=
=n7Wy
-----END PGP SIGNATURE-----
