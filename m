From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ROUTE target fixes for --iif
Date: Wed, 5 May 2004 19:26:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405051925410.31016-100000@blackhole.kfki.hu>
References: <20040505144333.GA17752@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Cedric de Launois <delaunois@info.ucl.ac.be>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20040505144333.GA17752@ti64.telemetry-investments.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 5 May 2004, Bill Rugolsky Jr. wrote:

> On Wed, May 05, 2004 at 02:04:19PM +0200, Cedric de Launois wrote:
> > Concerning the TTL, what happens if you re-inject the packet
> > on the same interface ? If you don't decrement the TTL, you
> > might introduce a loop, no ? Could you check this ?
>
> D'oh!  You are of course correct that it will loop (and I've verified that
> it does).  I had previously been using
>
> 	iptables -t mangle -A PREROUTING -i hdlc\+ -j TTL --ttl-inc 1
>
> to get the desired behavior, but changed ROUTE because the above seemed
> inelegant.   The original behavior is indeed the safer course.  The attached
> patch backs out the TTL change.

Patch is applied. Quick fixes are highly appreciated. :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
