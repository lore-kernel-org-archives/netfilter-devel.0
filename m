From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
	first preview
Date: Wed, 19 Jan 2005 09:56:15 +0100
Message-ID: <20050119085615.GD10200@eychenne.org>
References: <20050119004332.GA12629@roonstrasse.net>
	<Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org,
	Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
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

On Wed, Jan 19, 2005 at 09:30:38AM +0100, Jozsef Kadlecsik wrote:

> On Wed, 19 Jan 2005, Max Kellermann wrote:

> > I have worked a bit on porting the H.323 conntrack module to Linux
> > 2.6. Here is my first preview. Both connection tracking and NAT work
> > well in my home network (gnomemeeting and ohphone, tunneling
> > disabled).
> >
> > It's still the old brute force method, no real protocol evaluation is
> > performed. I will implement that the "right" way after the port to th=
e
> > Linux 2.6 API is finished and tested. The current algorithm is not
> > recommended for production environments, because it is insecure,
> > sometimes buggy and horribly inefficient.

> Yes, exactly. That was why I refrained from porting it to 2.6...

> If you want to write a decent helper, then ethereal has got a H.323 (AS=
N)
> decoder written in C, which could probably be re-used. :-)

Yes... but do we really want a big ASN-1 parser in the kernel?
Is there a nice way to have it rely on kernel facilities, while staying i=
n
userspace though?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
