From: "Robert Iakobashvili" <roberti@GoNetworks.com>
Subject: RE: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
	first preview
Date: Wed, 19 Jan 2005 15:08:36 +0200
Message-ID: <699F7BBB368A10479166148511F524177A0FCA@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	"Herve Eychenne" <rv@wallfire.org>, "Max Kellermann" <max@duempel.org>
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

Thank you, Max, for your patches and Jozsef and Herve for discussion.

The architecture where a part of job done in kernel and=20
another in user-space with communication
seems to have its performance penalties (although more flexibility
-similar=20
To layer-7 application classifier project on the top of netfilter).=20

Keeping in mind industry needs, user space intervention
better to be limited by just configuration/settings,=20
putting classification rules/filters like BPF does.

Sincerely,
Robert Iakobashvili
roberti@gonetworks.com
  =20

-----Original Message-----
From: Jozsef Kadlecsik [mailto:kadlec@blackhole.kfki.hu]=20
Sent: Wednesday, January 19, 2005 12:00 PM
To: Herve Eychenne
Cc: Max Kellermann; netfilter-devel@lists.netfilter.org; Robert
Iakobashvili
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
first preview

On Wed, 19 Jan 2005, Herve Eychenne wrote:

> > If you want to write a decent helper, then ethereal has got a H.323=20
> > (ASN) decoder written in C, which could probably be re-used. :-)
>
> Yes... but do we really want a big ASN-1 parser in the kernel?
> Is there a nice way to have it rely on kernel facilities, while=20
> staying in userspace though?

We don't really need the complete parsing of H.225/H.245 and that'd make
the code a little bit simpler.

If ctnetlink would be in the vanilla kernel, we could rely on it as
well:
the H.323 "helper" could just pass the packets to userspace for
inspection and the expectations would then set up from there.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu PGP key :
http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
